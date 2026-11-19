import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../logic.dart';
import '../models/ai_review_models.dart';

/// Form state for one open Draft Review sheet.
///
/// Tagged per review id (`tag: item.id`) so several sheets can never collide.
/// Disposal is wired at the view layer (`GetBuilder.dispose`), not in here.
class ReviewSheetLogic extends GetxController {
  ReviewSheetLogic(this.item, this.queue);

  final ReviewItem item;
  final AiReviewQueueLogic queue;

  final Map<String, TextEditingController> fieldControllers =
      <String, TextEditingController>{};
  late final TextEditingController editedController;
  late final TextEditingController noteController;

  CorrectionReason? reason;
  bool useAsExample = true;
  bool snapshotOpen = true;
  String? error;

  static const int noteMaxLength = 200;

  @override
  void onInit() {
    super.onInit();
    for (final f in item.draftFields) {
      fieldControllers[f.id] = TextEditingController(text: f.value)
        ..addListener(_onTextChanged);
    }
    editedController = TextEditingController(text: item.originalText)
      ..addListener(_onTextChanged);
    noteController = TextEditingController();
  }

  @override
  void onClose() {
    for (final c in fieldControllers.values) {
      c.dispose();
    }
    editedController.dispose();
    noteController.dispose();
    super.onClose();
  }

  void _onTextChanged() => update();

  // ── derived ──────────────────────────────────────────────────────────────

  bool get editedTextChanged =>
      editedController.text.trim() != item.originalText.trim();

  Map<String, String> get changedFields {
    final out = <String, String>{};
    for (final f in item.draftFields) {
      if (!f.editable) continue;
      final now = fieldControllers[f.id]?.text ?? f.value;
      if (now.trim() != f.value.trim()) out[f.id] = now.trim();
    }
    return out;
  }

  bool get isDirty => changedFields.isNotEmpty || editedTextChanged;

  // ── input ────────────────────────────────────────────────────────────────

  void setReason(CorrectionReason r) {
    reason = r;
    error = null;
    update();
  }

  void setUseAsExample(bool v) {
    useAsExample = v;
    update();
  }

  void toggleSnapshot() {
    snapshotOpen = !snapshotOpen;
    update();
  }

  // ── actions (return true when the sheet may close) ───────────────────────

  /// Accept the AI draft exactly as it is.
  bool accept() {
    if (isDirty) {
      return _fail(
        'You have unsaved edits — use Save edits & accept, or close to discard them.',
      );
    }
    queue.applyDecision(
      item.id,
      const ReviewDecision(action: ReviewAction.accept),
    );
    return true;
  }

  bool saveEditsAndAccept() {
    if (!isDirty) return _fail('Nothing has been edited yet.');
    if (reason == null) {
      return _fail('Pick a correction reason (required on edit or reject).');
    }
    for (final f in item.draftFields) {
      if (f.required && (fieldControllers[f.id]?.text.trim().isEmpty ?? true)) {
        return _fail('${f.label} is required.');
      }
    }
    queue.applyDecision(
      item.id,
      ReviewDecision(
        action: ReviewAction.saveEditsAccept,
        reason: reason,
        note: _note,
        useAsExample: useAsExample,
        editedFields: changedFields,
        editedText: editedTextChanged ? editedController.text.trim() : null,
      ),
    );
    return true;
  }

  bool reject() {
    if (reason == null) {
      return _fail('Pick a correction reason (required on edit or reject).');
    }
    queue.applyDecision(
      item.id,
      ReviewDecision(
        action: ReviewAction.reject,
        reason: reason,
        note: _note,
        useAsExample: useAsExample,
      ),
    );
    return true;
  }

  bool sendToAttorney() {
    if (!item.legalFraming) return _fail('Only finance drafts can be sent.');
    queue.applyDecision(
      item.id,
      ReviewDecision(action: ReviewAction.sendToAttorney, note: _note),
    );
    return true;
  }

  String? get _note {
    final t = noteController.text.trim();
    return t.isEmpty ? null : t;
  }

  bool _fail(String message) {
    error = message;
    update();
    return false;
  }
}
