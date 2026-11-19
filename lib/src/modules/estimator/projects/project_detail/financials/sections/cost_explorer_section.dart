import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../../models/project_enums.dart';
import '../../widgets/project_date_field.dart';
import '../../widgets/project_format.dart';
import '../../widgets/project_select_field.dart';
import '../logic.dart';
import '../widgets/financials_card.dart';

/// Cost Explorer — info card, "Filters & Grouping" (category, module, cost
/// code search, from/to dates, grouping, Reset), the grouped Summary card
/// and the Transactions card. Every list is empty in the reference.
class CostExplorerSection extends StatelessWidget {
  final FinancialsLogic logic;
  const CostExplorerSection({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FinancialsCard(
          children: [
            Text(
              'No cost transactions recorded yet. Costs will appear here as PO receipts, '
              'payroll runs, T&M tickets, and other cost events are processed.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
        FinancialsCard(
          title: 'Filters & Grouping',
          trailing: InkWell(
            onTap: logic.resetExplorerFilters,
            child: const Text('Reset',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryOrange)),
          ),
          children: [
            Obx(() => ProjectSelectField<CostCategory>(
                  allLabel: 'All Categories',
                  value: logic.categoryFilter.value,
                  options: CostCategory.values,
                  labelOf: (c) => c.label,
                  onChanged: (c) => logic.categoryFilter.value = c,
                )),
            const SizedBox(height: 10),
            Obx(() => ProjectSelectField<CostModule>(
                  allLabel: 'All Modules',
                  value: logic.moduleFilter.value,
                  options: CostModule.values,
                  labelOf: (m) => m.label,
                  onChanged: (m) => logic.moduleFilter.value = m,
                )),
            const SizedBox(height: 10),
            CustomTextField(
              hintText: 'Cost code...',
              leftIconPath: AppIcons.search,
              controller: logic.costCodeCtrl,
              onChange: (v) => logic.costCodeQuery.value = v!,
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Obx(() => ProjectDateField(
                        label: 'From',
                        hint: 'dd/mm/yyyy',
                        format: 'dd/MM/yyyy',
                        value: logic.fromDate.value,
                        onChanged: (d) => logic.fromDate.value = d,
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(() => ProjectDateField(
                        label: 'To',
                        hint: 'dd/mm/yyyy',
                        format: 'dd/MM/yyyy',
                        value: logic.toDate.value,
                        onChanged: (d) => logic.toDate.value = d,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Obx(() => ProjectSelectField<CostGrouping>(
                  allLabel: CostGrouping.costCode.label,
                  value: logic.grouping.value,
                  options: CostGrouping.values,
                  labelOf: (g) => g.label,
                  onChanged: (g) => logic.grouping.value = g ?? CostGrouping.costCode,
                  allowClear: false,
                )),
          ],
        ),
        Obx(() {
          final summary = logic.groupedSummary;
          return FinancialsCard(
            title: logic.grouping.value.summaryTitle,
            children: [
              if (summary.isEmpty)
                Center(
                  child: Text('No cost data available for the selected filters.',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                )
              else
                for (final e in summary.entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(child: Text(e.key, style: const TextStyle(fontSize: 11))),
                        Text(projectMoney(e.value),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
            ],
          );
        }),
        Obx(() {
          final list = logic.filteredTransactions;
          return FinancialsCard(
            title: 'Transactions (${list.length})',
            children: [
              if (list.isEmpty)
                Text(
                  'No transactions found. Cost transactions are automatically created when '
                  'PO receipts are approved, payroll runs are completed, T&M tickets are '
                  'approved, and other cost events occur.',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                )
              else
                for (final t in list)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('${t.costCode} · ${t.description}',
                              style: const TextStyle(fontSize: 11)),
                        ),
                        Text(projectMoney(t.amount),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
            ],
          );
        }),
      ],
    );
  }
}
