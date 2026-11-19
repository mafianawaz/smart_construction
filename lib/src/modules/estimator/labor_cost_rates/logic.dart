import 'package:get/get.dart';

import 'data/labor_rates_mock_data.dart';
import 'models/labor_rates_models.dart';


class LaborCostRatesLogic extends GetxController {
  final selectedTab = LaborRatesTab.employeeRates.obs;

  final employeeRates = <EmployeeRateModel>[].obs;
  final jobClassifications = <JobClassificationModel>[].obs;
  final employeeAssignments = <EmployeeAssignmentModel>[].obs;
  final prevailingWages = <PrevailingWageModel>[].obs;
  final salaryCategories = <SalaryCategoryModel>[].obs;
  final burdenRates = <BurdenRateModel>[].obs;
  final costAssignments = <CostAssignmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void selectTab(LaborRatesTab tab) => selectedTab.value = tab;

  // The only place that touches mock data; swap for repository calls later.
  void _load() {
    employeeRates.assignAll(LaborRatesMockData.employeeRates());
    jobClassifications.assignAll(LaborRatesMockData.jobClassifications());
    employeeAssignments.assignAll(LaborRatesMockData.employeeAssignments());
    prevailingWages.assignAll(LaborRatesMockData.prevailingWages());
    salaryCategories.assignAll(LaborRatesMockData.salaryCategories());
    burdenRates.assignAll(LaborRatesMockData.burdenRates());
    costAssignments.assignAll(LaborRatesMockData.costAssignments());
  }
}
