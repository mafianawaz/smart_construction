import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';

import '../logic/create_bid_logic.dart';
import '../models/create_bid_enums.dart';
import '../widgets/add_custom_scope_item_bar.dart';
import '../widgets/bid_form_sections.dart';
import '../widgets/bid_step_indicator.dart';
import '../widgets/scope_item_card.dart';

/// AI flow, step 4 of 4 — Confirm Scope of Work. Shows the AI-extracted
/// items (or the empty state after skip/failure), lets the user add
/// custom items, and finishes with Create Bid.
class ConfirmScopeView extends StatelessWidget {
  const ConfirmScopeView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<CreateBidLogic>();

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Create New Bid',
        showBackButton: true,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            BidStepIndicator(
              stepLabels: CreateBidFlow.ai.stepLabels,
              currentIndex: 3,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.assignment_outlined,
                                size: 18, color: AppColors.primaryOrange),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Confirm Scope of Work',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 14)),
                                const SizedBox(height: 2),
                                Text(
                                  'Review the items below, uncheck anything that '
                                  "doesn't apply, or add your own.",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      final items = logic.scopeItems;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Scope Items',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700, fontSize: 13)),
                              Text('${logic.selectedCount} selected',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey.shade500)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (items.isEmpty)
                            const AppEmptyState(
                              icon: Icons.inbox_outlined,
                              title: 'No Scope Items',
                              message:
                                  'Add scope items below to build your bid.',
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
                        ],
                      );
                    }),
                    const SizedBox(height: 16),
                    AddCustomScopeItemBar(
                      descriptionController: logic.quickDescCtrl,
                      quantityController: logic.quickQtyCtrl,
                      unitController: logic.quickUnitCtrl,
                      onAdd: logic.addQuickScopeItem,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() => BidPrimaryButton(
                    label: 'Create Bid',
                    loading: logic.isSubmitting.value,
                    onPressed: logic.createBid,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
