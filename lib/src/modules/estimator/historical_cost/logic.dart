import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_cost_record/view.dart';
import 'data/historical_cost_mock_data.dart';
import 'models/cost_record_model.dart';


class HistoricalCostLogic extends GetxController {
  final records = <CostRecordModel>[].obs;

  // Filters — null means "All".
  final searchQuery = ''.obs;
  final selectedTrade = RxnString();
  final selectedCategory = RxnString();
  final selectedCode = RxnString();
  final projectTypeQuery = ''.obs;
  final dateFrom = Rxn<DateTime>();
  final dateTo = Rxn<DateTime>();

  /// 0 = Summary, 1 = Detailed Records
  final tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    records.assignAll(HistoricalCostMockData.records());
  }

  // ---- derived state (read inside Obx) ----

  List<String> get trades => _distinct((r) => r.trade);
  List<String> get categories => _distinct((r) => r.scopeCategory);
  List<String> get codes => _distinct((r) => r.costCode);

  List<String> _distinct(String Function(CostRecordModel) pick) =>
      records.map(pick).where((v) => v.trim().isNotEmpty).toSet().toList()
        ..sort();

  bool get hasActiveFilters =>
      searchQuery.value.isNotEmpty ||
      selectedTrade.value != null ||
      selectedCategory.value != null ||
      selectedCode.value != null ||
      projectTypeQuery.value.isNotEmpty ||
      dateFrom.value != null ||
      dateTo.value != null;

  List<CostRecordModel> get filtered {
    final q = searchQuery.value.trim().toLowerCase();
    final type = projectTypeQuery.value.trim().toLowerCase();
    final from = dateFrom.value;
    final to = dateTo.value;
    return records.where((r) {
      if (q.isNotEmpty && !r.description.toLowerCase().contains(q)) {
        return false;
      }
      if (selectedTrade.value != null && r.trade != selectedTrade.value) {
        return false;
      }
      if (selectedCategory.value != null &&
          r.scopeCategory != selectedCategory.value) {
        return false;
      }
      if (selectedCode.value != null && r.costCode != selectedCode.value) {
        return false;
      }
      if (type.isNotEmpty && !r.projectType.toLowerCase().contains(type)) {
        return false;
      }
      if (from != null && r.completedDate.isBefore(_day(from))) return false;
      if (to != null && r.completedDate.isAfter(_day(to))) return false;
      return true;
    }).toList();
  }

  List<CostSummaryGroup> get summaries =>
      CostSummaryGroup.fromRecords(filtered);

  DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  // ---- actions ----

  void clearFilters() {
    searchQuery.value = '';
    selectedTrade.value = null;
    selectedCategory.value = null;
    selectedCode.value = null;
    projectTypeQuery.value = '';
    dateFrom.value = null;
    dateTo.value = null;
  }

  Future<void> openAddRecord() async {
    final created = await Get.to<CostRecordModel>(
      () => const AddCostRecordView(),
    );
    if (created != null) {
      // TODO(api): POST /estimating/historical-costs
      records.insert(0, created);
    }
  }

  Future<void> pickDate({required bool isFrom}) async {
    final target = isFrom ? dateFrom : dateTo;
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: target.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) target.value = picked;
  }

  void confirmDelete(CostRecordModel record) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete cost record?'),
        content: const Text('This record will be removed from historical costs.'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              // TODO(api): DELETE /estimating/historical-costs/:id
              records.removeWhere((r) => r.id == record.id);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
