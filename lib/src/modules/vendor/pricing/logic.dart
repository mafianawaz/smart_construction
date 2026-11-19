import 'package:get/get.dart';

import 'data/pricing_mock_data.dart';
import 'models/pricing_category.dart';
import 'models/pricing_item_model.dart';
import 'models/pricing_status.dart';


class PricingLogic extends GetxController {
  final RxList<PricingItemModel> _items = <PricingItemModel>[].obs;

  final Rx<PricingCategory> currentTab = PricingCategory.material.obs;
  final RxString searchQuery = ''.obs;
  final RxString categoryFilter = 'All Categories'.obs;
  final RxString statusFilter = 'All Status'.obs;

  static const String allCategories = 'All Categories';
  static const String allStatus = 'All Status';

  @override
  void onInit() {
    super.onInit();
    // TODO(api): replace with GET /api/pricing-items
    _items.assignAll(PricingMockData.getAll());
  }

  /// All items belonging to the active tab, before search/filter.
  List<PricingItemModel> get _itemsInTab =>
      _items.where((item) => item.category == currentTab.value).toList();

  /// Sub-category options available for the "All Categories" dropdown,
  /// derived from what's actually present in the active tab rather than
  /// the full static list — so the dropdown never offers a category with
  /// zero items in it.
  List<String> get categoryOptions => [
        allCategories,
        ..._itemsInTab.map((item) => item.subCategory).toSet(),
      ];

  List<String> get statusOptions => [
        allStatus,
        ...PricingStatus.values.map((s) => s.label),
      ];

  List<PricingItemModel> get filteredItems {
    final query = searchQuery.value.trim().toLowerCase();
    return _itemsInTab.where((item) {
      final matchesQuery = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.code.toLowerCase().contains(query);
      final matchesCategory = categoryFilter.value == allCategories ||
          item.subCategory == categoryFilter.value;
      final matchesStatus = statusFilter.value == allStatus ||
          item.status.label == statusFilter.value;
      return matchesQuery && matchesCategory && matchesStatus;
    }).toList();
  }

  void selectTab(PricingCategory category) {
    currentTab.value = category;
    // A category/status filter picked on one tab rarely makes sense on
    // another (different sub-category vocabularies), so reset on switch.
    categoryFilter.value = allCategories;
    statusFilter.value = allStatus;
    update();
  }

  void setSearch(value) {
    searchQuery.value = value;
    update();
  }

  void setCategoryFilter(String value) {
    categoryFilter.value = value;
    update();
  }

  void setStatusFilter(String value) {
    statusFilter.value = value;
    update();
  }

  void upsertItem(PricingItemModel item) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index == -1) {
      _items.add(item);
    } else {
      _items[index] = item;
    }
  }

  void exportCsv() {
    // TODO(api): GET /api/pricing-items/export?category=<tab> — stream
    // the CSV response to the platform's share/save sheet.
  }
}
