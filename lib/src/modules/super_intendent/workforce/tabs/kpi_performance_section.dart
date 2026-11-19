import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';
import '../logic.dart';
import '../models/kpi_model.dart';
import '../widgets/kpi_assignment_widgets.dart';
import '../widgets/wf_common.dart';
import '../widgets/wf_palette.dart';

/// KPI Management → Performance (per-employee results for a period).
/// Returns a Column because it is spliced into KpiLibraryTab's ListView.
class KpiPerformanceSection extends StatelessWidget {
  const KpiPerformanceSection({super.key, required this.logic});
  final WorkforceLogic logic;

  @override
  Widget build(BuildContext context) {
    final results = logic.perfResults;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 6),
          child: Text(
            'Select Employee',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: WfPalette.text),
          ),
        ),
        if (logic.perfEmployee != null)
          CustomDropdown<KpiEmployee>(
            value: logic.perfEmployee!,
            items: logic.employees,
            itemLabel: (e) => e.label,
            onChanged: (v) {
              if (v != null) logic.setPerfEmployee(v);
            },
          ),
        const SizedBox(height: 12),
        PerformanceOverviewCard(
          period: logic.perfPeriod,
          periodOptions: logic.periods,
          onPeriodChanged: logic.setPerfPeriod,
          overallPercent: logic.perfOverallPercent,
          assigned: results.length,
          completed: logic.perfCompleted,
          pending: logic.perfPending,
        ),
        for (final r in results) KpiResultCard(result: r),
        if (results.isEmpty)
          const WfDashedBox(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Text(
              'No KPIs assigned to this employee yet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: WfPalette.hint),
            ),
          ),
      ],
    );
  }
}
