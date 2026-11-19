import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/modules/super_intendent/reports/models/report_models.dart';
import 'logic.dart';
import 'widgets/report_action_chips.dart';
import 'widgets/report_empty_card.dart';
import 'widgets/report_picker_card.dart';
import 'widgets/report_selector_field.dart';
import 'widgets/report_sheets.dart';
import 'widgets/report_table_card.dart';
import 'widgets/reports_header.dart';
import 'widgets/reports_palette.dart';

class SuperInReportsView extends StatelessWidget {
  const SuperInReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportsLogic>(
      init: ReportsLogic(),
      builder: (logic) {
        return Scaffold(
          backgroundColor: ReportsPalette.background,
          body: SafeArea(
            child: Column(
              children: [
                ReportsHeader(
                  title: 'Reports',
                  onBack: () => Get.back(),
                  onAction: logic.exportReport,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      ReportSelectorField(
                        label: logic.selected.label,
                        onTap: () async {
                          final picked = await showReportPickerSheet(
                            context,
                            reports: logic.reports,
                            selected: logic.selected,
                          );
                          if (picked != null) logic.selectReport(picked);
                        },
                      ),
                      const SizedBox(height: 12),
                      ReportActionChips(
                        filtersActive: logic.filters.isActive,
                        onExpand: logic.toggleExpandAll,
                        onReset: logic.reset,
                        onPrint: logic.printReport,
                        onDataFilters: () async {
                          final next = await showReportFiltersSheet(
                            context,
                            projects: logic.projects,
                            current: logic.filters,
                          );
                          if (next != null) logic.applyFilters(next);
                        },
                      ),
                      const SizedBox(height: 16),
                      ReportPickerCard(
                        reports: logic.reports,
                        selected: logic.selected,
                        isExpanded: logic.isExpanded,
                        onToggleGroup: logic.toggleGroup,
                        onSelect: logic.selectReport,
                      ),
                      const SizedBox(height: 16),
                      if (logic.table == null)
                        const ReportEmptyCard()
                      else
                        ReportTableCard(
                          title: logic.selected.label,
                          caption:
                              '${logic.selectedProjectName ?? 'All projects'} · ${logic.filters.range.label}',
                          table: logic.table!,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
