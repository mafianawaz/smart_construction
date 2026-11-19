import 'package:get/get.dart';

import 'data/shared_documents_mock_data.dart';
import 'models/shared_document_model.dart';


/// Controller for [SharedDocumentsView].
class SharedDocumentsLogic extends GetxController {
  final RxList<SharedDocumentModel> documents = <SharedDocumentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    documents.assignAll(SharedDocumentsMockData.sharedDocuments());
  }

  bool get hasDocuments => documents.isNotEmpty;

  /// Downloads a document to the device.
  // TODO(api): GET /api/field-worker/shared-documents/{id}/download
  Future<void> downloadDocument(SharedDocumentModel document) async {
    // Stubbed — wire up to whatever file-download/save package the app uses
    // once one is confirmed (none identified yet).
  }

  /// Opens/previews a document in place.
  // TODO(api): GET /api/field-worker/shared-documents/{id}
  Future<void> openDocument(SharedDocumentModel document) async {
    // Stubbed — same as above.
  }
}
