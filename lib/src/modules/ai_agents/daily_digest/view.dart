import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/app_appbar.dart';
import 'logic.dart';
import 'models/digest_format.dart';
import 'widgets/dd_conflict_card.dart';
import 'widgets/dd_empty_state.dart';
import 'widgets/dd_header.dart';
import 'widgets/dd_item_card.dart';
import 'widgets/dd_palette.dart';
import 'widgets/dd_select_field.dart';
import 'widgets/dd_stale_banner.dart';
import 'widgets/dd_summary_block.dart';

/// AI Agents → Daily Digest.
///
/// States:
///  - populated           → conflicts first, then ranked items
///  - nothing today       → "Nothing needs you today"
///  - cap reached         → "See all N in AI Flags & Conflicts" link
///  - stale schedule      → banner with "Update progress now"
class DailyDigestView extends StatelessWidget {
  const DailyDigestView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DailyDigestLogic>(
      init: DailyDigestLogic(),
      builder: (logic) {
        final digest = logic.digest;
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Daily Digest',
            showBackButton: true,
            centerTitle: true,
          ),
          body: logic.isLoading || digest == null
              ? const Center(
                  child: CircularProgressIndicator(color: DdPalette.primary),
                )
              : ListView(
                  padding: const EdgeInsets.all(15),
                  children: [
                    DdHeader(
                      title: 'Daily Digest — '
                          '${DigestFormat.longDate(logic.selectedDate)}',
                      onHomeTap: () => Get.until((route) => route.isFirst),
                      onAiAgentsTap: () => Get.back(),
                    ),
                    const SizedBox(height: 14),
                    DdSelectField(
                      label: 'Date:',
                      value: '${DigestFormat.longDate(logic.selectedDate)}'
                          ' · (90-day history)',
                      inlineLabel: true,
                      onTap: () => _pickDate(context, logic),
                    ),
                    if (logic.isAdmin) ...[
                      const SizedBox(height: 12),
                      PopupMenuButton<String>(
                        onSelected: logic.setRole,
                        padding: EdgeInsets.zero,
                        itemBuilder: (_) => [
                          for (final r in logic.roleOptions)
                            PopupMenuItem<String>(value: r, child: Text(r)),
                        ],
                        child: DdSelectField(
                          label: 'View as role (AD only):',
                          value: logic.selectedRole,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    DdSummaryBlock(
                      shownCount: logic.shownCount,
                      totalCount: logic.totalCount,
                      roleCap: digest.roleCap,
                      delivery: digest.delivery,
                    ),
                    if (digest.staleBanner != null) ...[
                      const SizedBox(height: 14),
                      DdStaleBanner(
                        message: digest.staleBanner!.message,
                        onUpdateTap: logic.updateProgress,
                      ),
                    ],
                    const SizedBox(height: 18),
                    if (logic.isNothingToday)
                      const DdEmptyState()
                    else ...[
                      if (logic.conflicts.isNotEmpty) ...[
                        const _SectionTitle(
                          'Conflicts (shown above ordinary items)',
                        ),
                        const SizedBox(height: 10),
                        for (final c in logic.conflicts) ...[
                          DdConflictCard(
                            conflict: c,
                            acknowledged: logic.isAcknowledged(c.id),
                            onOpen: () => logic.openConflict(c),
                            onAcknowledge: () => logic.acknowledge(c.id),
                            onAssign: () => logic.assign(c.id),
                          ),
                          const SizedBox(height: 12),
                        ],
                        const SizedBox(height: 6),
                      ],
                      if (logic.visibleItems.isNotEmpty) ...[
                        const _SectionTitle('Ranked items'),
                        const SizedBox(height: 10),
                        for (var i = 0; i < logic.visibleItems.length; i++) ...[
                          DdItemCard(
                            rank: i + 1,
                            item: logic.visibleItems[i],
                            acknowledged: logic.isAcknowledged(logic.visibleItems[i].id),
                            onOpen: () => logic.openItem(logic.visibleItems[i]),
                            onAcknowledge: () => logic.acknowledge(logic.visibleItems[i].id),
                            onSnooze: (days) => logic.snooze(logic.visibleItems[i], days),
                            onAssign: () => logic.assign(logic.visibleItems[i].id),
                            onBasisTap: () => logic.openBasis(logic.visibleItems[i]),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ],
                    if (logic.capReached)
                      GestureDetector(
                        onTap: logic.seeAllFlags,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'See all ${logic.totalCount} in AI Flags & '
                            'Conflicts →',
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: DdPalette.primary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }

  Future<void> _pickDate(BuildContext context, DailyDigestLogic logic) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: logic.selectedDate,
      firstDate: logic.earliestDate,
      lastDate: logic.today,
    );
    if (picked != null) {
      await logic.setDate(picked);
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: DdPalette.textPrimary,
      ),
    );
  }
}
