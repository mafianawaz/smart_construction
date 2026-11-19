import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/purchase_request_models.dart';

/// Editable state for one line-item card.
class LineItemDraft {
  final description = TextEditingController();
  final qty = TextEditingController();
  final unit = TextEditingController();
  final unitCost = TextEditingController();
  final costCode = TextEditingController();
  final Map<String, String> errors = {};

  LineItemDraft();

  LineItemDraft.from(PurchaseLineItem i) {
    description.text = i.description;
    qty.text = _num(i.qty);
    unit.text = i.unit;
    unitCost.text = i.estUnitCost == 0 ? '' : _num(i.estUnitCost);
    costCode.text = i.costCode;
  }

  static String _num(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  bool get isEmpty =>
      description.text.trim().isEmpty &&
      qty.text.trim().isEmpty &&
      unit.text.trim().isEmpty &&
      unitCost.text.trim().isEmpty &&
      costCode.text.trim().isEmpty;

  void dispose() {
    for (final c in [description, qty, unit, unitCost, costCode]) {
      c.dispose();
    }
  }
}

/// Create / edit a purchase request. Pops with the resulting [PurchaseRequest].
class NewRequestLogic extends GetxController {
  final List<String> projects;
  final String nextNumber;
  final PurchaseRequest? existing;

  NewRequestLogic({
    required this.projects,
    required this.nextNumber,
    this.existing,
  });

  bool get isEdit => existing != null;

  String? project;
  DateTime? neededBy;
  final titleCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final List<LineItemDraft> items = [];
  final Map<String, String> errors = {};

  @override
  void onInit() {
    super.onInit();
    final e = existing;
    if (e == null) {
      items.add(LineItemDraft());
    } else {
      project = e.project;
      neededBy = e.neededBy;
      titleCtrl.text = e.title;
      notesCtrl.text = e.notes;
      items.addAll(e.items.map(LineItemDraft.from));
      if (items.isEmpty) items.add(LineItemDraft());
    }
  }

  @override
  void onClose() {
    titleCtrl.dispose();
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

  void clearError(String key) {
    if (errors.remove(key) != null) update();
  }

  Future<void> pickDate() async {
    final ctx = Get.context;
    if (ctx == null) return;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: ctx,
      initialDate: neededBy ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
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

  void clearItemError(LineItemDraft item, String key) {
    if (item.errors.remove(key) != null) update();
  }

  String get estimatedTotalText {
    var total = 0.0;
    for (final i in items) {
      total += (double.tryParse(i.qty.text.trim()) ?? 0) *
          (double.tryParse(i.unitCost.text.trim()) ?? 0);
    }
    return formatProcMoney(total);
  }

  void submit() {
    errors.clear();
    if (project == null) errors['project'] = 'Select a project';
    if (titleCtrl.text.trim().isEmpty) errors['title'] = 'Title is required';

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
          costCode: i.costCode.text.trim(),
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
    // POST /purchase-requests (or PUT /purchase-requests/{id} when editing).
    // Replace with the real call and pop with the server's version.
    Get.back(
      result: PurchaseRequest(
        id: e?.id ?? 'pr-${DateTime.now().microsecondsSinceEpoch}',
        number: nextNumber,
        project: project!,
        title: titleCtrl.text.trim(),
        notes: notesCtrl.text.trim(),
        neededBy: neededBy,
        requestedBy: e?.requestedBy ?? 'Test ADMIN', // TODO: current user
        status: e?.status ?? PurchaseRequestStatus.draft,
        items: lines,
      ),
    );
  }
}
