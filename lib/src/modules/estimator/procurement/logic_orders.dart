import 'package:get/get.dart';

import 'data/procurement_mock_data.dart';
import 'logic.dart';
import 'models/procurement_orders_models.dart';
import 'models/purchase_request_models.dart';
import 'new_invoice/view.dart';
import 'new_po/view.dart';
import 'new_receipt/view.dart';
import 'widgets/proc_list_widgets.dart';

/// Orders / Receipts / Invoices / Delivery Schedule behaviour for
/// [ProcurementLogic]. State lives on the controller; this file only adds
/// methods (extension) so `logic.dart` stays readable.
extension ProcurementOrdersLogic on ProcurementLogic {
  // ---- stat row -----------------------------------------------------------
  /// Sum of PO estimates that were not rejected.
  double get totalCommitted => orders
      .where((o) => o.status != PoStatus.rejected)
      .fold(0.0, (s, o) => s + o.estimate);

  double get totalInvoiced => invoices.fold(0.0, (s, i) => s + i.amount);

  double get totalPaid => invoices
      .where((i) => i.status == InvoiceStatus.paid)
      .fold(0.0, (s, i) => s + i.amount);

  // ---- filter menus -------------------------------------------------------
  String statusKeyOf(ProcTab t) => statusByTab[t] ?? ProcFilterPill.allKey;
  String projectKeyOf(ProcTab t) => projectByTab[t] ?? ProcFilterPill.allKey;

  Map<String, String> statusOptionsFor(ProcTab t) {
    switch (t) {
      case ProcTab.orders:
        return {
          ProcFilterPill.allKey: 'All Statuses',
          for (final s in PoStatus.values) s.name: s.label,
        };
      case ProcTab.receipts:
        return {
          ProcFilterPill.allKey: 'All Statuses',
          for (final s in ReceiptStatus.values) s.name: s.label,
        };
      case ProcTab.invoices:
        return {
          ProcFilterPill.allKey: 'All Statuses',
          for (final s in InvoiceStatus.values) s.name: s.label,
        };
      default:
        return {ProcFilterPill.allKey: 'All Statuses'};
    }
  }

  String statusLabelFor(ProcTab t) =>
      statusOptionsFor(t)[statusKeyOf(t)] ?? 'All Statuses';

  /// Project names that appear in this tab's records plus the shared list.
  Map<String, String> projectOptionsFor(ProcTab t) => {
        ProcFilterPill.allKey: 'All Projects',
        for (final p in projects) p: p,
      };

  String projectLabelFor(ProcTab t) =>
      projectKeyOf(t) == ProcFilterPill.allKey ? 'All Projects' : projectKeyOf(t);

  void setStatusFor(ProcTab t, String key) {
    statusByTab[t] = key;
    update();
  }

  void setProjectFor(ProcTab t, String key) {
    projectByTab[t] = key;
    update();
  }

  String searchTextOf(ProcTab t) =>
      (searchByTab[t]?.text ?? '').trim().toLowerCase();

  bool hasFiltersFor(ProcTab t) =>
      statusKeyOf(t) != ProcFilterPill.allKey ||
      projectKeyOf(t) != ProcFilterPill.allKey ||
      searchTextOf(t).isNotEmpty;

  void clearFiltersFor(ProcTab t) {
    statusByTab.remove(t);
    projectByTab.remove(t);
    searchByTab[t]?.clear();
    update();
  }

  bool _passes(ProcTab t, String status, String project, List<String> hay) {
    final sk = statusKeyOf(t);
    if (sk != ProcFilterPill.allKey && sk != status) return false;
    final pk = projectKeyOf(t);
    if (pk != ProcFilterPill.allKey && pk != project) return false;
    final q = searchTextOf(t);
    if (q.isEmpty) return true;
    return hay.any((h) => h.toLowerCase().contains(q));
  }

  List<PurchaseOrder> get filteredOrders => orders
      .where((o) => _passes(ProcTab.orders, o.status.name, o.project,
          [o.number, o.vendor, o.project]))
      .toList();

  List<DeliveryReceipt> get filteredReceipts => receipts
      .where((r) => _passes(ProcTab.receipts, r.status.name, r.project,
          [r.number, r.poNumber, r.vendor, r.notes]))
      .toList();

  List<VendorInvoice> get filteredInvoices => invoices
      .where((i) => _passes(ProcTab.invoices, i.status.name, i.project,
          [i.number, i.poNumber, i.vendor]))
      .toList();

