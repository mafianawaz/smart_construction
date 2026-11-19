import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../models/create_bid_enums.dart';
import '../views/bid_info_step_view.dart';
import '../views/manual_bid_entry_view.dart';
import 'create_bid_logic.dart';

/// Single entry point for both flows — call from the "+" menu:
///
///   CreateBidWizard.start(CreateBidFlow.ai);      // AI-Powered Bid Upload
///   CreateBidWizard.start(CreateBidFlow.manual);  // Manual Bid Entry
class CreateBidWizard {
  CreateBidWizard._();

  static void start(CreateBidFlow flow) {
    if (Get.isRegistered<CreateBidLogic>()) {
      Get.delete<CreateBidLogic>(force: true);
    }
    final logic = Get.put(CreateBidLogic());
    logic.flow.value = flow;

    Get.to(
      () => _WizardRoot(
        child: flow == CreateBidFlow.ai
            ? const BidInfoStepView()
            : const ManualBidEntryView(),
      ),
      routeName: flow == CreateBidFlow.ai ? kRouteInfo : kRouteManualEntry,
    );
  }
}

/// Wraps the first wizard screen so the shared controller is deleted
/// when the whole wizard is gone (finished or backed out of).
class _WizardRoot extends StatefulWidget {
  final Widget child;
  const _WizardRoot({required this.child});

  @override
  State<_WizardRoot> createState() => _WizardRootState();
}

class _WizardRootState extends State<_WizardRoot> {
  @override
  void dispose() {
    if (Get.isRegistered<CreateBidLogic>()) {
      Get.delete<CreateBidLogic>(force: true);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
