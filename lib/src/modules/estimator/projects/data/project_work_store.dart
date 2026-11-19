import 'package:get/get.dart';

import '../models/estimate_models.dart';
import '../models/field_ops_models.dart';
import '../models/financial_models.dart';
import '../models/location_models.dart';
import '../models/materials_models.dart';
import '../models/portal_models.dart';
import '../models/procurement_models.dart';
import '../models/project_docs_models.dart';
import '../models/quality_models.dart';
import '../models/project_enums.dart';
import '../models/scope_models.dart';
import 'field_ops_mock_data.dart';
import 'portal_mock_data.dart';
import 'financials_mock_data.dart';
import 'project_docs_mock_data.dart';
import 'projects_mock_data.dart';
import 'quality_mock_data.dart';

/// In-memory source of truth for the data these tabs share or create:
/// scope items (read by Materials), material usage, estimate lines and
/// markup overrides, locations and purchase requests.
///
/// Why a store instead of tab-local lists: the tab controllers are
/// auto-removed by `GetBuilder` when you switch tabs, which would wipe
/// anything created in a pushed form. Keeping the lists here means
/// Scope -> Materials and Add Line Item -> Estimate stay in sync and
/// survive tab switches. Each getter is the mock-data seam; replace the
/// seed with the real fetch when the API lands.
class ProjectWorkStore extends GetxService {
  static ProjectWorkStore get to => Get.isRegistered<ProjectWorkStore>()
      ? Get.find<ProjectWorkStore>()
      : Get.put(ProjectWorkStore(), permanent: true);

  final _scopeItems = <String, RxList<ScopeItemModel>>{};
  final _usages = <String, RxList<MaterialUsageModel>>{};
  final _estimateLines = <String, RxList<EstimateLineItemModel>>{};
  final _markupOverrides = <String, RxMap<MarkupKind, double>>{};
  final _estimateStatus = <String, Rx<EstimateStatus>>{};
  final _locations = <String, RxList<LocationModel>>{};
  final _purchaseRequests = <String, RxList<PurchaseRequestModel>>{};
  final _purchaseOrders = <String, RxList<PurchaseOrderModel>>{};
  final _changeOrders = <String, RxList<ChangeOrderRecord>>{};
  final _receipts = <String, RxList<ReceiptRecord>>{};
  final _sovs = <String, RxList<SovRecord>>{};
  final _payments = <String, RxList<PaymentRecord>>{};
  final _lienWaivers = <String, RxList<LienWaiverRecord>>{};
  final _dailyNotes = <String, RxList<DailyNoteModel>>{};
  final _punchItems = <String, RxList<PunchItemModel>>{};
  final _tmTimeEntries = <String, RxList<TmTimeEntryModel>>{};
  final _laborEntries = <String, RxList<LaborEntryModel>>{};
  final _subcontractors = <String, RxList<SubcontractAssignmentModel>>{};
  final _plannedEquipment = <String, RxList<PlannedEquipmentModel>>{};
  final _assignedEquipment = <String, RxList<AssignedEquipmentModel>>{};
  final _rfis = <String, RxList<RfiModel>>{};
  final _transmittals = <String, RxList<TransmittalModel>>{};
  final _submittals = <String, RxList<SubmittalModel>>{};
  final _closeoutItems = <String, RxList<CloseoutItemModel>>{};
  final _warrantyCases = <String, RxList<WarrantyCaseModel>>{};
  final _maintenanceLogs = <String, RxList<MaintenanceLogModel>>{};
  final _maintenanceSchedules = <String, RxList<MaintenanceScheduleModel>>{};
  final _progressReports = <String, RxList<ProgressReportModel>>{};
  final _reportAutomation = <String, Rx<ReportAutomationSettings>>{};
  final _vaultDocuments = <String, RxList<VaultDocumentModel>>{};
  final _clientAccess = <String, RxList<ClientPortalAccessModel>>{};
  final _subcontractorTokens = <String, RxList<SubcontractorAccessTokenModel>>{};
  final _portalSubTab = <String, Rx<PortalSubTab>>{};

  // API: GET /projects/{id}/scope-items
  RxList<ScopeItemModel> scopeItems(String projectId) => _scopeItems.putIfAbsent(
      projectId, () => RxList<ScopeItemModel>(ProjectsMockData.scopeItems(projectId)));

