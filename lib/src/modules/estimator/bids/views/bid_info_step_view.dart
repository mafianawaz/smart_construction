import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';

import '../logic/create_bid_logic.dart';
import '../models/create_bid_enums.dart';
import '../widgets/bid_form_sections.dart';
import '../widgets/bid_step_indicator.dart';

/// AI flow, step 1 of 4 — "Create New Bid" with Bid Details, Client
/// Information and Location. Button: "Continue to Upload".
class BidInfoStepView extends StatelessWidget {
  const BidInfoStepView({super.key});

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
              currentIndex: 0,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    BidBasicsSection(logic: logic),
                    BidClientSection(
                      logic: logic,
                      title: 'Client Information',
                      subtitle: 'Select from CRM (Optional)',
                      showSavedContact: true,
                    ),
                    BidLocationSection(logic: logic, title: 'Location'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                text: 'Continue to Upload',
                onPressed: logic.continueFromInfo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
