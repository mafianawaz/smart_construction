import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/project_format.dart';
import '../logic.dart';
import '../widgets/financial_table.dart';
import '../widgets/financials_card.dart';

/// Budget — "Project Budget by Cost Code" table (scrolls sideways; empty
/// message until budget lines exist) and the collapsed "Takeoff Cost by
/// Location" card.
class BudgetSection extends StatelessWidget {
  final FinancialsLogic logic;
  const BudgetSection({super.key, required this.logic});

  static const _columns = [
    FinancialColumn('Cost Code', 80),
    FinancialColumn('Description', 130),
    FinancialColumn('Division', 80),
    FinancialColumn('Labor', 70, alignRight: true),
    FinancialColumn('Materials', 80, alignRight: true),
    FinancialColumn('Subcontractors', 100, alignRight: true),
    FinancialColumn('Equipment', 80, alignRight: true),
    FinancialColumn('Other', 70, alignRight: true),
    FinancialColumn('Total', 80, alignRight: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FinancialsCard(
          title: 'Project Budget by Cost Code',
          subtitle: 'Define budget allocations per cost code across labor, materials, '
              'subcontractors, equipment, and other.',
          children: [
            Obx(() => FinancialTable(
                  columns: _columns,
                  emptyMessage: 'No budget lines defined yet.',
                  rows: [
                    for (final l in logic.budgetLines)
                      [
                        Text(l.costCode, style: financialCellStyle),
                        Text(l.description, style: financialCellStyle),
                        Text(l.division, style: financialCellStyle),
                        Text(projectMoney(l.labor), style: financialCellStyle),
                        Text(projectMoney(l.materials), style: financialCellStyle),
                        Text(projectMoney(l.subcontractors), style: financialCellStyle),
                        Text(projectMoney(l.equipment), style: financialCellStyle),
                        Text(projectMoney(l.other), style: financialCellStyle),
                        Text(projectMoney(l.total), style: financialCellBoldStyle),
                      ],
                  ],
                )),
          ],
        ),
        Obx(() => ShowToggleCard(
              title: 'Takeoff Cost by Location',
              expanded: logic.showTakeoffByLocation.value,
              onToggle: () => logic.showTakeoffByLocation.toggle(),
              emptyMessage: 'No takeoff costs by location yet.',
            )),
      ],
    );
  }
}
