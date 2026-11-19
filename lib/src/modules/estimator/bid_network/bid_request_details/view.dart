import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import '../../../../utils/app_color.dart';
import '../../../../widgets/custom_toggle_switch.dart';
import '../models/bid_network_models.dart';
import '../widgets/bid_common_widgets.dart';
import '../widgets/bid_detail_tabs.dart';
import 'logic.dart';

/// Screens 5–8 — request detail with Overview / Invitations / Responses / Q&A.
class BidRequestDetailView extends StatelessWidget {
  const BidRequestDetailView({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BidRequestDetailLogic(requestId),
      builder: (logic){
      return Scaffold(
        appBar: AppPrimaryBar(
          title: logic.request?.title,
          showBackButton: true,
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BidStatusPill(status: logic.request?.status ?? BidRequestStatus.draft),
            )
          ],
        ),
        body: Obx(() {
          // `request` reads the observable list, so status changes
          // (Close Bidding) rebuild this view.
          final r = logic.request;
          if (r == null) {
            return const Center(child: Text('Bid request not found'));
          }
          final tabs = BidDetailTab.values;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Created ${DateFormat('MMMM d, y').format(r.createdAt)}',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  const SizedBox(height: 12),
                  BidStatGrid(request: r),
                  const SizedBox(height: 12),
                  CustomToggle(
                    options: [for (final t in tabs) t.label],
                    selectedIndex: tabs.indexOf(logic.tab.value),
                    onChanged: (i) => logic.setTab(tabs[i]),
                  ),
                  const SizedBox(height: 12),
                  switch (logic.tab.value) {
                    BidDetailTab.overview => BidOverviewTab(request: r),
                    BidDetailTab.invitations => BidInvitationsTab(invitations: r.invitations),
                    BidDetailTab.responses => BidResponsesTab(responses: r.responses),
                    BidDetailTab.qa => BidQaTab(questions: r.questions),
                  },
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}
