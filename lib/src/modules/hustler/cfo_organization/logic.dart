import 'package:get/get.dart';
import 'data/cfo_org_mock_data.dart';
import 'models/cfo_org_models.dart';

class CfoOrgLogic extends GetxController {
  late CfoPortfolioSummary summary;
  late CfoAccessSummary access;
  late CfoInsights insights;
  late List<CfoOrgCardModel> organizations;
  late List<CfoExecutive> executives;

  /// Id of the organization currently being switched to (shows a spinner).
  String? switchingOrgId;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() {
    summary = CfoOrgMockData.portfolioSummary();
    access = CfoOrgMockData.accessSummary();
    insights = CfoOrgMockData.insights();
    organizations = CfoOrgMockData.organizations();
    executives = CfoOrgMockData.executives();
    update();
  }

  bool get hasExecutives => executives.isNotEmpty;

  Future<void> switchOrganization(CfoOrgCardModel org) async {
    if (org.isActive || switchingOrgId != null) return;
    switchingOrgId = org.id;
    update();
    await CfoOrgMockData.switchOrganization(org.id);
    organizations = organizations
        .map((o) => o.copyWith(isActive: o.id == org.id))
        .toList();
    switchingOrgId = null;
    update();
  }

  void addExecutive(CfoExecutive executive) {
    executives = [...executives, executive];
    update();
  }
}



