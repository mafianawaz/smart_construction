import 'package:get/get.dart';

import 'data/ai_review_mock_data.dart';
import 'models/ai_review_models.dart';


/// Controller for the AI Review Queue list.
///
/// Uses plain fields + `update()` (GetBuilder), matching `PricingLogic`.
/// Create it with `GetBuilder<AiReviewQueueLogic>(init: AiReviewQueueLogic())`
/// or fetch it with [AiReviewQueueLogic.ensure].
class AiReviewQueueLogic extends GetxController {
  /// The detail screen can be opened from a deep link (`?review=rv_8812`)
  /// before the list was ever built, so it registers the controller itself.
  static AiReviewQueueLogic ensure() => Get.isRegistered<AiReviewQueueLogic>()
      ? Get.find<AiReviewQueueLogic>()
      : Get.put(AiReviewQueueLogic());

  List<ReviewItem> _items = <ReviewItem>[];

  // 7-day counters (Pending is derived from the list).
  int _editedWeek = 0;
  int _approvedWeek = 0;
  int _rejectedWeek = 0;

  // Filters
  ReviewAgent? agentFilter;
  ReviewItemType? typeFilter;
  String? projectFilter;
  String? requesterFilter;
  AgeBucket ageFilter = AgeBucket.all;
  bool humanGateOnly = false;

  final Set<String> _selected = <String>{};

  DateTime get now => AiReviewMockData.now;

  @override
  void onInit() {
    super.onInit();
    // API seam: GET /api/ai-review/queue and /api/ai-review/stats?days=7
    _items = AiReviewMockData.queue();
    _editedWeek = AiReviewMockData.weekStats['edited'] ?? 0;
    _approvedWeek = AiReviewMockData.weekStats['approved'] ?? 0;
    _rejectedWeek = AiReviewMockData.weekStats['rejected'] ?? 0;
    if (AiReviewMockData.preselectDemo) {
      _selected.addAll(AiReviewMockData.demoSelectedIds);
    }
  }

  // ── stats ────────────────────────────────────────────────────────────────

  List<ReviewItem> get _awaiting =>
      _items.where((i) => i.status.awaitingReview).toList();

  int get pendingCount => _awaiting.length;
  int get humanGatedPendingCount =>
      _awaiting.where((i) => i.humanGated).length;
  int get editedWeek => _editedWeek;
  int get approvedWeek => _approvedWeek;
  int get rejectedWeek => _rejectedWeek;

  // ── list ─────────────────────────────────────────────────────────────────

  /// Awaiting items after filters, sorted by $ at stake (desc).
  List<ReviewItem> get visibleItems {
    final list = _awaiting.where((i) {
      if (agentFilter != null && i.agent != agentFilter) return false;
      if (typeFilter != null && i.type != typeFilter) return false;
      if (projectFilter != null && i.project != projectFilter) return false;
      if (requesterFilter != null && i.requester != requesterFilter) {
        return false;
      }
      if (humanGateOnly && !i.humanGated) return false;
      if (!ageFilter.matches(now.difference(i.requestedAt))) return false;
      return true;
    }).toList();
    list.sort((a, b) => b.amountAtStake.compareTo(a.amountAtStake));
    return list;
  }

  bool get hasActiveFilters =>
      agentFilter != null ||
      typeFilter != null ||
      projectFilter != null ||
      requesterFilter != null ||
      ageFilter != AgeBucket.all ||
      humanGateOnly;

  List<String> get projectOptions =>
      (_items.map((i) => i.project).toSet().toList())..sort();

  List<String> get requesterOptions =>
      (_items.map((i) => i.requester).toSet().toList())..sort();

  ReviewItem? itemById(String id) {
    for (final i in _items) {
      if (i.id == id) return i;
    }
    return null;
  }

  /// Rows for the compact list above the inline sheet: the open item first,
  /// then the rest of the queue by $ at stake.
  List<ReviewItem> compactRowsFor(String openId, {int max = 4}) {
    final rest = _awaiting.where((i) => i.id != openId).toList()
      ..sort((a, b) => b.amountAtStake.compareTo(a.amountAtStake));
    final open = itemById(openId);
    return <ReviewItem>[if (open != null) open, ...rest].take(max).toList();
  }

