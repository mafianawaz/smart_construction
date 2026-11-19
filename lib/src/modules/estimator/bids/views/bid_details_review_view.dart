import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../logic/create_bid_logic.dart';
import '../models/create_bid_enums.dart';
import '../widgets/bid_form_sections.dart';
import '../widgets/bid_step_indicator.dart';

/// Manual flow, step 3 of 3 — Bid Details: the final confirm form
/// (Bid Details, CRM Integration, Client Details, Project Location)
/// followed by Create Bid.
class BidDetailsReviewView extends StatelessWidget {
  const BidDetailsReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<CreateBidLogic>();

    return Scaffold(
      appBar: AppBar(title: const Text('Bid Details'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Fill in remaining details to finalize the bid.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ),
                  Obx(() => logic.aiSuggestedCount == 0
                      ? const SizedBox.shrink()
                      : Text(
                          '${logic.aiSuggestedCount} AI suggested items',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryOrange,
                          ),
                        )),
                ],
              ),
            ),
            BidStepIndicator(
              stepLabels: CreateBidFlow.manual.stepLabels,
              currentIndex: 2,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    BidBasicsSection(logic: logic),
                    BidCrmSection(logic: logic),
                    BidClientSection(logic: logic, showEstimatedAmount: true),
                    BidLocationSection(logic: logic, showKeywords: true),
                    const BidReadyBanner(),
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
