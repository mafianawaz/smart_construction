import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import '../../../../utils/app_color.dart';
import '../widgets/bid_common_widgets.dart';
import 'logic.dart';

/// Screen 4 — Bid Network Settings.
class BidNetworkSettingsView extends StatelessWidget {
  const BidNetworkSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BidNetworkSettingsLogic(),
      builder: (logic){
       return Scaffold(
            appBar: AppPrimaryBar(
              title: 'Bid Network Settings',
              showBackButton: true,
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final s = logic.draft.value;
                    final admin = logic.isAdmin.value;
                    return Column(
                      children: [
                        Text(
                          'Configure how your organization participates in the subcontractor bid network.',
                          style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 12),
                        BidCard(
                          child: Column(
                            children: [
                              BidSwitchRow(
                                title: 'Enable Network Participation',
                                subtitle: 'Allow your org to participate in the bid network',
                                value: s.networkParticipation,
                                onChanged: admin ? logic.toggleParticipation : null,
                              ),
                              const Divider(height: 8),
                              BidSwitchRow(
                                title: 'Can Send Bid Requests',
                                subtitle: 'Allow sending bid solicitations to subs',
                                value: s.canSendBidRequests,
                                onChanged: admin ? logic.toggleSend : null,
                              ),
                              const Divider(height: 8),
                              BidSwitchRow(
                                title: 'Can Receive Bid Invites',
                                subtitle: 'Allow receiving invitations from GCs',
                                value: s.canReceiveBidInvites,
                                onChanged: admin ? logic.toggleReceive : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        BidCard(
                          child: Column(
                            children: [
                              BidSwitchRow(
                                title: 'Email Notifications',
                                subtitle: 'Receive bid alerts via email',
                                value: s.emailNotifications,
                                onChanged: admin ? logic.toggleEmail : null,
                              ),
                              const Divider(height: 8),
                              BidSwitchRow(
                                title: 'In-App Notifications',
                                subtitle: 'Receive bid alerts in the app',
                                value: s.inAppNotifications,
                                onChanged: admin ? logic.toggleInApp : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Faded "Admin Only" in the design = disabled for non-admins.
                        CustomButton(
                          onPressed: admin ? logic.save : null,
                          text: admin ? 'Save Settings' : 'Admin Only',
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
       });
  }
}
