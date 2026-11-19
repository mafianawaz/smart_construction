import 'package:get/get.dart';

import 'data/cfo_bulletin_mock_data.dart';
import 'models/cfo_bulletin_models.dart';

class CfoBulletinsLogic extends GetxController {
  List<CfoBulletinOrg> organizations = const [];
  bool loading = true;

  /// Ids of collapsed organizations. Everything starts expanded, as in the
  /// reference.
  final Set<String> _collapsed = {};

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading = true;
    update();
    organizations = await CfoBulletinMockData.organizations();
    loading = false;
    if (!isClosed) update();
  }

  bool isExpanded(String orgId) => !_collapsed.contains(orgId);

  void toggle(String orgId) {
    if (!_collapsed.remove(orgId)) _collapsed.add(orgId);
    update();
  }
}
