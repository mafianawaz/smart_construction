import 'project_enums.dart';

/// One generated progress report (weekly or monthly).
class ProgressReportModel {
  final String id;
  final ReportType type;
  final DateTime rangeStart;
  final DateTime rangeEnd;
  final DateTime generatedAt;

  const ProgressReportModel({
    required this.id,
    required this.type,
    required this.rangeStart,
    required this.rangeEnd,
    required this.generatedAt,
  });
}

/// Report Automation Settings + Email Recipients on Reports Settings.
class ReportAutomationSettings {
  final bool autoWeekly;
  final bool autoMonthly;
  final List<String> recipients;

  const ReportAutomationSettings({
    this.autoWeekly = false,
    this.autoMonthly = false,
    this.recipients = const [],
  });

  ReportAutomationSettings copyWith({
    bool? autoWeekly,
    bool? autoMonthly,
    List<String>? recipients,
  }) =>
      ReportAutomationSettings(
        autoWeekly: autoWeekly ?? this.autoWeekly,
        autoMonthly: autoMonthly ?? this.autoMonthly,
        recipients: recipients ?? this.recipients,
      );
}

/// A document in the Project Vault repository. The vault is read-only in
/// the references ("Uploaded documents will appear here").
class VaultDocumentModel {
  final String id;
  final String name;
  final String category;
  final DateTime uploadedAt;
  final String? uploadedBy;

  const VaultDocumentModel({
    required this.id,
    required this.name,
    required this.category,
    required this.uploadedAt,
    this.uploadedBy,
  });
}

/// A client / stakeholder invited to the client portal.
class ClientPortalAccessModel {
  final String id;
  final String name;
  final String email;
  final PortalAccessType accessType;
  final Set<ClientPortalPermission> permissions;
  final PortalInviteStatus status;
  final DateTime invitedAt;

  const ClientPortalAccessModel({
    required this.id,
    required this.name,
    required this.email,
    required this.accessType,
    required this.permissions,
    this.status = PortalInviteStatus.pending,
    required this.invitedAt,
  });
}

/// A subcontractor's portal access token.
class SubcontractorAccessTokenModel {
  final String id;
  final String organisation;
  final String contactName;
  final String contactEmail;
  final Set<SubcontractorPermission> permissions;
  final DateTime createdAt;
  final DateTime expiresAt;

  const SubcontractorAccessTokenModel({
    required this.id,
    required this.organisation,
    required this.contactName,
    required this.contactEmail,
    required this.permissions,
    required this.createdAt,
    required this.expiresAt,
  });

  bool get isActive => expiresAt.isAfter(DateTime.now());
}

/// Option in the "CRM Organisation" dropdown on Invite Subcontractor.
class CrmOrganisationModel {
  final String id;
  final String name;
  const CrmOrganisationModel({required this.id, required this.name});
}
