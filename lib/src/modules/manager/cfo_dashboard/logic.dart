import 'package:get/get.dart';

import 'data/cfo_mock_data.dart';
import 'models/cfo_models.dart';

/// State for the CFO Dashboard.
///
/// `GetBuilder` + `update()` on plain fields (same pattern as `PricingLogic`
/// and `PortfolioRollupLogic`). Every organisation card starts expanded, as in
/// the reference; [toggle] collapses / expands one.
class CfoDashboardLogic extends GetxController {
  bool isLoading = true;
  List<CfoOrgSummary> orgs = [];
  final Set<String> _expanded = {};

  /// Ids seen on a previous load, so a refresh keeps the user's open/closed
  /// choices and only auto-expands organisations that are new.
  final Set<String> _known = {};

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading = true;
    update();
    // API seam: see CfoMockData.fetchOrganizations.
    orgs = await CfoMockData.fetchOrganizations();
    for (final o in orgs) {
      if (_known.add(o.id)) _expanded.add(o.id);
    }
    isLoading = false;
    update();
  }

  bool isExpanded(String id) => _expanded.contains(id);

  void toggle(String id) {
    if (!_expanded.remove(id)) _expanded.add(id);
    update();
  }
}
