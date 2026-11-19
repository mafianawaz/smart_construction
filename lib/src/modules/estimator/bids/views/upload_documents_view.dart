import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';

import '../logic/create_bid_logic.dart';
import '../models/create_bid_enums.dart';
import '../widgets/bid_document_dropzone.dart';
import '../widgets/bid_step_indicator.dart';

/// AI flow, step 2 of 4 — Upload Bid Documents.
/// "Skip AI Analysis" jumps to Scope; "Analyze Documents" starts the scan.
class UploadDocumentsView extends StatelessWidget {
  const UploadDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<CreateBidLogic>();

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Create New Bids',
        showBackButton: true,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            BidStepIndicator(
              stepLabels: CreateBidFlow.ai.stepLabels,
              currentIndex: 1,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.fieldBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upload Bid Documents',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Upload bid invitations, construction drawings, specifications, "
                            "and any other relevant documents. Our AI will analyze them to extract scope of work items and project details.",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 16),
                      Obx(() => BidDocumentDropzone(
                            fileName: logic.uploadedFileName.value,
                            onTap: logic.pickDocument,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: logic.skipToScope,
                      text: 'Skip AI Analysis',
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                          onPressed: logic.goToAiAnalysis,
                          text: 'Analyze Documents',
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