  // API: GET /projects/{id}/material-usage
  RxList<MaterialUsageModel> materialUsages(String projectId) => _usages.putIfAbsent(
      projectId, () => RxList<MaterialUsageModel>(ProjectsMockData.materialUsages(projectId)));

  // API: GET /projects/{id}/estimate/line-items
  RxList<EstimateLineItemModel> estimateLines(String projectId) => _estimateLines.putIfAbsent(
      projectId,
      () => RxList<EstimateLineItemModel>(ProjectsMockData.estimateLineItems(projectId)));

  /// Only the markups the user overrode for this estimate; a missing key
  /// means "inherited from the org default".
  // API: GET /projects/{id}/estimate/markup-overrides
  RxMap<MarkupKind, double> markupOverrides(String projectId) =>
      _markupOverrides.putIfAbsent(projectId, () => RxMap<MarkupKind, double>());

  // API: GET /projects/{id}/estimate (status)
  Rx<EstimateStatus> estimateStatus(String projectId) =>
      _estimateStatus.putIfAbsent(projectId, () => EstimateStatus.draft.obs);

  // API: GET /projects/{id}/locations
  RxList<LocationModel> locations(String projectId) => _locations.putIfAbsent(
      projectId, () => RxList<LocationModel>(ProjectsMockData.locations(projectId)));

  // API: GET /projects/{id}/purchase-requests
  RxList<PurchaseRequestModel> purchaseRequests(String projectId) => _purchaseRequests.putIfAbsent(
      projectId,
      () => RxList<PurchaseRequestModel>(ProjectsMockData.purchaseRequests(projectId)));

  // API: GET /projects/{id}/purchase-orders
  RxList<PurchaseOrderModel> purchaseOrders(String projectId) => _purchaseOrders.putIfAbsent(
      projectId,
      () => RxList<PurchaseOrderModel>(FinancialsMockData.purchaseOrders(projectId)));

  // API: GET /projects/{id}/change-orders
  RxList<ChangeOrderRecord> changeOrderRecords(String projectId) => _changeOrders.putIfAbsent(
      projectId, () => RxList<ChangeOrderRecord>(FinancialsMockData.changeOrders(projectId)));

  // API: GET /projects/{id}/receipts
  RxList<ReceiptRecord> receipts(String projectId) => _receipts.putIfAbsent(
      projectId, () => RxList<ReceiptRecord>(FinancialsMockData.receipts(projectId)));

  // API: GET /projects/{id}/sovs
  RxList<SovRecord> sovs(String projectId) => _sovs.putIfAbsent(
      projectId, () => RxList<SovRecord>(FinancialsMockData.sovs(projectId)));

  // API: GET /projects/{id}/sov-payments
  RxList<PaymentRecord> payments(String projectId) => _payments.putIfAbsent(
      projectId, () => RxList<PaymentRecord>(FinancialsMockData.payments(projectId)));

  // API: GET /projects/{id}/lien-waivers
  RxList<LienWaiverRecord> lienWaivers(String projectId) => _lienWaivers.putIfAbsent(
      projectId, () => RxList<LienWaiverRecord>(FinancialsMockData.lienWaivers(projectId)));

  // API: GET /projects/{id}/daily-notes
  RxList<DailyNoteModel> dailyNotes(String projectId) => _dailyNotes.putIfAbsent(
      projectId, () => RxList<DailyNoteModel>(QualityMockData.dailyNotes(projectId)));

  // API: GET /projects/{id}/punch-items
  RxList<PunchItemModel> punchItems(String projectId) => _punchItems.putIfAbsent(
      projectId, () => RxList<PunchItemModel>(FieldOpsMockData.punchItems(projectId)));

  // API: GET /projects/{id}/tm/time-entries
  RxList<TmTimeEntryModel> tmTimeEntries(String projectId) => _tmTimeEntries.putIfAbsent(
      projectId, () => RxList<TmTimeEntryModel>(FieldOpsMockData.tmTimeEntries(projectId)));

  // API: GET /projects/{id}/labor-hours
  RxList<LaborEntryModel> laborEntries(String projectId) => _laborEntries.putIfAbsent(
      projectId, () => RxList<LaborEntryModel>(FieldOpsMockData.laborEntries(projectId)));

  // API: GET /projects/{id}/subcontractor-assignments
  RxList<SubcontractAssignmentModel> subcontractors(String projectId) =>
      _subcontractors.putIfAbsent(projectId,
          () => RxList<SubcontractAssignmentModel>(FieldOpsMockData.subcontractors(projectId)));

