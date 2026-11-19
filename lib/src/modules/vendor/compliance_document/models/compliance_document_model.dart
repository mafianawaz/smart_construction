import 'package:flutter/foundation.dart';

/// Type of compliance document. Extend as new required/optional document
/// kinds are introduced.
enum ComplianceDocType {
  certificationOfInsurance,
  w9Form,
  dbeCertification,
  performanceBond,
  other,
}

extension ComplianceDocTypeX on ComplianceDocType {
  String get label {
    switch (this) {
      case ComplianceDocType.certificationOfInsurance:
        return 'Certification of Insurance';
      case ComplianceDocType.w9Form:
        return 'W-9 Form';
      case ComplianceDocType.dbeCertification:
        return 'DBE Certification';
      case ComplianceDocType.performanceBond:
        return 'Performance Bond';
      case ComplianceDocType.other:
        return 'Document';
    }
  }

  /// Short code shown under the title in history tiles, e.g. "DBE",
  /// "BOND_PERFORMANCE". Mirrors the reference design's monospace tags.
  String get code {
    switch (this) {
      case ComplianceDocType.certificationOfInsurance:
        return 'COI';
      case ComplianceDocType.w9Form:
        return 'W9';
      case ComplianceDocType.dbeCertification:
        return 'DBE';
      case ComplianceDocType.performanceBond:
        return 'BOND_PERFORMANCE';
      case ComplianceDocType.other:
        return 'DOC';
    }
  }
}

/// Status of a single compliance document.
enum ComplianceDocStatus { notUploaded, active, valid, expired, delayed }

extension ComplianceDocStatusX on ComplianceDocStatus {
  String get label {
    switch (this) {
      case ComplianceDocStatus.notUploaded:
        return 'Not Uploaded';
      case ComplianceDocStatus.active:
        return 'Active';
      case ComplianceDocStatus.valid:
        return 'Valid';
      case ComplianceDocStatus.expired:
        return 'Expired';
      case ComplianceDocStatus.delayed:
        return 'Delayed';
    }
  }
}

/// A single compliance document — either one of the two required uploads
/// (Certification of Insurance / W-9) shown at the top of the screen, or an
/// entry in Document History below it.
class ComplianceDocumentModel {
  final String id;
  final ComplianceDocType type;
  final ComplianceDocStatus status;
  final String? fileName;
  final DateTime? uploadedDate;
  final DateTime? expirationDate;

  /// Free-text confirmation shown on the details screen, e.g.
  /// "This document is current and accepted."
  final String? statusMessage;

  const ComplianceDocumentModel({
    required this.id,
    required this.type,
    required this.status,
    this.fileName,
    this.uploadedDate,
    this.expirationDate,
    this.statusMessage,
  });

  bool get isUploaded => status != ComplianceDocStatus.notUploaded;

  String get formattedUploadedDate =>
      uploadedDate == null ? '—' : _format(uploadedDate!);

  String get formattedExpirationDate =>
      expirationDate == null ? '—' : _format(expirationDate!);

  static String _format(DateTime d) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  ComplianceDocumentModel copyWith({
    ComplianceDocStatus? status,
    String? fileName,
    DateTime? uploadedDate,
    DateTime? expirationDate,
    String? statusMessage,
  }) {
    return ComplianceDocumentModel(
      id: id,
      type: type,
      status: status ?? this.status,
      fileName: fileName ?? this.fileName,
      uploadedDate: uploadedDate ?? this.uploadedDate,
      expirationDate: expirationDate ?? this.expirationDate,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComplianceDocumentModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
