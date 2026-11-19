import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/financials_mock_data.dart';
import '../../data/project_work_store.dart';
import '../../models/financial_models.dart';
import '../../data/quality_mock_data.dart';
import '../../models/project_enums.dart';
import '../../models/quality_models.dart';
import 'create_change_order_view.dart';
import 'create_lien_waiver_view.dart';
import 'create_sov_view.dart';
import 'record_payment_view.dart';
import 'upload_receipt_view.dart';

/// Owns the Financials tab. Records created in the pushed forms (change
/// orders, receipts, SOVs, payments, waivers) live in `ProjectWorkStore` so
/// they survive tab switches; Live Financials, Budget, Cost Ledger and Cost
/// Explorer data is read-only mock data here. Put with `tag: projectId`.
class FinancialsLogic extends GetxController {
  final String projectId;

  /// "204269" — shown in the Create SOV subtitle.
  final String projectNumber;

  /// "204269 · Riverside Plaza" — the single option on the lien waiver's
  /// Project dropdown.
  final String projectLabel;

  FinancialsLogic(this.projectId, {this.projectNumber = '', this.projectLabel = ''});

  ProjectWorkStore get _store => ProjectWorkStore.to;

  final subTab = FinancialsSubTab.liveFinancials.obs;
  void onSubTabChange(FinancialsSubTab t) => subTab.value = t;

  final sovTab = SovSubTab.payApp.obs;
  void onSovTabChange(SovSubTab t) => sovTab.value = t;

  // ---- Live Financials / Budget / Cost Ledger ---------------------------

  // API: GET /projects/{id}/financials/live
  late final Rx<LiveFinancialsModel> live =
      FinancialsMockData.liveFinancials(projectId).obs;

  // API: GET /projects/{id}/budget/lines
  late final RxList<BudgetLineModel> budgetLines =
      FinancialsMockData.budgetLines(projectId).obs;

  // API: GET /projects/{id}/cost-ledger
  late final RxList<CostLedgerRow> ledgerRows =
      FinancialsMockData.costLedger(projectId).obs;

  /// The two "Show" cards (Takeoff Cost by Location on Budget, Cost by
  /// Location on Cost Ledger) expand in place; the reference shows them
  /// collapsed and doesn't show the expanded content.
  final showTakeoffByLocation = false.obs;
  final showCostByLocation = false.obs;

  CostLedgerRow get ledgerTotal => CostLedgerRow(
        code: 'Project Total',
        budget: ledgerRows.fold(0.0, (s, r) => s + r.budget),
        committed: ledgerRows.fold(0.0, (s, r) => s + r.committed),
        actual: ledgerRows.fold(0.0, (s, r) => s + r.actual),
        etc: ledgerRows.fold(0.0, (s, r) => s + r.etc),
      );

  // ---- Cost Explorer ------------------------------------------------------

  // API: GET /projects/{id}/cost-transactions?category&module&code&from&to
  final RxList<CostTransactionModel> transactions =
      <CostTransactionModel>[].obs;

  final Rxn<CostCategory> categoryFilter = Rxn<CostCategory>();
  final Rxn<CostModule> moduleFilter = Rxn<CostModule>();
  final costCodeQuery = ''.obs;
  final costCodeCtrl = TextEditingController();
  final Rxn<DateTime> fromDate = Rxn<DateTime>();
  final Rxn<DateTime> toDate = Rxn<DateTime>();
  final grouping = CostGrouping.costCode.obs;

  @override
  void onInit() {
    super.onInit();
    transactions.assignAll(FinancialsMockData.costTransactions(projectId));
  }

  void resetExplorerFilters() {
    categoryFilter.value = null;
    moduleFilter.value = null;
    costCodeCtrl.clear();
    costCodeQuery.value = '';
    fromDate.value = null;
    toDate.value = null;
    grouping.value = CostGrouping.costCode;
  }

  /// Call inside an `Obx`.
  List<CostTransactionModel> get filteredTransactions => transactions.where((t) {
        if (categoryFilter.value != null && t.category != categoryFilter.value) return false;
        if (moduleFilter.value != null && t.module != moduleFilter.value) return false;
        final q = costCodeQuery.value.trim().toLowerCase();
        if (q.isNotEmpty && !t.costCode.toLowerCase().contains(q)) return false;
        if (fromDate.value != null && t.date.isBefore(fromDate.value!)) return false;
        if (toDate.value != null &&
            t.date.isAfter(toDate.value!.add(const Duration(days: 1)))) {
          return false;
        }
        return true;
      }).toList();

