import '../models/compliance_document_model.dart';

/// Static mock data for the Compliance Documents module.
///
/// Mock-data-as-API-seam: replace each method body with the corresponding
/// HTTP call when the real backend is wired up. The method signatures are
/// intended to stay stable across that swap.
class ComplianceMockData {
  ComplianceMockData._();

  /// The two required uploads shown at the top of the screen.
  // TODO(api): GET /api/vendor/compliance-documents/required
  static List<ComplianceDocumentModel> requiredDocuments() {
    return [
      const ComplianceDocumentModel(
        id: 'req_coi',
        type: ComplianceDocType.certificationOfInsurance,
        status: ComplianceDocStatus.active,
      ),
      const ComplianceDocumentModel(
        id: 'req_w9',
        type: ComplianceDocType.w9Form,
        status: ComplianceDocStatus.notUploaded,
      ),
    ];
  }

  /// All previously submitted compliance documents, newest first.
  // TODO(api): GET /api/vendor/compliance-documents/history
  static List<ComplianceDocumentModel> documentHistory() {
    return [
      ComplianceDocumentModel(
        id: 'hist_dbe_2026',
        type: ComplianceDocType.dbeCertification,
        status: ComplianceDocStatus.valid,
        fileName: 'DBE Certification (DBE-2026)',
        uploadedDate: DateTime(2026, 7, 22),
        expirationDate: DateTime(2027, 12, 31),
        statusMessage: 'This document is current and accepted.',
      ),
      ComplianceDocumentModel(
        id: 'hist_bond_perf',
        type: ComplianceDocType.performanceBond,
        status: ComplianceDocStatus.expired,
        fileName: 'Performance Bond (flawi)',
        uploadedDate: DateTime(2026, 6, 9),
      ),
    ];
  }

  /// Uploads or replaces a required document.
  // TODO(api): POST /api/vendor/compliance-documents  (multipart file upload)
  static Future<ComplianceDocumentModel> upload({
    required ComplianceDocumentModel target,
    required String fileName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return target.copyWith(
      status: ComplianceDocStatus.active,
      fileName: fileName,
      uploadedDate: DateTime.now(),
    );
  }
}
