import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';

import '../logic/create_bid_logic.dart';
import '../models/create_bid_enums.dart';
import '../widgets/add_custom_scope_item_bar.dart';
import '../widgets/bid_form_sections.dart';
import '../widgets/bid_step_indicator.dart';
import '../widgets/scope_item_card.dart';

/// Manual flow, step 2 of 3 — Review Scope Items. Checkbox list with
/// inline Qty/Unit/Cost editing, "Add Custom Scope Item", and
/// "Continue to Bid Details". Controller state decides empty vs list.
class ReviewScopeItemsView extends StatelessWidget {
  const ReviewScopeItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<CreateBidLogic>();

    return Scaffold(
      appBar: AppBar(title: const Text('Review Scope Items'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Confirm what's included before moving to bid details.",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
            ),
            BidStepIndicator(
              stepLabels: CreateBidFlow.manual.stepLabels,
              currentIndex: 1,
            ),
            Expanded(
              child: Obx(() {
                final items = logic.scopeItems;
                final hasAi = logic.aiSuggestedCount > 0;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${hasAi ? 'AI - Suggested Items' : 'Scope Items'} (${items.length})',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          Text('${logic.selectedCount} selected',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade500)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (items.isEmpty)
                        const AppEmptyState(
                          icon: Icons.inbox_outlined,
                          title: 'No Scope Items Yet',
                          message: 'Add scope items below before continuing.',
                          showButton: false,
                        )
                      else
                        for (final item in items)
                          ScopeItemCard(
                            key: ValueKey(item.id),
                            item: item,
                            onChanged: logic.editScopeItem,
                            onToggleIncluded: (_) =>
                                logic.toggleScopeItemIncluded(item.id),
                          ),
                      const SizedBox(height: 16),
                      AddCustomScopeItemBar(
                        descriptionController: logic.quickDescCtrl,
                        quantityController: logic.quickQtyCtrl,
                        unitController: logic.quickUnitCtrl,
                        onAdd: logic.addQuickScopeItem,
                      ),
                    ],
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: BidPrimaryButton(
                label: 'Continue to Bid Details',
                onPressed: logic.continueToDetails,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
