import '../models/portal_models.dart';
import '../models/scheduled_log_model.dart';

/// Mock-data seam for Reports, Project Vault and Portal Access. The
/// references show empty states for every list, so nothing is seeded;
/// records appear once the Generate / Invite forms create them.
class PortalMockData {
  PortalMockData._();

  // API: GET /projects/{id}/progress-reports
  static List<ProgressReportModel> reports(String projectId) => const [];

  // API: GET /projects/{id}/progress-reports/settings
  static ReportAutomationSettings reportAutomation(String projectId) =>
      const ReportAutomationSettings();

  // API: GET /projects/{id}/vault/documents
  static List<VaultDocumentModel> vaultDocuments(String projectId) => const [];

  // API: GET /projects/{id}/portal/clients
  static List<ClientPortalAccessModel> clientAccess(String projectId) => const [];

  // API: GET /projects/{id}/portal/subcontractor-tokens
  static List<SubcontractorAccessTokenModel> subcontractorTokens(String projectId) =>
      const [];

  /// Flip to true to see the reference's "Couldn't load the scheduled log
  /// email settings" state on Reports Settings.
  static const bool simulateScheduledLogFailure = false;

  // API: GET /projects/{id}/scheduled-logs
  static Future<List<ScheduledLogSettings>> loadScheduledLogs(String projectId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (simulateScheduledLogFailure) throw Exception('scheduled logs unavailable');
    return const [
      ScheduledLogSettings(type: ScheduledLogType.rfi),
      ScheduledLogSettings(type: ScheduledLogType.submittal),
    ];
  }

  /// Guessed names — the reference dropdown only shows "Loading...".
  // API: GET /crm/organisations?type=subcontractor
  static Future<List<CrmOrganisationModel>> crmOrganisations() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      CrmOrganisationModel(id: 'org_1', name: 'Apex Concrete Co.'),
      CrmOrganisationModel(id: 'org_2', name: 'Lakeshore Electric'),
      CrmOrganisationModel(id: 'org_3', name: 'Summit Plumbing & Mechanical'),
      CrmOrganisationModel(id: 'org_4', name: 'Ridgeline Steel Erectors'),
    ];
  }
}

