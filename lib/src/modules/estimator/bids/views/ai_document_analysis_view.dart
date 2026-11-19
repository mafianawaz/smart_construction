import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import '../logic/create_bid_logic.dart';
import '../models/create_bid_enums.dart';
import '../widgets/ai_analysis_status_card.dart';
import '../widgets/bid_step_indicator.dart';

/// AI flow, step 3 of 4 — AI Document Analysis. Success has no UI of its
/// own ([CreateBidLogic.analyzeDocuments] navigates straight to Confirm
/// Scope of Work), so this only renders "analyzing" or "failed".
/// Failed offers Retry Analysis / Manual Entry / Skip To Scope.
class AiDocumentAnalysisView extends StatelessWidget {
  const AiDocumentAnalysisView({super.key});

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
              currentIndex: 2,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
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
                          Icon(Icons.auto_awesome,
                              size: 18, color: AppColors.primaryOrange),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('AI Document Analysis',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 14)),
                                const SizedBox(height: 2),
                                Text(
                                  'Reading your documents to extract the scope '
                                  'of work and project details.',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Obx(() {
                      if (logic.aiStatus.value == AiAnalysisStatus.failed) {
                        return AiAnalysisStatusCard.failed(
                          onRetry: logic.retryAnalysis,
                          onManualEntry: logic.switchToManualFlow,
                          onSkipToScope: logic.skipToScope,
                        );
                      }
                      return const AiAnalysisStatusCard.analyzing();
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
