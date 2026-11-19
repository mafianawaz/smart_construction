import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';
import '../../../../utils/app_icons.dart';
import '../../../../widgets/app_button.dart';
import '../logic.dart';
import '../widgets/kpi_assignment_widgets.dart';

/// KPI Management → Assignments.
/// Returns a Column because it is spliced into KpiLibraryTab's ListView.
class KpiAssignmentsSection extends StatelessWidget {
  const KpiAssignmentsSection({super.key, required this.logic});
  final WorkforceLogic logic;

  @override
  Widget build(BuildContext context) {
    final list = logic.filteredAssignments;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomDropdown<String>(
                value: logic.assignmentEmployeeFilter,
                items: logic.assignmentEmployeeOptions,
                itemLabel: (v) => v,
                onChanged: (v) {
                  if (v != null) logic.setAssignmentEmployeeFilter(v);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomDropdown<String>(
                value: logic.assignmentKpiFilter,
                items: logic.assignmentKpiOptions,
                itemLabel: (v) => v,
                onChanged: (v) {
                  if (v != null) logic.setAssignmentKpiFilter(v);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 135,
            child: CustomIconButton(
              text: 'Assign KPI',
              icon: AppIcons.add,
              onPressed: logic.openAssignKpi,
            ),
          ),
        ),
        const SizedBox(height: 14),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: AppEmptyState(
              icon: Icons.assignment_ind_outlined,
              title: 'No assignments',
              message: 'Assign a KPI to an employee to start tracking it.',
              showButton: false,
            ),
          )
        else
          for (final a in list) KpiAssignmentCard(assignment: a),
      ],
    );
  }
}
