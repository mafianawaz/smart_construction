import 'package:get/get.dart';
import '../logic.dart';
import '../models/bid_network_models.dart';

/// Edits a working copy of the settings; "Admin Only" save commits it.
class BidNetworkSettingsLogic extends GetxController {
  final draft = const BidNetworkSettingsModel().obs;
  final isAdmin = true.obs; // TODO(auth): derive from MockSession role.

  @override
  void onInit() {
    super.onInit();
    draft.value = Get.find<BidNetworkLogic>().settings.value;
  }

  void toggleParticipation(bool v) =>
      draft.value = draft.value.copyWith(networkParticipation: v);
  void toggleSend(bool v) =>
      draft.value = draft.value.copyWith(canSendBidRequests: v);
  void toggleReceive(bool v) =>
      draft.value = draft.value.copyWith(canReceiveBidInvites: v);
  void toggleEmail(bool v) =>
      draft.value = draft.value.copyWith(emailNotifications: v);
  void toggleInApp(bool v) =>
      draft.value = draft.value.copyWith(inAppNotifications: v);

  /// TODO(api): PUT /bid-network/settings
  void save() {
    Get.find<BidNetworkLogic>().updateSettings(draft.value);
    Get.back();
  }
}
