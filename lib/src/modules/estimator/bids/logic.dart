import 'package:get/get.dart';

import 'data/bids_mock_data.dart';
import 'models/bid_model.dart';
import 'views/bid_details_view.dart';

class EstimatorBidLogic extends GetxController {
  // Table / Calendar
  final selectedTab = 0.obs;
  onTabChange(index) {
    selectedTab.value = index;
  }

  // Bid Board / Bid Inbox
  final selectedSubTab = 0.obs;
  onSubTabChange(index) {
    selectedSubTab.value = index;
  }

  // "All Cost Code / All Clients / All estimators" pills (not wired to
  // data yet — see NOTES_BIDS.md).
  final selectedPillTab = 0.obs;
  onChange(index) {
    selectedPillTab.value = index;
  }

  // ---- Data ------------------------------------------------------------

  final bids = <BidModel>[].obs; // Bid Board
  final inbox = <BidModel>[].obs; // Bid Inbox

  final searchQuery = ''.obs;

  /// 0 = All, 1 = Active, 2 = Awarded, 3 = Expired
  final selectedInboxFilter = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // API: GET /bids?view=board  and  GET /bids?view=inbox
    bids.assignAll(BidsMockData.boardBids());
    inbox.assignAll(BidsMockData.inboxBids());
  }

  void onSearch(value) => searchQuery.value = value.trim().toLowerCase();

  void onInboxFilterChange(int index) => selectedInboxFilter.value = index;

  List<BidModel> get filteredBoard =>
      bids.where((b) => b.matchesQuery(searchQuery.value)).toList();

  List<BidModel> get filteredInbox {
    final status = const [
      null,
      BidStatus.active,
      BidStatus.awarded,
      BidStatus.expired,
    ][selectedInboxFilter.value];
    return inbox.where((b) => status == null || b.status == status).toList();
  }

  int inboxCount(BidStatus status) =>
      inbox.where((b) => b.status == status).length;

  /// Called by the Create Bid wizard when a bid is submitted.
  void addBid(BidModel bid) => bids.insert(0, bid);

  // API: DELETE /bids/{id}
  void deleteBid(String id) => bids.removeWhere((b) => b.id == id);

  void openBid(BidModel bid) =>
      Get.to(() => BidDetailsView(bid: bid), routeName: '/bids/details');
}