  /// Totals per group for the Summary card, keyed by the active grouping.
  Map<String, double> get groupedSummary {
    final out = <String, double>{};
    for (final t in filteredTransactions) {
      String key;
      switch (grouping.value) {
        case CostGrouping.costCode:
          key = t.costCode;
          break;
        case CostGrouping.category:
          key = t.category.label;
          break;
        case CostGrouping.module:
          key = t.module.label;
          break;
      }
      out[key] = (out[key] ?? 0) + t.amount;
    }
    return out;
  }

  // ---- Change Orders ------------------------------------------------------

  RxList<ChangeOrderRecord> get changeOrders => _store.changeOrderRecords(projectId);

  void openNewChangeOrder() => Get.to(
        () => CreateChangeOrderView(projectId: projectId),
        routeName: '/financials/create-change-order',
      );

  // API: GET /projects/{id}/change-orders/export?format=csv
  void exportChangeOrdersCsv() {
    if (changeOrders.isEmpty) {
      Get.snackbar('Nothing to export', 'Create a change order first.');
      return;
    }
    Get.snackbar('Export', 'CSV export is not wired up yet.');
  }

  // ---- Receipts -----------------------------------------------------------

  RxList<ReceiptRecord> get receipts => _store.receipts(projectId);

  void openUploadReceipt() => Get.to(
        () => UploadReceiptView(projectId: projectId),
        routeName: '/financials/upload-receipt',
      );

  // ---- Schedule of Values -------------------------------------------------

  RxList<SovRecord> get sovs => _store.sovs(projectId);
  RxList<PaymentRecord> get payments => _store.payments(projectId);
  RxList<LienWaiverRecord> get lienWaivers => _store.lienWaivers(projectId);

  /// Total paid against one SOV. Call inside an `Obx`.
  double paidFor(String sovId) =>
      payments.where((p) => p.sovId == sovId).fold(0.0, (s, p) => s + p.amount);

  void openNewSov() => Get.to(
        () => CreateSovView(projectId: projectId, projectNumber: projectNumber),
        routeName: '/financials/create-sov',
      );

  void openRecordPayment() {
    if (sovs.isEmpty) {
      Get.snackbar('No SOV yet', 'Create a Schedule of Values before recording a payment.');
      return;
    }
    Get.to(
      () => RecordPaymentView(projectId: projectId),
      routeName: '/financials/record-payment',
    );
  }

  void openNewWaiver() => Get.to(
        () => CreateLienWaiverView(projectId: projectId, projectLabel: projectLabel),
        routeName: '/financials/create-lien-waiver',
      );

  // ---- Billing -----------------------------------------------------------

  /// Stored Materials and Retention Releases panels are open by default, as
  /// drawn in the reference (chevron down, content showing).
  final storedMaterialsOpen = true.obs;
  final retentionOpen = true.obs;

  // API: POST /projects/{id}/pay-apps
  /// The reference has no Create Pay App form, so this is a stub; the button
  /// is only enabled once an SOV exists ("Create a Schedule of Values first").
  void newPayApp() => Get.snackbar('New Pay App', 'Pay app creation is not wired up yet.');

  void openBillingHub() =>
      Get.snackbar('Billing Hub', 'The Billing Hub is not wired up yet.');

  // ---- Production Rates ---------------------------------------------------

  final productionTab = ProductionRatesTab.benchmarks.obs;
  void onProductionTabChange(ProductionRatesTab t) => productionTab.value = t;

  final productionSearch = ''.obs;
  void onProductionSearch(query) => productionSearch.value = query.trim().toLowerCase();

  // API: GET /projects/{id}/production-rates/benchmarks
  late final RxList<ProductionBenchmarkModel> benchmarks =
      QualityMockData.benchmarks(projectId).obs;

  // API: GET /projects/{id}/production-rates/cost-analytics
  late final RxList<CostPerUnitModel> costAnalytics =
      QualityMockData.costAnalytics(projectId).obs;

  /// Search matches the scope-of-work name. Call inside an `Obx`.
  List<ProductionBenchmarkModel> get filteredBenchmarks => benchmarks
      .where((b) =>
          productionSearch.value.isEmpty ||
          b.scopeName.toLowerCase().contains(productionSearch.value))
      .toList();

  List<CostPerUnitModel> get filteredCostAnalytics => costAnalytics
      .where((c) =>
          productionSearch.value.isEmpty ||
          c.scopeName.toLowerCase().contains(productionSearch.value))
      .toList();

  @override
  void onClose() {
    costCodeCtrl.dispose();
    super.onClose();
  }
}
