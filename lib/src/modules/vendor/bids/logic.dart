import 'package:get/get.dart';
import 'bids_details/logic.dart';
import 'bids_details/view.dart';
import 'data/bids_mock_data.dart';
import 'models/bid_model.dart';
import 'models/bid_status.dart';


class BidsLogic extends GetxController {
  final RxList<BidModel> _bids = <BidModel>[].obs;
  final Rx<BidFilter> currentFilter = BidFilter.all.obs;

  @override
  void onInit() {
    super.onInit();
    // TODO(api): replace with GET /api/bids
    _bids.assignAll(BidsMockData.getAll());
  }

  List<BidModel> get _all => _bids;

  List<BidModel> get filteredBids =>
      _all.where((bid) => currentFilter.value.matches(bid.status)).toList();

  int get allCount => _all.length;
  int get pendingCount =>
      _all.where((b) => b.status == BidStatus.pending).length;
  int get declinedCount =>
      _all.where((b) => b.status == BidStatus.declined).length;
  int get respondedCount =>
      _all.where((b) => b.status == BidStatus.responded).length;

  int countFor(BidFilter filter) {
    switch (filter) {
      case BidFilter.all:
        return allCount;
      case BidFilter.pending:
        return pendingCount;
      case BidFilter.declined:
        return declinedCount;
      case BidFilter.responded:
        return respondedCount;
    }
  }

  void selectFilter(BidFilter filter) {
    currentFilter.value = filter;
    update();
  }

  Future<void> viewDetails(BidModel bid) async {
    final tag = bid.id;
    Get.put(BidDetailsLogic(bid), tag: tag);
    await Get.to(() => BidDetailsView(bidId: tag));
    // Tagged controller disposal is the caller's responsibility, per the
    // navigation/pop-layer convention used across the app.
    Get.delete<BidDetailsLogic>(tag: tag);
    update();
  }
}
