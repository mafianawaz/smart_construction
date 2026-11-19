import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import '../../../../utils/app_color.dart';
import '../models/pricing_category.dart';
import '../widgets/bulk_upload_step.dart';
import '../widgets/csv_upload_dropzone.dart';
import 'logic.dart';


class BulkUploadView extends StatelessWidget {
  final PricingCategory category;

  const BulkUploadView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BulkUploadLogic>(
      init: BulkUploadLogic(category: category),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'My Pricing',
            showBackButton: true,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Bulk ${category.name} Item',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Upload multiple pricing items at once using a CSV file.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(height: 20),
                BulkUploadStep(
                  number: 1,
                  title: 'Download CSV Template',
                  description: 'Download the template file to ensure your data matches the required format.',
                  action: SizedBox(
                    width: 180,
                    child: OutlineIconButton(
                      onPressed: logic.downloadTemplate,
                      icon: AppIcons.export,
                      text: 'Download CSV'
                    ),
                  ),
                ),
                BulkUploadStep(
                  number: 2,
                  title: 'Fill Out the CSV File',
                  description:
                      'Open the downloaded file in Excel or Google '
                      'Sheets and fill in your item details.',
                ),
                BulkUploadStep(
                  number: 3,
                  title: 'Upload CSV File',
                  description:
                      'Once filled in, upload the CSV file below.',
                  showConnector: false,
                  action: CsvUploadDropzone(
                    fileName: logic.selectedFileName.value.isEmpty
                        ? null
                        : logic.selectedFileName.value,
                    onBrowse: () {
                      // TODO(native): swap for the platform file
                      // picker — stubbed here with a fixed file name
                      // since there's no picker package wired up yet.
                      logic.pickFile('pricing-items.csv');
                      logic.update();
                    },
                    onClear: () {
                      logic.clearFile();
                      logic.update();
                    },
                  ),
                ),
                if (logic.errorMessage.value.isNotEmpty) ...[
                  Text(
                    logic.errorMessage.value,
                    style: TextStyle(color: AppColors.redColor, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                ],
                CustomButton(
                    text: 'Upload',
                    onPressed: logic.isUploading.value
                        ? null
                        : () async {
                      final success = await logic.upload();
                      logic.update();
                      if (success) {
                        Get.back(result: true);
                      }
                    },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
