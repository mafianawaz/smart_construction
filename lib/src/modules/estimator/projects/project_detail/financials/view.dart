import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../widgets/scroll_segment_toggle.dart';
import '../../models/project_enums.dart';
import 'logic.dart';
import 'sections/billing_section.dart';
import 'sections/budget_section.dart';
import 'sections/change_orders_section.dart';
import 'sections/cost_explorer_section.dart';
import 'sections/cost_ledger_section.dart';
import 'sections/live_financials_section.dart';
import 'sections/production_rates_section.dart';
import 'sections/receipts_section.dart';
import 'sections/schedule_of_values_section.dart';

/// Financials tab — scrolling sub-tab strip (Live Financials / Budget /
/// Cost Ledger / Cost Explorer / Change Orders / Schedule of Values /
/// Billing / Receipts / Production Rates) over the selected section.

class FinancialsView extends StatelessWidget {
  final String projectId;
  final String projectNumber;
  final String projectLabel;

  const FinancialsView({
    super.key,
    required this.projectId,
    this.projectNumber = '',
    this.projectLabel = '',
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FinancialsLogic>(
      init: FinancialsLogic(projectId, projectNumber: projectNumber, projectLabel: projectLabel),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => ScrollSegmentToggle<FinancialsSubTab>(
                    values: FinancialsSubTab.values,
                    labelOf: (t) => t.label,
                    selected: logic.subTab.value,
                    onChanged: logic.onSubTabChange,
                  )),
              const SizedBox(height: 14),
              Obx(() {
                switch (logic.subTab.value) {
                  case FinancialsSubTab.liveFinancials:
                    return LiveFinancialsSection(logic: logic);
                  case FinancialsSubTab.budget:
                    return BudgetSection(logic: logic);
                  case FinancialsSubTab.costLedger:
                    return CostLedgerSection(logic: logic);
                  case FinancialsSubTab.costExplorer:
                    return CostExplorerSection(logic: logic);
                  case FinancialsSubTab.changeOrders:
                    return ChangeOrdersSection(logic: logic);
                  case FinancialsSubTab.scheduleOfValues:
                    return ScheduleOfValuesSection(logic: logic);
                  case FinancialsSubTab.receipts:
                    return ReceiptsSection(logic: logic);
                  case FinancialsSubTab.billing:
                    return BillingSection(logic: logic);
                  case FinancialsSubTab.productionRates:
                    return ProductionRatesSection(logic: logic);
                }
              }),
            ],
          ),
        );
      },
    );
  }
}
