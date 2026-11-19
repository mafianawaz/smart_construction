import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/pill_tab_group.dart';

import 'logic.dart';
import 'models/rollup_enums.dart';
import 'widgets/financial_project_card.dart';
import 'widgets/gantt_row.dart';
import 'widgets/heatmap_project_card.dart';
import 'widgets/rollup_empty_state.dart';
import 'widgets/rollup_filters_panel.dart';
import 'widgets/rollup_header.dart';
import 'widgets/rollup_palette.dart';
import 'widgets/rollup_status_chips.dart';
import 'widgets/rollup_summary_row.dart';
import 'widgets/rollup_tab_bar.dart';


class PortfolioRollupView extends StatelessWidget {
  const PortfolioRollupView({super.key});

  Future<void> _export(PortfolioRollupLogic logic) async {
    final csv = logic.buildExportCsv();
    // Export seam: clipboard for now, see PortfolioRollupLogic.buildExportCsv.
    await Clipboard.setData(ClipboardData(text: csv));
    Get.snackbar(
      'Export Summary',
      '${logic.filtered.length} projects copied as CSV',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PortfolioRollupLogic>(
      init: PortfolioRollupLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Portfolio Rollup',
            showBackButton: true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _export(logic),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RollupPalette.orange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(0, 34),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Export Summary'),
                ),
              ),
            ]
          ),
          body: CustomScrollView(slivers: _slivers(logic)),
        );
      },
    );
  }

  List<Widget> _slivers(PortfolioRollupLogic logic) {
    final tab = logic.tab;
    final isHeatmap = tab == RollupTab.heatmap;
    final items = logic.filtered;

    return [
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text('Cross-project health, schedule, and financial view for executives',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),),
      ),),

      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: PillTabGroup(
              items: RollupTab.values.map((tab) => PillTabItem<RollupTab>(
                value: tab,
                label: tab.label,
              ),
              ).toList(),
              selectedValue: tab,
              onChanged: logic.selectTab
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: RollupStatusChips(
          statuses: logic.availableStatuses(tab),
          selected: logic.selectedStatuses(tab),
          onToggle: logic.toggleStatus,
          style: isHeatmap ? RollupChipStyle.outlined : RollupChipStyle.colored,
        ),
      ),
      SliverToBoxAdapter(
        child: RollupFiltersPanel(
          layout: isHeatmap
              ? RollupFiltersLayout.stacked
              : RollupFiltersLayout.compact,
          pmOptions: logic.pmOptions,
          pm: logic.pm,
          startAfter: logic.startAfter,
          endBefore: logic.endBefore,
          minHealth: logic.minHealth,
          hasActiveFilters: logic.hasActiveFilters,
          onPmChanged: logic.setPm,
          onStartAfterChanged: logic.setStartAfter,
          onEndBeforeChanged: logic.setEndBefore,
          onMinHealthChanged: logic.setMinHealth,
          onClear: logic.clearFilters,
        ),
      ),
      if (isHeatmap)
        SliverToBoxAdapter(child: RollupSummaryRow(summary: logic.summary)),
      const SliverToBoxAdapter(child: _SectionTitle('All Projects')),
      if (logic.isLoading)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: CircularProgressIndicator(color: RollupPalette.orange),
            ),
          ),
        )
      else if (items.isEmpty)
        SliverToBoxAdapter(
          child: RollupEmptyState(
            onClear: logic.hasActiveFilters ? logic.clearFilters : null,
          ),
        )
      else
        (switch (tab) {
          RollupTab.heatmap => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => HeatmapProjectCard(project: items[i]),
              ),
            ),
          RollupTab.gantt => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // One rounded, bordered card holding every row. Built eagerly
                // (a Column, not a lazy list): fine for hundreds of light rows,
                // revisit with paging when the real API lands.
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: RollupPalette.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (var i = 0; i < items.length; i++)
                        GanttRow(
                          project: items[i],
                          segment: logic.ganttSegment(items[i]),
                          showDivider: i != items.length - 1,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          RollupTab.financial => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) =>
                    FinancialProjectCard(project: items[i]),
              ),
            ),
        }),
      const SliverToBoxAdapter(child: SizedBox(height: 24)),
    ];
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: RollupPalette.text,
        ),
      ),
    );
  }
}
