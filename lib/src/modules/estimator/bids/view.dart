import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_toggle_switch.dart';
import 'package:smart_construction/src/widgets/pill_tab_group.dart';
import '../../field_worker/my_work/widget/calendar_view.dart';
import 'logic.dart';
import 'models/bid_model.dart';
import 'widgets/ai_bid_analysis.dart';
import 'widgets/bid_card.dart';
import 'widgets/bid_stat_tile.dart';
import 'widgets/inbox_bid_card.dart';
import 'widgets/new_bid_menu.dart';

class EstimatorBidView extends StatelessWidget {
  const EstimatorBidView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EstimatorBidLogic>(
      init: EstimatorBidLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: SecondaryAppbar(
            title: 'Bids',
            subTitle: 'Track opportunities, bids in progress, and incoming invitations.',
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Builder(
                  // Builder gives NewBidMenu the "+" button's own context
                  // so the dropdown anchors under it.
                  builder: (btnContext) => CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primaryOrange,
                    child: IconButton(
                      onPressed: () => NewBidMenu.show(btnContext),
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
            isHome: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Obx(() => CustomToggle(
                      options: const ['Table', 'Calendar'],
                      isIconToggle: true,
                      toggleIcon: [AppIcons.table, AppIcons.calendar],
                      selectedIndex: logic.selectedTab.value,
                      onChanged: logic.onTabChange)),
                  Obx(() => logic.selectedTab.value == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Obx(() => CustomToggle(
                                options: const ['Bid Board', 'Bid Inbox'],
                                selectedIndex: logic.selectedSubTab.value,
                                isColored: true,
                                onChanged: logic.onSubTabChange)),
                            const SizedBox(height: 15),
                            Obx(() => logic.selectedSubTab.value == 0
                                ? _BoardSection(logic: logic)
                                : _InboxSection(logic: logic)),
                          ],
                        )
                      : CalendarDemoScreen()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Bid Board tab: AI analysis card, search, filter pills, bid cards.
class _BoardSection extends StatelessWidget {
  final EstimatorBidLogic logic;
  const _BoardSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AIBidsAnalysis(),
        const SizedBox(height: 15),
        CustomTextField(
          hintText: 'Search Bids',
          leftIconPath: AppIcons.search,
          onChange: logic.onSearch,
        ),
        const SizedBox(height: 15),
        Obx(() => PillTabGroup(
            items: [
              PillTabItem(value: 0, label: 'All Cost Code'),
              PillTabItem(value: 1, label: 'All Clients'),
              PillTabItem(value: 2, label: 'All estimators'),
            ],
            selectedValue: logic.selectedPillTab.value,
            onChanged: logic.onChange)),
        const SizedBox(height: 15),
        // Obx must read the observables itself (search text + bids list).
        Obx(() {
          final list = logic.filteredBoard;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Active Opportunities (${list.length})',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 15),
              if (list.isEmpty)
                const AppEmptyState(
                  icon: Icons.search_off_outlined,
                  title: 'No Bids Found',
                  message: 'Try a different search, or tap + to create a bid.',
                  showButton: false,
                )
              else
                for (final bid in list)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: BidCard(
                      bid: bid,
                      onView: () => logic.openBid(bid),
                      onMore: () => _showActions(context, bid),
                    ),
                  ),
            ],
          );
        }),
      ],
    );
  }

  void _showActions(BuildContext context, BidModel bid) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: const Text('View Details'),
              onTap: () {
                Navigator.of(sheetCtx).pop();
                logic.openBid(bid);
              },
            ),
            if (bid.status == BidStatus.draft)
              ListTile(
                leading: Icon(Icons.delete_outline, color: AppColors.redColor),
                title: Text('Delete Draft',
                    style: TextStyle(color: AppColors.redColor)),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  logic.deleteBid(bid.id);
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Bid Inbox tab: stat tiles, status filter pills, invitation cards.
class _InboxSection extends StatelessWidget {
  final EstimatorBidLogic logic;
  const _InboxSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              BidStatTile(
                icon: Icons.mark_email_unread_outlined,
                label: 'Active',
                value: logic.inboxCount(BidStatus.active),
              ),
              const SizedBox(width: 10),
              BidStatTile(
                icon: Icons.emoji_events_outlined,
                label: 'Awarded',
                value: logic.inboxCount(BidStatus.awarded),
              ),
              const SizedBox(width: 10),
              BidStatTile(
                icon: Icons.timer_off_outlined,
                label: 'Expired',
                value: logic.inboxCount(BidStatus.expired),
              ),
            ],
          ),
        )),
        const SizedBox(height: 15),
        Obx(() => PillTabGroup(
            items: [
              PillTabItem(value: 0, label: 'All'),
              PillTabItem(value: 1, label: 'Active'),
              PillTabItem(value: 2, label: 'Awarded'),
              PillTabItem(value: 3, label: 'Expired'),
            ],
            selectedValue: logic.selectedInboxFilter.value,
            onChanged: logic.onInboxFilterChange)),
        const SizedBox(height: 15),
        Obx(() {
          final list = logic.filteredInbox;
          if (list.isEmpty) {
            return const AppEmptyState(
              icon: Icons.inbox_outlined,
              title: 'Inbox Empty',
              message: 'No bid invitations match this filter.',
              showButton: false,
            );
          }
          return Column(
            children: [
              for (final bid in list)
                InboxBidCard(bid: bid, onView: () => logic.openBid(bid)),
            ],
          );
        }),
      ],
    );
  }
}
