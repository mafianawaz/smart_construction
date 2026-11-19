import 'package:get/get.dart';
import '../logic.dart';
import '../models/bid_network_models.dart';

/// Tagged per request id so several details can coexist.
/// Caller owns `Get.delete<BidRequestDetailLogic>(tag: id)` on pop.
class BidRequestDetailLogic extends GetxController {
  BidRequestDetailLogic(this.requestId);
  final String requestId;

  final tab = BidDetailTab.overview.obs;

  BidRequestModel? get request => Get.find<BidNetworkLogic>().byId(requestId);

  void setTab(BidDetailTab t) => tab.value = t;
}
