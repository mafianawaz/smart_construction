import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/app_empty_filter.dart';
import '../../../widgets/custom_toggle_switch.dart';
import 'logic.dart';
import 'widgets/cost_action_button.dart';
import 'widgets/cost_filter_card.dart';
import 'widgets/cost_record_card.dart';
import 'widgets/cost_summary_card.dart';

class HistoricalCostView extends StatelessWidget {
  const HistoricalCostView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HistoricalCostLogic(),
      builder: (logic){
      return Scaffold(
        appBar: AppPrimaryBar(
          title: 'Historical Cost',
          showBackButton: true,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Browse and search actual costs from completed projects', style: TextStyle(fontSize: 12, color: AppColors.textMuted),),
                const SizedBox(height: 14),
                CostActionButton(
                  label: 'Add Cost Record',
                  icon: Icons.add,
                  onPressed: logic.openAddRecord,
                ),
                const SizedBox(height: 14),
                CostFilterCard(logic: logic),
                const SizedBox(height: 14),
                Obx(() => CustomToggle(
                    options: const ['Summary', 'Detailed Records'],
                    selectedIndex: logic.tabIndex.value,
                    onChanged: (i) => logic.tabIndex.value = i,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                      () => logic.tabIndex.value == 0
                      ? _SummaryTab(logic: logic)
                      : _DetailedTab(logic: logic),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(subtitle,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _SummaryTab extends StatelessWidget {
  final HistoricalCostLogic logic;
  const _SummaryTab({required this.logic});

  @override
  Widget build(BuildContext context) {
    final groups = logic.summaries;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          title: 'Cost Summary by Scope & Trade',
          subtitle: 'Aggregated unit costs with min/max/average breakdown',
        ),
        if (groups.isEmpty)
          const AppEmptyState(
            icon: Icons.bar_chart_rounded,
            title: 'No cost data',
            message: 'No records match your filters.',
          )
        else
          for (final g in groups) ...[
            CostSummaryCard(group: g),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _DetailedTab extends StatelessWidget {
  final HistoricalCostLogic logic;
  const _DetailedTab({required this.logic});

  @override
  Widget build(BuildContext context) {
    final items = logic.filtered;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          title: 'Individual Cost Records',
          subtitle: 'Detailed line-item costs from completed projects',
        ),
        if (items.isEmpty)
          const AppEmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'No cost records',
            message: 'Add a record or adjust your filters.',
          )
        else
          for (final r in items) ...[
            CostRecordCard(record: r, onDelete: () => logic.confirmDelete(r)),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}
