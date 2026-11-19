import 'package:flutter/material.dart';
import '../../../../widgets/pill_tab_group.dart';
import '../logic.dart';
import '../widgets/wf_common.dart';
import 'analytics_tab.dart';
import 'kpi_library_tab.dart';
import 'rate_employee_tab.dart';
import 'rating_history_tab.dart';

/// Performance tab: scrolling sub-tab row + the selected sub-view.
class PerformanceTab extends StatelessWidget {
  const PerformanceTab({super.key, required this.logic});
  final WorkforceLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PillTabGroup<PerformanceSubTab>(
          scrollable: true,
          selectedValue: logic.performanceTab,
          onChanged: logic.setPerformanceTab,
          items:  [
            PillTabItem(value: PerformanceSubTab.rateEmployee,label: 'Rate Employee'),
            PillTabItem(value: PerformanceSubTab.kpiLibrary,label: 'KPI Library'),
            PillTabItem(value: PerformanceSubTab.analytics,label: 'Analytics'),
            PillTabItem(value: PerformanceSubTab.ratingHistory,label: 'Rating History'),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(child: _body()),
      ],
    );
  }

  Widget _body() {
    switch (logic.performanceTab) {
      case PerformanceSubTab.rateEmployee:
        return RateEmployeeTab(logic: logic);
      case PerformanceSubTab.kpiLibrary:
        return KpiLibraryTab(logic: logic);
      case PerformanceSubTab.analytics:
        return AnalyticsTab(logic: logic);
      case PerformanceSubTab.ratingHistory:
        return RatingHistoryTab(logic: logic);
    }
  }
}
