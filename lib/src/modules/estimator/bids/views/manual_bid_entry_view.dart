import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import '../logic/create_bid_logic.dart';
import '../models/create_bid_enums.dart';
import '../widgets/bid_fields.dart';
import '../widgets/bid_step_indicator.dart';

/// Manual flow, step 1 of 3 — Manual Bid Entry: project name and a
/// free-text scope description. Reached from the "+" menu, or from the
/// AI Scan failure screen's "Manual Entry" button.
class ManualBidEntryView extends StatefulWidget {
  const ManualBidEntryView({super.key});

  @override
  State<ManualBidEntryView> createState() => _ManualBidEntryViewState();
}

class _ManualBidEntryViewState extends State<ManualBidEntryView> {
  late final CreateBidLogic logic = Get.find<CreateBidLogic>();
  late final TextEditingController _nameCtrl =
      TextEditingController(text: logic.bidNameCtrl.text);

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Manual Bid Entry',
        showBackButton: true,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            BidStepIndicator(
              stepLabels: CreateBidFlow.manual.stepLabels,
              currentIndex: 0,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BidTextField(
                            label: 'Project Name',
                            controller: _nameCtrl,
                            hint: 'e.g. Berlin Lake Boat Ramp',
                          ),
                          const SizedBox(height: 14),
                          BidTextField(
                            label: 'Project Scope and Description',
                            controller: logic.manualScopeCtrl,
                            hint:
                                'Describe the project scope, work to be '
                                'performed, and any key requirements.',
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'You can break this into individual scope items, with '
                      'quantities and units, on the next screen.',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: logic.skipManualEntry,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Skip'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => logic.submitManualEntry(
                        projectName: _nameCtrl.text.trim(),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Add Item(s)'),
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
