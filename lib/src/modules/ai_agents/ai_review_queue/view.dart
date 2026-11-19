import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import 'logic.dart';
import 'models/ai_review_models.dart';
import 'review_detail/view.dart';
import 'widgets/aiq_basics.dart';
import 'widgets/aiq_list_extras.dart';
import 'widgets/aiq_palette.dart';
import 'widgets/aiq_queue_card.dart';


/// AI Review Queue list: stats, filters, draft cards, bulk accept, legend and
/// the Approvals link card.
class AiReviewQueueView extends StatefulWidget {
  const AiReviewQueueView({super.key});

  @override
  State<AiReviewQueueView> createState() => _AiReviewQueueViewState();
}

class _AiReviewQueueViewState extends State<AiReviewQueueView> {
  final ScrollController scroll = ScrollController();

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AiReviewQueueLogic>(
      init: AiReviewQueueLogic(),
      builder: (logic) {
        final items = logic.visibleItems;
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'AI Review Queue',
            showBackButton: true,
            centerTitle: true,
          ),
          body: ListView(
            controller: scroll,
            padding: const EdgeInsets.all(15),
            children: [
              const AiqHeader(
                crumbs: ['Projects', 'AI Review Queue'],
                title: 'AI Review Queue',
              ),
              const SizedBox(height: 14),
              AiqBulkAcceptBar(
                selectedCount: logic.selectedCount,
                onPressed: () => _bulkAccept(logic),
              ),
              const SizedBox(height: 12),
              _StatsGrid(logic: logic),
              const SizedBox(height: 14),
              _FilterBar(logic: logic),
              const SizedBox(height: 14),
              if (items.isEmpty)
                AiqEmptyState(
                  title: logic.hasActiveFilters
                      ? 'No drafts match these filters'
                      : 'Queue is clear',
                  message: logic.hasActiveFilters
                      ? 'Try widening or clearing the filters.'
                      : 'There are no AI drafts waiting for review.',
                  actionLabel:
                      logic.hasActiveFilters ? 'Clear filters' : null,
                  onAction: logic.clearFilters,
                )
              else
                for (final item in items)
                  AiqQueueCard(
                    key: ValueKey(item.id),
                    item: item,
                    selected: logic.isSelected(item.id),
                    onToggleSelect: () {
                      if (!logic.toggleSelect(item.id)) {
                        _toast(
                          'Human-gated drafts can’t be bulk accepted.',
                        );
                      }
                    },
                    onAccept: () {
                      logic.accept(item.id);
                      _toast('Accepted: ${item.shortTitle}');
                    },
                    onEdit: () => _openReview(item.id),
                    // Reject needs a reason (Draft Review sheet, G-04), so it
                    // opens the sheet where the reason is collected.
                    onReject: () => _openReview(item.id),
                  ),
              const SizedBox(height: 4),
              const Text(
                'Sorted by \$ at stake (desc). Reject requires a reason '
                '(Draft Review sheet, G-04). Bulk accept is disabled for '
                'human-gated types.',
                style: TextStyle(
                  fontSize: 12,
                  color: AiqPalette.muted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              const AiqItemTypesLegend(),
              const SizedBox(height: 20),
              AiqApprovalsLinkCard(
                awaiting: logic.pendingCount,
                humanGated: logic.humanGatedPendingCount,
                // On the real Approvals page this is
                // `Get.to(() => const AiReviewQueueView())`; here we are
                // already on the queue, so it scrolls back to the top.
                onOpen: () => scroll.animateTo(
                  0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _bulkAccept(AiReviewQueueLogic logic) {
    final n = logic.bulkAccept();
    if (n > 0) _toast('Accepted $n draft${n == 1 ? '' : 's'}');
  }

  void _openReview(String id) {
    Get.to(() => AiReviewDetailView(reviewId: id));
  }

  void _toast(String message) {
    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.logic});
  final AiReviewQueueLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AiqStatCard(label: 'Pending', value: logic.pendingCount),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AiqStatCard(label: 'Edited (7 d)', value: logic.editedWeek),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AiqStatCard(
                label: 'Approved (7 d)',
                value: logic.approvedWeek,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AiqStatCard(
                label: 'Rejected (7 d)',
                value: logic.rejectedWeek,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.logic});
  final AiReviewQueueLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            AiqFilterPill(
              label: 'Agent',
              value: logic.agentFilter?.code ?? 'All',
              onTap: () async {
                final r = await showAiqPicker<ReviewAgent?>(
                  context,
                  title: 'Agent',
                  selected: logic.agentFilter,
                  options: [
                    const AiqPickerOption<ReviewAgent?>('All', null),
                    for (final a in ReviewAgent.values)
                      AiqPickerOption<ReviewAgent?>(
                        '${a.code} · ${a.roleName}',
                        a,
                      ),
                  ],
                );
                if (r != null) logic.setAgent(r.value);
              },
            ),
            AiqFilterPill(
              label: 'Item type',
              value: logic.typeFilter?.wire ?? 'All',
              onTap: () async {
                final r = await showAiqPicker<ReviewItemType?>(
                  context,
                  title: 'Item type',
                  selected: logic.typeFilter,
                  options: [
                    const AiqPickerOption<ReviewItemType?>('All', null),
                    for (final t in ReviewItemType.values)
                      AiqPickerOption<ReviewItemType?>(t.wire, t),
                  ],
                );
                if (r != null) logic.setType(r.value);
              },
            ),
            AiqFilterPill(
              label: 'Project',
              value: logic.projectFilter ?? 'All',
              onTap: () async {
                final r = await showAiqPicker<String?>(
                  context,
                  title: 'Project',
                  selected: logic.projectFilter,
                  options: [
                    const AiqPickerOption<String?>('All', null),
                    for (final p in logic.projectOptions)
                      AiqPickerOption<String?>(p, p),
                  ],
                );
                if (r != null) logic.setProject(r.value);
              },
            ),
            AiqFilterPill(
              label: 'Requester',
              value: logic.requesterFilter ?? 'All',
              onTap: () async {
                final r = await showAiqPicker<String?>(
                  context,
                  title: 'Requester',
                  selected: logic.requesterFilter,
                  options: [
                    const AiqPickerOption<String?>('All', null),
                    for (final n in logic.requesterOptions)
                      AiqPickerOption<String?>(n, n),
                  ],
                );
                if (r != null) logic.setRequester(r.value);
              },
            ),
            AiqFilterPill(
              label: 'Age',
              value: logic.ageFilter.label,
              onTap: () async {
                final r = await showAiqPicker<AgeBucket>(
                  context,
                  title: 'Age',
                  selected: logic.ageFilter,
                  options: [
                    for (final b in AgeBucket.values)
                      AiqPickerOption<AgeBucket>(b.label, b),
                  ],
                );
                if (r != null) logic.setAge(r.value);
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Switch(
              value: logic.humanGateOnly,
              onChanged: logic.setHumanGateOnly,
              activeColor: Colors.white,
              activeTrackColor: AiqPalette.green,
            ),
            const SizedBox(width: 4),
            const Text(
              'Human-gate only',
              style: TextStyle(fontSize: 12.5, color: AiqPalette.text),
            ),
          ],
        ),
      ],
    );
  }
}
