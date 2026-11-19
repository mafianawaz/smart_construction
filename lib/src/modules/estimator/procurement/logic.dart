import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data/procurement_mock_data.dart';
import 'models/procurement_orders_models.dart';
import 'models/purchase_request_models.dart';
import 'new_request/view.dart';
import 'widgets/proc_list_widgets.dart';

/// Controller for the Procurement screen (GetBuilder + update()).
class ProcurementLogic extends GetxController {
  late List<PurchaseRequest> requests; // newest first
  late List<PurchaseOrder> orders; // newest first
  late List<DeliveryReceipt> receipts;
  late List<VendorInvoice> invoices;
  late List<DeliveryEvent> deliveries;

  /// Search / filter state for the Orders, Receipts and Invoices tabs.
  final Map<ProcTab, TextEditingController> searchByTab = {
    ProcTab.orders: TextEditingController(),
    ProcTab.receipts: TextEditingController(),
    ProcTab.invoices: TextEditingController(),
  };
  final Map<ProcTab, String> statusByTab = {};
  final Map<ProcTab, String> projectByTab = {};
  ScheduleRange scheduleRange = ScheduleRange.all;

  ProcTab tab = ProcTab.requests;
  final searchCtrl = TextEditingController();

  /// [ProcFilterPill.allKey], or a [PurchaseRequestStatus] name.
  String statusFilter = ProcFilterPill.allKey;

  /// [ProcFilterPill.allKey], or a project name.
  String projectFilter = ProcFilterPill.allKey;

  @override
  void onInit() {
    super.onInit();
    requests = ProcurementMockData.requests(); // GET /purchase-requests
    orders = ProcurementMockData.orders(); // GET /purchase-orders
    receipts = ProcurementMockData.receipts(); // GET /delivery-receipts
    invoices = ProcurementMockData.invoices(); // GET /vendor-invoices
    deliveries = ProcurementMockData.deliveries(); // GET /deliveries
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    for (final c in searchByTab.values) {
      c.dispose();
    }
    super.onClose();
  }

  List<String> get projects => ProcurementMockData.projects;

  // ---- filter menus -------------------------------------------------------
  Map<String, String> get statusOptions => {
        ProcFilterPill.allKey: 'All Status',
        for (final s in PurchaseRequestStatus.values) s.name: s.label,
      };

  Map<String, String> get projectOptions => {
        ProcFilterPill.allKey: 'All Projects',
        for (final p in projects) p: p,
      };

  bool get statusActive => statusFilter != ProcFilterPill.allKey;
  bool get projectActive => projectFilter != ProcFilterPill.allKey;

  String get statusLabel => statusOptions[statusFilter] ?? 'All Status';
  String get projectLabel => projectActive ? projectFilter : 'All Projects';

  void selectTab(ProcTab t) {
    tab = t;
    update();
  }

  void setStatusFilter(String key) {
    statusFilter = key;
    update();
  }

  void setProjectFilter(String key) {
    projectFilter = key;
    update();
  }

  /// Rebuild on each keystroke so the list filters live.
  void onSearchChanged(String _) => update();

  List<PurchaseRequest> get filtered {
    final q = searchCtrl.text.trim().toLowerCase();
    return requests.where((r) {
      if (statusActive && r.status.name != statusFilter) return false;
      if (projectActive && r.project != projectFilter) return false;
      if (q.isEmpty) return true;
      return r.title.toLowerCase().contains(q) ||
          r.number.toLowerCase().contains(q) ||
          r.project.toLowerCase().contains(q);
    }).toList();
  }

  bool get hasActiveFilters =>
      statusActive || projectActive || searchCtrl.text.trim().isNotEmpty;

  void clearFilters() {
    statusFilter = ProcFilterPill.allKey;
    projectFilter = ProcFilterPill.allKey;
    searchCtrl.clear();
    update();
  }

  // ---- actions ------------------------------------------------------------
  String get _nextNumber {
    var max = 0;
    for (final r in requests) {
      final n = int.tryParse(r.number.replaceAll(RegExp(r'\D'), '')) ?? 0;
      if (n > max) max = n;
    }
    return 'PR-${(max + 1).toString().padLeft(4, '0')}';
  }

  Future<void> newRequest() async {
    final created = await Get.to<PurchaseRequest>(
      () => NewRequestView(projects: projects, nextNumber: _nextNumber),
    );
    if (created == null) return;
    // POST /purchase-requests
    requests.insert(0, created);
    update();
    toast('${created.number} created as draft');
  }

  Future<void> editRequest(PurchaseRequest r) async {
    final updated = await Get.to<PurchaseRequest>(
      () => NewRequestView(
        projects: projects,
        nextNumber: r.number,
        existing: r,
      ),
    );
    if (updated == null) return;
    // PUT /purchase-requests/{id}
    final i = requests.indexWhere((x) => x.id == r.id);
    if (i != -1) requests[i] = updated;
    update();
    toast('${updated.number} updated');
  }

  void submitRequest(PurchaseRequest r) {
    if (r.items.isEmpty) {
      toast('Add at least one line item before submitting');
      return;
    }
    // POST /purchase-requests/{id}/submit
    final i = requests.indexWhere((x) => x.id == r.id);
    if (i == -1) return;
    requests[i] = r.copyWith(status: PurchaseRequestStatus.submitted);
    update();
    toast('${r.number} submitted for approval');
  }

  Future<void> deleteRequest(PurchaseRequest r) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete request?'),
        content: Text('${r.number} "${r.title}" will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    // DELETE /purchase-requests/{id}
    requests.removeWhere((x) => x.id == r.id);
    update();
    toast('${r.number} deleted');
  }

  void toast(String message) {
    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }
}
