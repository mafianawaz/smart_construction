import '../models/shared_document_model.dart';

/// Static mock data for the Shared Documents module.
class SharedDocumentsMockData {
  SharedDocumentsMockData._();

  /// Populated list — matches the second reference frame. The reference
  /// shows two near-duplicate entries (one titled without, one with, the
  /// ".pdf" extension) — kept as two distinct entries rather than assumed
  /// to be a design duplicate; see NOTES_SHARED_DOCUMENTS.md.
  // TODO(api): GET /api/field-worker/shared-documents
  static List<SharedDocumentModel> sharedDocuments() {
    return [
      SharedDocumentModel(
        id: 'doc_bghc_1',
        title: '1-22 Pages from BGHC Exterior',
        organizationName: 'Dev Sandbox Organization',
        sharedDate: DateTime(2023, 12, 9),
        category: 'OTHER',
        fileFormat: 'PDF',
        fileSize: '6.3MB'
      ),
      SharedDocumentModel(
        id: 'doc_bghc_2',
        title: '1-22 Pages from BGHC Exterior.pdf',
        organizationName: 'Dev Sandbox Organization',
        sharedDate: DateTime(2023, 12, 9),
        category: 'OTHER',
        fileFormat: 'PDF',
        fileSize: '6.3MB'
      ),
    ];
  }

  /// Empty list — matches the first reference frame.
  static List<SharedDocumentModel> emptyDocuments() => [];
}
