import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../widgets/project_date_field.dart';
import '../widgets/project_form_card.dart';
import 'upload_receipt_logic.dart';

/// "Upload Receipt" — pushed from the Receipts sub-tab's Upload button.
/// Vendor / Amount / Category / Cost Code / Date; the pinned button reads
/// "Select File", as in the reference.
class UploadReceiptView extends StatelessWidget {
  final String projectId;
  const UploadReceiptView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadReceiptLogic>(
      init: UploadReceiptLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Upload Receipt',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fill in the details below and then select a file to upload.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 12),
                        ProjectFormCard(
                          children: [
                            CustomTextField(
                              heading: 'Vendor',
                              hintText: 'Enter vendor name...',
                              controller: logic.vendorCtrl,
                            ),
                            projectFieldGap,
                            CustomTextField(
                              heading: 'Amount (\$)',
                              hintText: '0.00',
                              controller: logic.amountCtrl,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                            projectFieldGap,
                            CustomTextField(
                              heading: 'Category',
                              hintText: 'Enter category...',
                              controller: logic.categoryCtrl,
                            ),
                            projectFieldGap,
                            CustomTextField(
                              heading: 'Cost Code',
                              hintText: 'Search or type a cost code...',
                              controller: logic.costCodeCtrl,
                              leftIconPath: AppIcons.search,
                            ),
                            projectFieldGap,
                            Obx(() => ProjectDateField(
                                  label: 'Date',
                                  format: 'MMMM d, y',
                                  value: logic.date.value,
                                  onChanged: (d) => logic.date.value = d,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Obx(() => CustomButton(
                        text: 'Select File',
                        onPressed: logic.isUploading.value ? null : logic.selectFileAndUpload,
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
