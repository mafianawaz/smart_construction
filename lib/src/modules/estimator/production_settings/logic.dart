import 'package:get/get.dart';

import 'data/production_mock_data.dart';
import 'models/production_models.dart';


/// State for Production Settings: active tab, shared search/filter inputs and
/// the two lists. Filtering is derived in getters so the views stay dumb.
class ProductionSettingsLogic extends GetxController {
  final selectedTab = 0.obs;

  final searchQuery = ''.obs;

  /// null = "All Units".
  final unitFilter = RxnString();
  final timeRange = ProductionTimeRange.allTime.obs;

  final benchmarks = <ProductionBenchmarkModel>[].obs;
  final costAnalytics = <CostAnalyticsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // The only place that touches mock data; swap for a repository later.
    benchmarks.assignAll(ProductionMockData.benchmarks());
    costAnalytics.assignAll(ProductionMockData.costAnalytics());
  }

  /// Switching tabs resets search/filters so the (rebuilt, empty) search box
  /// and the applied query never disagree.
  void selectTab(tab) {
    if (tab == selectedTab.value) return;
    selectedTab.value = tab;
    searchQuery.value = '';
    unitFilter.value = null;
    timeRange.value = ProductionTimeRange.allTime;
  }

  void setSearch(String v) => searchQuery.value = v;
  void setUnit(String? unit) => unitFilter.value = unit;
  void setTimeRange(ProductionTimeRange r) => timeRange.value = r;

  /// Units available in the dropdown for the current tab.
  List<String> get unitOptions {
    final units = selectedTab.value == ProductionTab.benchmarks
        ? benchmarks.map((b) => b.unit)
        : costAnalytics.map((c) => c.unit);
    return units.toSet().toList()..sort();
  }

  bool _matches(String scope, String unit, DateTime when) {
    final q = searchQuery.value.trim().toLowerCase();
    final u = unitFilter.value;
    return (q.isEmpty || scope.toLowerCase().contains(q)) &&
        (u == null || u == unit) &&
        timeRange.value.includes(when);
  }

  List<ProductionBenchmarkModel> get filteredBenchmarks => benchmarks
      .where((b) => _matches(b.scopeName, b.unit, b.lastRecorded))
      .toList();

  List<CostAnalyticsModel> get filteredAnalytics => costAnalytics
      .where((c) => _matches(c.scopeName, c.unit, c.lastRecorded))
      .toList();
}
