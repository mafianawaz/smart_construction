import 'package:get/get.dart';
import 'data/permits_mock_data.dart';
import 'models/permit_models.dart';
import 'permit_details/view.dart';


/// Plain-field + `update()` controller (GetBuilder pattern).
class PermitsLogic extends GetxController {
  static const int windowDays = 30;

  List<PermitModel> _all = [];

  List<PermitModel> get expiringSoon => _all.where((p) {
        final d = p.daysRemaining();
        return d >= 0 && d <= windowDays;
      }).toList();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() {
    _all = PermitsMockData.fetchPermits();
    update();
  }

  void openPermit(PermitModel permit) {
    Get.to(() => PermitDetailsView(permit: permit));
  }
}
