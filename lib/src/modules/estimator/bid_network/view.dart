import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/pill_tab_group.dart';
import 'bid_network_settings/view.dart';
import 'bid_request_details/view.dart';
import 'create_bid_request/view.dart';
import 'logic.dart';
import 'models/bid_network_models.dart';
import 'widgets/bid_common_widgets.dart';
import 'widgets/bid_request_card.dart';


class BidNetworkView extends StatelessWidget {
  const BidNetworkView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BidNetworkLogic(),
      builder: (logic){
       return Scaffold(
            appBar: AppPrimaryBar(
              title: 'Bid Network',
              showBackButton: true,
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Manage Bid Services to subcontractors on this network', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final created = await Get.to<BidRequestModel>(
                                    () => const CreateBidRequestView());
                            if (created != null) logic.addRequest(created);
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('New Bid Request'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryOrange,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            textStyle: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w600),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Get.to(() => const BidNetworkSettingsView()),
                          icon: const Icon(Icons.settings_outlined, size: 16),
                          label: const Text('Network Settings'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kBidGrey,
                            backgroundColor: AppColors.fieldFill,
                            side: BorderSide.none,
                            textStyle: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w600),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Obx(() => Row(
                    children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: PillTabGroup<BidNetworkFilter>(
                            items: [
                              for (final t in BidNetworkFilter.values)
                                PillTabItem(value: t, label: t.label),
                            ],
                            selectedValue: logic.filter.value,
                            onChanged: logic.onFilterChange,
                          ),
                        ),
                    ],
                  )),
                  const SizedBox(height: 12),
                  Obx(() {
                    final items = logic.filtered;
                    if (items.isEmpty) {
                      return const BidEmptyPanel(
                        icon: Icons.gavel_outlined,
                        message: 'No bid requests yet',
                      );
                    }
                    return Column(
                      children: [
                        for (final r in items)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: BidRequestCard(
                              request: r,
                              onTap: () => Get.to(() => BidRequestDetailView(requestId: r.id)),
                              onCloseBidding: () => logic.closeBidding(r.id),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
      }
    );
  }
}
