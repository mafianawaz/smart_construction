import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_color.dart';
import 'logic.dart';
import 'models/labor_rates_models.dart';
import 'tabs/burden_rates_tab.dart';
import 'tabs/cost_assignments_tab.dart';
import 'tabs/employee_assignments_tab.dart';
import 'tabs/employee_rates_tab.dart';
import 'tabs/job_classifications_tab.dart';
import 'tabs/prevailing_wage_tab.dart';
import 'tabs/salary_categories_tab.dart';
import 'widgets/labor_rates_header.dart';
import 'widgets/rates_tab_bar.dart';

/// Labor Cost Rates — seven pill tabs over one screen. The view holds no data
/// logic: `LaborCostRatesLogic.selectedTab` decides which body renders.
class LaborCostRatesView extends StatelessWidget {
  const LaborCostRatesView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(LaborCostRatesLogic());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LaborRatesHeader(
                title: 'Labor Cost Rates',
                onBack: Get.back,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text(
                'Manage employee base rates, job classifications, and '
                'prevailing wage rules for projects',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.4,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            Obx(
              () => RatesTabBar(
                tabs: LaborRatesTab.values,
                selected: logic.selectedTab.value,
                onChanged: logic.selectTab,
              ),
            ),
            Expanded(
              child: Obx(() => _bodyFor(logic.selectedTab.value, logic)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyFor(LaborRatesTab tab, LaborCostRatesLogic logic) {
    switch (tab) {
      case LaborRatesTab.employeeRates:
        return EmployeeRatesTab(logic: logic);
      case LaborRatesTab.jobClassifications:
        return JobClassificationsTab(logic: logic);
      case LaborRatesTab.employeeAssignments:
        return EmployeeAssignmentsTab(logic: logic);
      case LaborRatesTab.prevailingWage:
        return PrevailingWageTab(logic: logic);
      case LaborRatesTab.costAssignments:
        return CostAssignmentsTab(logic: logic);
      case LaborRatesTab.salaryCategories:
        return SalaryCategoriesTab(logic: logic);
      case LaborRatesTab.bucketRates:
        return BurdenRatesTab(logic: logic);
    }
  }
}
