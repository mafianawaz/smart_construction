import 'package:get/get.dart';

import 'data/compliance_mock_data.dart';
import 'models/compliance_document_model.dart';


/// Controller for [ComplianceDocumentsView]. Owns the two required-upload
/// slots and the document history list.
class ComplianceLogic extends GetxController {
  final RxList<ComplianceDocumentModel> requiredDocuments = <ComplianceDocumentModel>[].obs;
  final RxList<ComplianceDocumentModel> documentHistory = <ComplianceDocumentModel>[].obs;
  final RxBool isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    requiredDocuments.assignAll(ComplianceMockData.requiredDocuments());
    documentHistory.assignAll(ComplianceMockData.documentHistory());
  }

  bool get hasHistory => documentHistory.isNotEmpty;

  /// Kicks off the upload flow for one of the two required documents.
  /// The file-picker integration itself is stubbed — see NOTES_COMPLIANCE.md.
  Future<void> uploadRequiredDocument(ComplianceDocumentModel target) async {
    isUploading.value = true;
    final placeholderFileName = '${target.type.code.toLowerCase()}.pdf';
    final updated = await ComplianceMockData.upload(
      target: target,
      fileName: placeholderFileName,
    );
    final index = requiredDocuments.indexOf(target);
    if (index != -1) {
      requiredDocuments[index] = updated;
    }
    isUploading.value = false;
  }
}