  // ── filters ──────────────────────────────────────────────────────────────

  void setAgent(ReviewAgent? v) {
    agentFilter = v;
    update();
  }

  void setType(ReviewItemType? v) {
    typeFilter = v;
    update();
  }

  void setProject(String? v) {
    projectFilter = v;
    update();
  }

  void setRequester(String? v) {
    requesterFilter = v;
    update();
  }

  void setAge(AgeBucket v) {
    ageFilter = v;
    update();
  }

  void setHumanGateOnly(bool v) {
    humanGateOnly = v;
    update();
  }

  void clearFilters() {
    agentFilter = null;
    typeFilter = null;
    projectFilter = null;
    requesterFilter = null;
    ageFilter = AgeBucket.all;
    humanGateOnly = false;
    update();
  }

  // ── selection / bulk accept ──────────────────────────────────────────────

  bool isSelected(String id) => _selected.contains(id);

  /// Selected items that are still in the queue and eligible for bulk accept.
  List<ReviewItem> get _bulkEligibleSelected => _awaiting
      .where((i) => _selected.contains(i.id) && !i.humanGated)
      .toList();

  int get selectedCount => _bulkEligibleSelected.length;

  /// Returns false (and does nothing) for human-gated items.
  bool toggleSelect(String id) {
    final item = itemById(id);
    if (item == null || item.humanGated) return false;
    if (!_selected.remove(id)) _selected.add(id);
    update();
    return true;
  }

  /// API seam: POST /api/ai-review/bulk-accept { ids: [...] }
  int bulkAccept() {
    final targets = _bulkEligibleSelected;
    for (final item in targets) {
      _setStatus(item.id, (i) => i.copyWith(status: ReviewStatus.approved));
      _approvedWeek++;
      _selected.remove(item.id);
    }
    update();
    return targets.length;
  }

  // ── decisions ────────────────────────────────────────────────────────────

  /// Quick accept straight from a card (accepts the AI draft as is).
  void accept(String id) =>
      applyDecision(id, const ReviewDecision(action: ReviewAction.accept));

  /// API seam: PATCH /api/ai-review/{id}
  /// { action, reason, note, useAsExample, editedFields, editedText }
  void applyDecision(String id, ReviewDecision d) {
    final item = itemById(id);
    if (item == null || !item.status.awaitingReview) return;

    switch (d.action) {
      case ReviewAction.accept:
        _setStatus(id, (i) => i.copyWith(status: ReviewStatus.approved));
        _approvedWeek++;
        break;
      case ReviewAction.saveEditsAccept:
        _setStatus(
          id,
          (i) => i.copyWith(
            status: ReviewStatus.approved,
            draftFields: _applyFieldEdits(i.draftFields, d.editedFields),
            correctionReason: d.reason,
            note: d.note,
            useAsExample: d.useAsExample,
            editedText: d.editedText,
          ),
        );
        _approvedWeek++;
        _editedWeek++;
        break;
      case ReviewAction.reject:
        _setStatus(
          id,
          (i) => i.copyWith(
            status: ReviewStatus.rejected,
            correctionReason: d.reason,
            note: d.note,
            useAsExample: d.useAsExample,
          ),
        );
        _rejectedWeek++;
        break;
      case ReviewAction.sendToAttorney:
        _setStatus(
          id,
          (i) => i.copyWith(status: ReviewStatus.attorneyReview, note: d.note),
        );
        break;
    }
    _selected.remove(id);
    update();
  }

  List<DraftField> _applyFieldEdits(
    List<DraftField> fields,
    Map<String, String> edits,
  ) {
    return fields
        .map(
          (f) => edits.containsKey(f.id)
              ? DraftField(
                  id: f.id,
                  label: f.label,
                  value: edits[f.id]!,
                  kind: f.kind,
                  required: f.required,
                )
              : f,
        )
        .toList();
  }

  void _setStatus(String id, ReviewItem Function(ReviewItem) change) {
    _items = _items.map((i) => i.id == id ? change(i) : i).toList();
  }
}