  // ---- delivery schedule --------------------------------------------------
  DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  /// Upcoming deliveries (today onwards) inside the chosen range, soonest first.
  List<DeliveryEvent> get filteredDeliveries {
    final today = _today;
    final limit = scheduleRange == ScheduleRange.thisWeek
        ? today.add(const Duration(days: 7))
        : scheduleRange == ScheduleRange.next30
            ? today.add(const Duration(days: 30))
            : null;
    final list = deliveries.where((d) {
      if (d.date.isBefore(today)) return false;
      return limit == null || !d.date.isAfter(limit);
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  /// Deliveries within 5 days get the orange date badge.
  bool isSoon(DeliveryEvent d) =>
      d.date.difference(_today).inDays <= 5;

  void setScheduleRange(String key) {
    scheduleRange = ScheduleRange.values.firstWhere(
      (r) => r.name == key,
      orElse: () => ScheduleRange.all,
    );
    update();
  }

  // ---- numbering ----------------------------------------------------------
  /// "PO-2026-006": current year, sequence continues from the highest
  /// trailing number already used.
  String _next(String prefix, Iterable<String> numbers) {
    var max = 0;
    for (final n in numbers) {
      final tail = int.tryParse(n.split('-').last) ?? 0;
      if (tail > max) max = tail;
    }
    final year = DateTime.now().year;
    return '$prefix-$year-${(max + 1).toString().padLeft(3, '0')}';
  }

  // ---- purchase orders ----------------------------------------------------
  Future<void> newOrder() async {
    final created = await Get.to<PurchaseOrder>(
      () => NewPurchaseOrderView(
        projects: projects,
        vendors: ProcurementMockData.vendors,
        nextNumber: _next('PO', orders.map((o) => o.number)),
      ),
    );
    if (created == null) return;
    // POST /purchase-orders
    orders.insert(0, created);
    update();
    toast('${created.number} created');
  }

  Future<void> editOrder(PurchaseOrder o) async {
    final updated = await Get.to<PurchaseOrder>(
      () => NewPurchaseOrderView(
        projects: projects,
        vendors: ProcurementMockData.vendors,
        nextNumber: o.number,
        existing: o,
      ),
    );
    if (updated == null) return;
    // PUT /purchase-orders/{id}
    final i = orders.indexWhere((x) => x.id == o.id);
    if (i != -1) orders[i] = updated;
    update();
    toast('${updated.number} updated');
  }

  void toggleOrderBookmark(PurchaseOrder o) {
    final i = orders.indexWhere((x) => x.id == o.id);
    if (i == -1) return;
    orders[i] = o.copyWith(bookmarked: !o.bookmarked);
    update();
  }

  // ---- delivery receipts --------------------------------------------------
  /// POs a receipt can be booked against (not rejected).
  List<PurchaseOrder> get receivableOrders =>
      orders.where((o) => o.status != PoStatus.rejected).toList();

  Future<void> newReceipt() async {
    final created = await Get.to<DeliveryReceipt>(
      () => NewReceiptView(
        orders: receivableOrders,
        inspectors: ProcurementMockData.inspectors,
        nextNumber: _next('DR', receipts.map((r) => r.number)),
      ),
    );
    if (created == null) return;
    // POST /delivery-receipts
    receipts.insert(0, created);
    update();
    toast('${created.number} recorded');
  }

  Future<void> editReceipt(DeliveryReceipt r) async {
    final updated = await Get.to<DeliveryReceipt>(
      () => NewReceiptView(
        orders: receivableOrders,
        inspectors: ProcurementMockData.inspectors,
        nextNumber: r.number,
        existing: r,
      ),
    );
    if (updated == null) return;
    // PUT /delivery-receipts/{id}
    final i = receipts.indexWhere((x) => x.id == r.id);
    if (i != -1) receipts[i] = updated;
    update();
    toast('${updated.number} updated');
  }

  void toggleReceiptBookmark(DeliveryReceipt r) {
    final i = receipts.indexWhere((x) => x.id == r.id);
    if (i == -1) return;
    receipts[i] = r.copyWith(bookmarked: !r.bookmarked);
    update();
  }

  // ---- vendor invoices ----------------------------------------------------
  Future<void> newInvoice() async {
    final created = await Get.to<VendorInvoice>(
      () => NewInvoiceView(
        orders: receivableOrders,
        nextNumber: _next('INV', invoices.map((i) => i.number)),
      ),
    );
    if (created == null) return;
    // POST /vendor-invoices
    invoices.insert(0, created);
    update();
    toast('${created.number} created');
  }

  Future<void> editInvoice(VendorInvoice inv) async {
    final updated = await Get.to<VendorInvoice>(
      () => NewInvoiceView(
        orders: receivableOrders,
        nextNumber: inv.number,
        existing: inv,
      ),
    );
    if (updated == null) return;
    // PUT /vendor-invoices/{id}
    final i = invoices.indexWhere((x) => x.id == inv.id);
    if (i != -1) invoices[i] = updated;
    update();
    toast('${updated.number} updated');
  }

  void toggleInvoiceBookmark(VendorInvoice inv) {
    final i = invoices.indexWhere((x) => x.id == inv.id);
    if (i == -1) return;
    invoices[i] = inv.copyWith(bookmarked: !inv.bookmarked);
    update();
  }
}
