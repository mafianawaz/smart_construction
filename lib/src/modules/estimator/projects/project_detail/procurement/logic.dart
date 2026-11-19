import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/procurement_models.dart';
import '../../models/project_enums.dart';
import 'new_purchase_order_view.dart';
import 'new_request_view.dart';

/// Owns the Procurement tab (Requests / Orders / Receipts / Invoices /
/// Delivery Schedule). Requests and purchase orders live in
/// `ProjectWorkStore`; Receipts, Invoices and Delivery Schedule only have
/// empty-state references so far and hold just their filter state.
/// Put with `tag: projectId`.
class ProcurementLogic extends GetxController {
  final String projectId;
  ProcurementLogic(this.projectId);

  final subTab = ProcurementSubTab.requests.obs;
  void onSubTabChange(ProcurementSubTab t) => subTab.value = t;

  RxList<PurchaseRequestModel> get requests => ProjectWorkStore.to.purchaseRequests(projectId);

  final searchQuery = ''.obs;

  /// null = "All Statuses".
  final Rxn<PurchaseRequestStatus> statusFilter = Rxn<PurchaseRequestStatus>();

  void onSearch(query) => searchQuery.value = query.trim().toLowerCase();
  void setStatusFilter(PurchaseRequestStatus? s) => statusFilter.value = s;

  /// Matches the title or the PR number. Reads [requests], the search and
  /// the filter — call inside an `Obx`.
  List<PurchaseRequestModel> get filteredRequests => requests
      .where((r) => statusFilter.value == null || r.status == statusFilter.value)
      .where((r) =>
          searchQuery.value.isEmpty ||
          r.title.toLowerCase().contains(searchQuery.value) ||
          r.number.toLowerCase().contains(searchQuery.value))
      .toList();

  void openNewRequest() => Get.to(
        () => NewRequestView(projectId: projectId),
        routeName: '/procurement/new-request',
      );

  // ---- Orders -----------------------------------------------------------

  RxList<PurchaseOrderModel> get orders => ProjectWorkStore.to.purchaseOrders(projectId);

  final orderSearch = ''.obs;

  /// null = "All Statuses".
  final Rxn<PurchaseOrderStatus> orderStatusFilter = Rxn<PurchaseOrderStatus>();

  void onOrderSearch(query) => orderSearch.value = query.trim().toLowerCase();
  void setOrderStatusFilter(PurchaseOrderStatus? s) => orderStatusFilter.value = s;

  /// Matches the PO number or the vendor. Call inside an `Obx`.
  List<PurchaseOrderModel> get filteredOrders => orders
      .where((o) => orderStatusFilter.value == null || o.status == orderStatusFilter.value)
      .where((o) =>
          orderSearch.value.isEmpty ||
          o.number.toLowerCase().contains(orderSearch.value) ||
          o.vendor.toLowerCase().contains(orderSearch.value))
      .toList();

  /// Sum of every PO's line items. Call inside an `Obx`.
  double get totalCommitted => orders.fold(0.0, (sum, o) => sum + o.total);

  // Invoices and payments have no records yet, so these read as $0.00 —
  // the reference shows $0.00 for all three tiles.
  // API: GET /projects/{id}/purchase-orders/summary
  double get totalInvoiced => 0;
  double get totalPaid => 0;

  void openNewPurchaseOrder() => Get.to(
        () => NewPurchaseOrderView(projectId: projectId),
        routeName: '/procurement/new-purchase-order',
      );

  // ---- Invoices ---------------------------------------------------------

  final invoiceSearch = ''.obs;
  final Rxn<String> invoiceStatusFilter = Rxn<String>();

  /// Guessed — the reference shows only the "All Statuses" pill.
  static const List<String> invoiceStatuses = ['Pending', 'Approved', 'Paid', 'Disputed'];

  void onInvoiceSearch(query) => invoiceSearch.value = query.trim().toLowerCase();
  void setInvoiceStatusFilter(String? s) => invoiceStatusFilter.value = s;

  // ---- Delivery Schedule --------------------------------------------------

  final deliverySearch = ''.obs;
  final Rxn<DeliveryWindow> deliveryWindow = Rxn<DeliveryWindow>();

  void onDeliverySearch(query) => deliverySearch.value = query.trim().toLowerCase();
  void setDeliveryWindow(DeliveryWindow? w) => deliveryWindow.value = w;
}
