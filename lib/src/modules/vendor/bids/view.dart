import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/app_empty_filter.dart';
import 'logic.dart';
import 'models/bid_status.dart';
import 'widgets/bid_stat_card.dart';
import 'widgets/bid_filter_tabs.dart';
import 'widgets/bid_list_tile.dart';

class BidsView extends StatelessWidget {
  const BidsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BidsLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: SecondaryAppbar(
            isHome: false,
            title: 'Bids',
            subTitle: 'View and respond to the bid invitations from GCs',
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      BidStatCard(
                        status: BidStatus.pending,
                        count: logic.pendingCount,
                        onTap: () => logic.selectFilter(BidFilter.pending),
                      ),
                      const SizedBox(width: 10),
                      BidStatCard(
                        status: BidStatus.declined,
                        count: logic.declinedCount,
                        onTap: () => logic.selectFilter(BidFilter.declined),
                      ),
                      const SizedBox(width: 10),
                      BidStatCard(
                        status: BidStatus.responded,
                        count: logic.respondedCount,
                        onTap: () => logic.selectFilter(BidFilter.responded),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                BidFilterTabs(
                  selected: logic.currentFilter.value,
                  countFor: logic.countFor,
                  onChanged: logic.selectFilter,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: logic.filteredBids.isEmpty
                      ?  AppEmptyState(
                    icon: Icons.inbox_outlined,
                    title: 'No bids here',
                    message: 'Bid invitations matching this filter will show up here.',
                    showButton: false,
                  )
                      : ListView.separated(
                    itemCount: logic.filteredBids.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final bid = logic.filteredBids[index];
                      return BidListTile(
                        bid: bid,
                        onViewDetails: () => logic.viewDetails(bid),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
