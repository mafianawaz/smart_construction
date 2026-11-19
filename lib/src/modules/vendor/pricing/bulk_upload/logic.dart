import 'package:get/get.dart';

import '../models/pricing_category.dart';

class BulkUploadLogic extends GetxController {
  BulkUploadLogic({required this.category});

  final PricingCategory category;

  final RxString selectedFileName = ''.obs;
  final RxBool isUploading = false.obs;
  final RxString errorMessage = ''.obs;

  bool get hasFile => selectedFileName.value.isNotEmpty;

  void downloadTemplate() {
    // TODO(api): GET /api/pricing-items/csv-template?category=<category>
    // — stream the template to the platform's share/save sheet.
  }

  /// Stands in for the native file picker. Swap for
  /// `FilePicker.platform.pickFiles(type: FileType.custom, ...)` (or
  /// equivalent) once the package is wired up — see NOTES_PRICING.md.
  void pickFile(String fileName) {
    if (!fileName.toLowerCase().endsWith('.csv')) {
      errorMessage.value = 'Please select a .csv file.';
      return;
    }
    errorMessage.value = '';
    selectedFileName.value = fileName;
  }

  void clearFile() => selectedFileName.value = '';

  Future<bool> upload() async {
    if (!hasFile) {
      errorMessage.value = 'Select a CSV file to upload first.';
      update();
      return false;
    }
    isUploading.value = true;
    update();
    // TODO(api): POST /api/pricing-items/bulk (multipart CSV upload).
    await Future.delayed(const Duration(seconds: 1));
    isUploading.value = false;
    update();
    return true;
  }
}
