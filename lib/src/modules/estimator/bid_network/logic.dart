import 'package:get/get.dart';

import 'data/bid_network_mock_data.dart';
import 'models/bid_network_models.dart';


/// Drives the Bid Network list screen and owns the settings state.
class BidNetworkLogic extends GetxController {
  final requests = <BidRequestModel>[].obs;
  final settings = const BidNetworkSettingsModel().obs;
  final isLoading = false.obs;

  final Rx<BidNetworkFilter> filter = BidNetworkFilter.all.obs;
  onFilterChange(BidNetworkFilter t) => filter.value = t;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    // TODO(api): GET /bid-network/requests and GET /bid-network/settings
    requests.assignAll(BidNetworkMockData.requests());
    settings.value = BidNetworkMockData.settings();
    isLoading.value = false;
  }

  List<BidRequestModel> get filtered =>
      requests.where((r) => filter.value.matches(r.status)).toList();

  int countFor(BidNetworkFilter f) =>
      requests.where((r) => f.matches(r.status)).length;

  void setFilter(BidNetworkFilter f) => filter.value = f;

  void addRequest(BidRequestModel request) => requests.insert(0, request);

  /// TODO(api): POST /bid-network/requests/{id}/close
  void closeBidding(String id) {
    final i = requests.indexWhere((r) => r.id == id);
    if (i == -1) return;
    requests[i] = requests[i].copyWith(status: BidRequestStatus.closed);
  }

  BidRequestModel? byId(String id) {
    final i = requests.indexWhere((r) => r.id == id);
    return i == -1 ? null : requests[i];
  }

  // ── Settings ───────────────────────────────────────────────────────────
  void updateSettings(BidNetworkSettingsModel next) => settings.value = next;
}