  // API: GET /projects/{id}/equipment/plan
  RxList<PlannedEquipmentModel> plannedEquipment(String projectId) =>
      _plannedEquipment.putIfAbsent(projectId,
          () => RxList<PlannedEquipmentModel>(FieldOpsMockData.plannedEquipment(projectId)));

  // API: GET /projects/{id}/equipment/assigned
  RxList<AssignedEquipmentModel> assignedEquipment(String projectId) =>
      _assignedEquipment.putIfAbsent(projectId,
          () => RxList<AssignedEquipmentModel>(FieldOpsMockData.assignedEquipment(projectId)));

  // API: GET /projects/{id}/rfis
  RxList<RfiModel> rfis(String projectId) => _rfis.putIfAbsent(
      projectId, () => RxList<RfiModel>(ProjectDocsMockData.rfis(projectId)));

  // API: GET /projects/{id}/transmittals
  RxList<TransmittalModel> transmittals(String projectId) => _transmittals.putIfAbsent(
      projectId, () => RxList<TransmittalModel>(ProjectDocsMockData.transmittals(projectId)));

  // API: GET /projects/{id}/submittals
  RxList<SubmittalModel> submittals(String projectId) => _submittals.putIfAbsent(
      projectId, () => RxList<SubmittalModel>(ProjectDocsMockData.submittals(projectId)));

  // API: GET /projects/{id}/closeout/items
  RxList<CloseoutItemModel> closeoutItems(String projectId) => _closeoutItems.putIfAbsent(
      projectId, () => RxList<CloseoutItemModel>(ProjectDocsMockData.closeoutItems(projectId)));

  // API: GET /projects/{id}/warranty-cases
  RxList<WarrantyCaseModel> warrantyCases(String projectId) => _warrantyCases.putIfAbsent(
      projectId, () => RxList<WarrantyCaseModel>(ProjectDocsMockData.warrantyCases(projectId)));

  // API: GET /projects/{id}/maintenance/logs
  RxList<MaintenanceLogModel> maintenanceLogs(String projectId) => _maintenanceLogs.putIfAbsent(
      projectId,
      () => RxList<MaintenanceLogModel>(ProjectDocsMockData.maintenanceLogs(projectId)));

  // API: GET /projects/{id}/maintenance/schedules
  RxList<MaintenanceScheduleModel> maintenanceSchedules(String projectId) =>
      _maintenanceSchedules.putIfAbsent(
          projectId,
          () => RxList<MaintenanceScheduleModel>(
              ProjectDocsMockData.maintenanceSchedules(projectId)));

  // API: GET /projects/{id}/progress-reports
  RxList<ProgressReportModel> progressReports(String projectId) => _progressReports.putIfAbsent(
      projectId, () => RxList<ProgressReportModel>(PortalMockData.reports(projectId)));

  // API: GET /projects/{id}/progress-reports/settings
  Rx<ReportAutomationSettings> reportAutomation(String projectId) =>
      _reportAutomation.putIfAbsent(
          projectId, () => PortalMockData.reportAutomation(projectId).obs);

  // API: GET /projects/{id}/vault/documents
  RxList<VaultDocumentModel> vaultDocuments(String projectId) => _vaultDocuments.putIfAbsent(
      projectId, () => RxList<VaultDocumentModel>(PortalMockData.vaultDocuments(projectId)));

  // API: GET /projects/{id}/portal/clients
  RxList<ClientPortalAccessModel> clientAccess(String projectId) => _clientAccess.putIfAbsent(
      projectId, () => RxList<ClientPortalAccessModel>(PortalMockData.clientAccess(projectId)));

  // API: GET /projects/{id}/portal/subcontractor-tokens
  RxList<SubcontractorAccessTokenModel> subcontractorTokens(String projectId) =>
      _subcontractorTokens.putIfAbsent(
          projectId,
          () => RxList<SubcontractorAccessTokenModel>(
              PortalMockData.subcontractorTokens(projectId)));

  /// Kept here (not in the tab's controller) so the Project Detail app bar
  /// can read it for the "Client Portal" / "Subcontractor Portal" title.
  Rx<PortalSubTab> portalSubTab(String projectId) =>
      _portalSubTab.putIfAbsent(projectId, () => PortalSubTab.client.obs);
}
