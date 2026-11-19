import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/procurement_orders_models.dart';
import '../models/purchase_request_models.dart';
import '../new_request/logic.dart' show LineItemDraft;
import '../widgets/proc_inputs.dart';

/// Create / edit a purchase order. Pops with the resulting [PurchaseOrder].
class NewPurchaseOrderLogic extends GetxController {
  final List<String> projects;
  final List<String> vendors;
  final String nextNumber;
  final PurchaseOrder? existing;

  NewPurchaseOrderLogic({
    required this.projects,
    required this.vendors,
    required this.nextNumber,
    this.existing,
  });

  bool get isEdit => existing != null;

  String? project;
  String? vendor;
  DateTime? neededBy;
  final termsCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final List<LineItemDraft> items = [];
  final Map<String, String> errors = {};

  /// Dropdown options always contain the current value, even if the shared
  /// list no longer does (e.g. a vendor removed after the PO was created).
  List<String> get projectOptions => _withCurrent(projects, project);
  List<String> get vendorOptions => _withCurrent(vendors, vendor);

  List<String> _withCurrent(List<String> base, String? current) =>
      current == null || current.isEmpty || base.contains(current)
          ? base
          : [...base, current];

  @override
  void onInit() {
    super.onInit();
    final e = existing;
    if (e == null) {
      items.add(LineItemDraft());
      return;
    }
    project = e.project;
    vendor = e.vendor == '—' ? null : e.vendor;
    neededBy = e.neededBy;
    termsCtrl.text = e.terms;
    addressCtrl.text = e.deliveryAddress;
    notesCtrl.text = e.notes;
    items.addAll(e.items.map(LineItemDraft.from));
    if (items.isEmpty) items.add(LineItemDraft());
  }

  @override
  void onClose() {
    termsCtrl.dispose();
    addressCtrl.dispose();
    notesCtrl.dispose();
    for (final i in items) {
      i.dispose();
    }
    super.onClose();
  }

  void setProject(String? v) {
    project = v;
    errors.remove('project');
    update();
  }

  void setVendor(String? v) {
    vendor = v;
    update();
  }

  void clearError(String key) {
    if (errors.remove(key) != null) update();
  }

  void clearItemError(LineItemDraft item, String key) {
    if (item.errors.remove(key) != null) update();
  }

  Future<void> pickDate() async {
    final picked = await pickProcDate(neededBy);
    if (picked == null) return;
    neededBy = picked;
    update();
  }

  void addItem() {
    items.add(LineItemDraft());
    update();
  }

  void removeItem(int index) {
    if (items.length == 1) return;
    items.removeAt(index).dispose();
    update();
  }

  double get estimate {
    var total = 0.0;
    for (final i in items) {
      total += (double.tryParse(i.qty.text.trim()) ?? 0) *
          (double.tryParse(i.unitCost.text.trim()) ?? 0);
    }
    return total;
  }

  String get estimateText => formatProcMoney(estimate);

  void submit() {
    errors.clear();
    if (project == null) errors['project'] = 'Select a project';

    final lines = <PurchaseLineItem>[];
    for (final i in items) {
      i.errors.clear();
      if (i.isEmpty) continue;
      final qty = double.tryParse(i.qty.text.trim());
      if (i.description.text.trim().isEmpty) {
        i.errors['description'] = 'Required';
      }
      if (qty == null || qty <= 0) i.errors['qty'] = 'Required';
      if (i.errors.isEmpty) {
        lines.add(PurchaseLineItem(
          description: i.description.text.trim(),
          qty: qty!,
          unit: i.unit.text.trim(),
          estUnitCost: double.tryParse(i.unitCost.text.trim()) ?? 0,
        ));
      }
    }
    final lineErrors = items.any((i) => i.errors.isNotEmpty);
    if (!lineErrors && lines.isEmpty) {
      errors['items'] = 'Add at least one line item';
    }
    if (errors.isNotEmpty || lineErrors) {
      update();
      return;
    }

    final e = existing;
    // POST /purchase-orders (PUT /purchase-orders/{id} when editing).
    // Replace with the real call and pop with the server's version.
    Get.back(
      result: PurchaseOrder(
        id: e?.id ?? 'po-${DateTime.now().microsecondsSinceEpoch}',
        number: nextNumber,
        vendor: vendor ?? '—',
        project: project!,
        status: e?.status ?? PoStatus.pending,
        estimate: lines.fold(0.0, (s, l) => s + l.estTotal),
        neededBy: neededBy,
        terms: termsCtrl.text.trim(),
        deliveryAddress: addressCtrl.text.trim(),
        notes: notesCtrl.text.trim(),
        items: lines,
        bookmarked: e?.bookmarked ?? false,
      ),
    );
  }
}
