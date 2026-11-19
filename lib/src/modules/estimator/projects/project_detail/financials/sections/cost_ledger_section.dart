import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../../widgets/project_format.dart';
import '../logic.dart';
import '../widgets/financial_table.dart';
import '../widgets/financials_card.dart';

/// Cost Ledger — "Cost Ledger by Cost Code" table (Code / Description /
/// Budget / Committed / Actual / ETC / Proj Var / % Used, with a bold
/// Project Total row) and the collapsed "Cost by Location" card.
class CostLedgerSection extends StatelessWidget {
  final FinancialsLogic logic;
  const CostLedgerSection({super.key, required this.logic});

  static const _columns = [
    FinancialColumn('Code', 90),
    FinancialColumn('Description', 110),
    FinancialColumn('Budget', 70, alignRight: true),
    FinancialColumn('Committed', 85, alignRight: true),
    FinancialColumn('Actual', 70, alignRight: true),
    FinancialColumn('ETC', 60, alignRight: true),
    FinancialColumn('Proj Var', 75, alignRight: true),
    FinancialColumn('% Used', 80),
  ];

  Widget _variance(double v) => Text(
        projectMoney(v),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: v < 0 ? AppColors.redColor : null,
        ),
      );

  /// Orange bar with the percentage above it; "—" when there is no budget
  /// to measure against.
  Widget _percentUsed(double? fraction) {
    if (fraction == null) {
      return Text('—', style: TextStyle(fontSize: 10, color: Colors.grey.shade500));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${(fraction * 100).round()}%', style: financialCellStyle),
        const SizedBox(height: 2),
        SizedBox(
          width: 56,
          child: LinearProgressIndicator(
            value: fraction.clamp(0.0, 1.0),
            minHeight: 3,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryOrange),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FinancialsCard(
          title: 'Cost Ledger by Cost Code',
          subtitle: 'Project % complete (area-based): N/A · Cost projections use '
              'time-based forecasting',
          children: [
            Obx(() {
              final total = logic.ledgerTotal;
              return FinancialTable(
                columns: _columns,
                emptyMessage: 'No cost data yet.',
                rows: [
                  for (final r in logic.ledgerRows)
                    [
                      Text(r.code,
                          style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF2B6CB0),
                              fontWeight: FontWeight.w600)),
                      Text(r.description, style: financialCellStyle),
                      Text(projectMoney(r.budget), style: financialCellStyle),
                      Text(projectMoney(r.committed), style: financialCellStyle),
                      Text(projectMoney(r.actual), style: financialCellStyle),
                      Text(projectMoney(r.etc), style: financialCellStyle),
                      _variance(r.projectedVariance),
                      _percentUsed(r.percentUsed),
                    ],
                ],
                footer: [
                  Text(total.code, style: financialCellBoldStyle),
                  const SizedBox.shrink(),
                  Text(projectMoney(total.budget), style: financialCellBoldStyle),
                  Text(projectMoney(total.committed), style: financialCellBoldStyle),
                  Text(projectMoney(total.actual), style: financialCellBoldStyle),
                  Text(projectMoney(total.etc), style: financialCellBoldStyle),
                  _variance(total.projectedVariance),
                  _percentUsed(total.percentUsed),
                ],
              );
            }),
          ],
        ),
        Obx(() => ShowToggleCard(
              title: 'Cost by Location',
              expanded: logic.showCostByLocation.value,
              onToggle: () => logic.showCostByLocation.toggle(),
              emptyMessage: 'No costs assigned to locations yet.',
            )),
      ],
    );
  }
}
