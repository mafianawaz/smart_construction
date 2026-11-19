import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data/inventory_mock_data.dart';
import 'models/inventory_models.dart';
import 'new_location/view.dart';
import 'new_material/view.dart';
import 'widgets/inv_style.dart';
import 'widgets/stock_form_state.dart';

/// Controller for the Materials Inventory screen.
///
/// Uses plain fields + `update()` (GetBuilder), matching the skeleton's
/// `GetBuilder(init: MaterialInventoryLogic())` and `PricingLogic`.
class MaterialInventoryLogic extends GetxController {
  // ---- data (API seam: see InventoryMockData) -----------------------------
  late List<InventoryMaterial> materials;
  late List<StockLocation> locations;
  late List<StockLevel> stock;
  late List<InventoryTransaction> transactions; // newest first
  late List<DeviceSyncStatus> devices;
  DateTime lastSyncedAt = DateTime.now();

  // ---- ui state -----------------------------------------------------------
  InventoryTab tab = InventoryTab.onHand;

  // barcode lookup
  final lookupCtrl = TextEditingController();
  bool lookupSearched = false;
  InventoryMaterial? lookupMatch;

  // stock-move forms
  final receiveForm = StockFormState();
  final issueForm = StockFormState();
  final transferForm = StockFormState();
  final adjustForm = StockFormState();

  // labels
  final labelSearchCtrl = TextEditingController();
  final copiesCtrl = TextEditingController(text: '1');
  final skipCtrl = TextEditingController(text: '0');
  final Set<String> selectedLabelIds = {};
  LabelTemplate labelTemplate = kLabelTemplates.first;
  LabelSymbology symbology = LabelSymbology.code128;

  // ---- lifecycle ----------------------------------------------------------
  @override
  void onInit() {
    super.onInit();
    // GET /inventory/* — replace with real calls; keep the assignments.
    materials = InventoryMockData.materials();
    locations = InventoryMockData.locations();
    stock = InventoryMockData.stock();
    transactions = InventoryMockData.transactions();
    devices = InventoryMockData.devices();
  }

  @override
  void onClose() {
    lookupCtrl.dispose();
    labelSearchCtrl.dispose();
    copiesCtrl.dispose();
    skipCtrl.dispose();
    receiveForm.dispose();
    issueForm.dispose();
    transferForm.dispose();
    adjustForm.dispose();
    super.onClose();
  }

  // ---- option lists for dropdowns ----------------------------------------
  List<String> get projectOptions => InventoryMockData.projects;
  List<String> get purchaseOrderOptions => InventoryMockData.purchaseOrders;

  // ---- lookups ------------------------------------------------------------
  InventoryMaterial? materialById(String? id) {
    for (final m in materials) {
      if (m.id == id) return m;
    }
    return null;
  }

  StockLocation? locationById(String? id) {
    for (final l in locations) {
      if (l.id == id) return l;
    }
    return null;
  }

  double qtyAt(String materialId, String locationId) {
    for (final s in stock) {
      if (s.materialId == materialId && s.locationId == locationId) {
        return s.qty;
      }
    }
    return 0;
  }

  double totalOnHand(String materialId) => stock
      .where((s) => s.materialId == materialId)
      .fold(0.0, (sum, s) => sum + s.qty);

  // ---- tabs ---------------------------------------------------------------
  void selectTab(InventoryTab t) {
    tab = t;
    update();
  }

  // ---- header actions -----------------------------------------------------
  Future<void> addMaterial() async {
    final created = await Get.to<InventoryMaterial>(
      () => NewMaterialView(
        existingSkus: materials.map((m) => m.sku.toLowerCase()).toSet(),
        existingBarcodes: materials
            .where((m) => m.barcode.isNotEmpty)
            .map((m) => m.barcode.toLowerCase())
            .toSet(),
      ),
    );
    if (created == null) return;
    // POST /inventory/materials
    materials.add(created);
    update();
    _toast('Material ${created.sku} created');
  }

  Future<void> addLocation() async {
    final created = await Get.to<StockLocation>(
      () => NewLocationView(
        existingCodes: locations.map((l) => l.code.toLowerCase()).toSet(),
      ),
    );
    if (created == null) return;
    // POST /inventory/locations
    locations.add(created);
    update();
    _toast('Location ${created.code} created');
  }

  // ---- barcode / QR lookup ------------------------------------------------
  void lookUp() {
    final q = lookupCtrl.text.trim().toLowerCase();
    FocusManager.instance.primaryFocus?.unfocus();
    if (q.isEmpty) {
      clearLookup();
      return;
    }
    InventoryMaterial? match;
    for (final m in materials) {
      if (m.sku.toLowerCase() == q || m.barcode.toLowerCase() == q) {
        match = m;
        break;
      }
    }
    if (match == null) {
      for (final m in materials) {
        if (m.sku.toLowerCase().contains(q) ||
            m.name.toLowerCase().contains(q) ||
            m.barcode.toLowerCase().contains(q)) {
          match = m;
          break;
        }
      }
    }
    lookupMatch = match;
    lookupSearched = true;
    update();
  }

  void clearLookup() {
    lookupMatch = null;
    lookupSearched = false;
    update();
  }

  /// Stub: wire a scanner package here and feed the result to [lookupCtrl].
  void scanBarcode() => _toast('Scanner not connected yet');

  // ---- field sync card ----------------------------------------------------
  void refreshSync() {
    // GET /inventory/devices/sync-status
    lastSyncedAt = DateTime.now();
    update();
  }

  List<InventoryTransaction> get recentTransactions =>
      transactions.take(5).toList();

  List<DeviceSyncStatus> get devicesBehind {
    final now = DateTime.now();
    return devices.where((d) => d.isBehind(now)).toList();
  }

  // ---- derived views ------------------------------------------------------
  /// Non-zero stock rows, sorted by location code then SKU.
  List<StockRow> get stockRows {
    final rows = <StockRow>[];
    for (final s in stock) {
      if (s.qty <= 0) continue;
      final loc = locationById(s.locationId);
      final mat = materialById(s.materialId);
      if (loc == null || mat == null) continue;
      rows.add(StockRow(location: loc, material: mat, qty: s.qty));
    }
    rows.sort((a, b) {
      final c = a.location.code.compareTo(b.location.code);
      return c != 0 ? c : a.material.sku.compareTo(b.material.sku);
    });
    return rows;
  }

  /// SKUs that have been stocked, have a reorder point, and are at or below it.
  List<InventoryMaterial> get lowStock => materials.where((m) {
        if (m.reorderPoint <= 0) return false;
        final stocked = stock.any((s) => s.materialId == m.id);
        return stocked && totalOnHand(m.id) <= m.reorderPoint;
      }).toList();

  /// SKUs with stock and no issues in the last 90 days. The clock starts at
  /// the last issue, or at the first receipt if it was never issued.
  List<InventoryMaterial> get slowMoving {
    final cutoff = DateTime.now().subtract(const Duration(days: 90));
    return materials.where((m) {
      if (totalOnHand(m.id) <= 0) return false;
      final mine = transactions.where((t) => t.materialId == m.id).toList();
      if (mine.isEmpty) return false;
      final issues = mine.where((t) => t.type == InventoryTxnType.issue);
      final DateTime basis = issues.isNotEmpty
          ? issues.map((t) => t.createdAt).reduce((a, b) => a.isAfter(b) ? a : b)
          : mine.map((t) => t.createdAt).reduce((a, b) => a.isBefore(b) ? a : b);
      return basis.isBefore(cutoff);
    }).toList();
  }

  // ---- form change helpers (keep views dumb) ------------------------------
  void setMaterial(StockFormState f, String? v) {
    f.materialId = v;
    f.errors.remove('material');
    update();
  }

  void setLocation(StockFormState f, String? v) {
    f.locationId = v;
    f.errors.remove('location');
    update();
  }

  void setToLocation(StockFormState f, String? v) {
    f.toLocationId = v;
    f.errors.remove('toLocation');
    update();
  }

  void setProject(StockFormState f, String? v) {
    f.project = v;
    f.errors.remove('project');
    update();
  }

  void setPurchaseOrder(StockFormState f, String? v) {
    f.purchaseOrder = v ?? kNoPurchaseOrder;
    update();
  }

  void setReason(StockFormState f, AdjustReason? v) {
    if (v == null) return;
    f.reason = v;
    update();
  }

  void clearError(StockFormState f, String key) {
    if (f.errors.remove(key) != null) update();
  }

  // ---- posting ------------------------------------------------------------
  void postReceive() {
    final f = receiveForm..errors.clear();
    if (f.materialId == null) f.errors['material'] = 'Select a material';
    if (f.locationId == null) f.errors['location'] = 'Select a location';
    final qty = f.qtyValue;
    if (qty == null || qty <= 0) f.errors['qty'] = 'Enter a quantity above 0';
    if (_fail(f)) return;

    _apply(f.materialId!, f.locationId!, qty!);
    _record(InventoryTransaction(
      id: _id('t'),
      type: InventoryTxnType.receive,
      materialId: f.materialId!,
      toLocationId: f.locationId,
      qty: qty,
      unitCost: f.unitCostValue,
      purchaseOrder: f.purchaseOrder,
      reference: f.reference.text.trim(),
      note: f.notes.text.trim(),
      createdAt: DateTime.now(),
    ));
    _done(f, 'Received ${_fmt(qty)} ${materialById(f.materialId)?.uom ?? ''}');
  }

  void postIssue() {
    final f = issueForm..errors.clear();
    if (f.materialId == null) f.errors['material'] = 'Select a material';
    if (f.locationId == null) f.errors['location'] = 'Select a location';
    if (f.project == null) f.errors['project'] = 'Select a project';
    final qty = f.qtyValue;
    if (qty == null || qty <= 0) {
      f.errors['qty'] = 'Enter a quantity above 0';
    } else if (f.materialId != null && f.locationId != null) {
      final have = qtyAt(f.materialId!, f.locationId!);
      if (qty > have) f.errors['qty'] = 'Only ${_fmt(have)} on hand here';
    }
    if (_fail(f)) return;

    _apply(f.materialId!, f.locationId!, -qty!);
    _record(InventoryTransaction(
      id: _id('t'),
      type: InventoryTxnType.issue,
      materialId: f.materialId!,
      fromLocationId: f.locationId,
      qty: qty,
      project: f.project!,
      costCode: f.costCode.text.trim(),
      reference: f.reference.text.trim(),
      note: f.notes.text.trim(),
      createdAt: DateTime.now(),
    ));
    _done(f, 'Issued ${_fmt(qty)} to ${f.project}');
  }

  void postTransfer() {
    final f = transferForm..errors.clear();
    if (f.materialId == null) f.errors['material'] = 'Select a material';
    if (f.locationId == null) f.errors['location'] = 'Select a location';
    if (f.toLocationId == null) {
      f.errors['toLocation'] = 'Select a destination';
    } else if (f.toLocationId == f.locationId) {
      f.errors['toLocation'] = 'Must differ from the source';
    }
    final qty = f.qtyValue;
    if (qty == null || qty <= 0) {
      f.errors['qty'] = 'Enter a quantity above 0';
    } else if (f.materialId != null && f.locationId != null) {
      final have = qtyAt(f.materialId!, f.locationId!);
      if (qty > have) f.errors['qty'] = 'Only ${_fmt(have)} on hand here';
    }
    if (_fail(f)) return;

    _apply(f.materialId!, f.locationId!, -qty!);
    _apply(f.materialId!, f.toLocationId!, qty);
    _record(InventoryTransaction(
      id: _id('t'),
      type: InventoryTxnType.transfer,
      materialId: f.materialId!,
      fromLocationId: f.locationId,
      toLocationId: f.toLocationId,
      qty: qty,
      reference: f.reference.text.trim(),
      note: f.notes.text.trim(),
      createdAt: DateTime.now(),
    ));
    _done(f, 'Transferred ${_fmt(qty)}');
  }

  void postAdjust() {
    final f = adjustForm..errors.clear();
    if (f.materialId == null) f.errors['material'] = 'Select a material';
    if (f.locationId == null) f.errors['location'] = 'Select a location';
    final qty = f.qtyValue;
    if (qty == null || qty == 0) {
      f.errors['qty'] = 'Enter a non-zero quantity (+ add, - remove)';
    } else if (f.materialId != null && f.locationId != null) {
      final have = qtyAt(f.materialId!, f.locationId!);
      if (have + qty < 0) f.errors['qty'] = 'Would drop below 0 (${_fmt(have)} on hand)';
    }
    if (f.reasonNote.text.trim().isEmpty) {
      f.errors['reasonNote'] = 'A reason note is required';
    }
    if (_fail(f)) return;

    _apply(f.materialId!, f.locationId!, qty!);
    _record(InventoryTransaction(
      id: _id('t'),
      type: InventoryTxnType.adjust,
      materialId: f.materialId!,
      fromLocationId: qty < 0 ? f.locationId : null,
      toLocationId: qty > 0 ? f.locationId : null,
      qty: qty,
      reason: f.reason.label,
      reference: f.reference.text.trim(),
      note: f.reasonNote.text.trim(),
      createdAt: DateTime.now(),
    ));
    _done(f, 'Adjusted by ${qty > 0 ? '+' : ''}${_fmt(qty)}');
  }

  // ---- labels -------------------------------------------------------------
  List<InventoryMaterial> get labelMaterials {
    final q = labelSearchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return materials;
    return materials
        .where((m) =>
            m.sku.toLowerCase().contains(q) ||
            m.name.toLowerCase().contains(q) ||
            m.barcode.toLowerCase().contains(q))
        .toList();
  }

  int get copiesPerSku => max(1, int.tryParse(copiesCtrl.text.trim()) ?? 1);
  int get skipFirst => max(0, int.tryParse(skipCtrl.text.trim()) ?? 0);
  int get totalLabels => selectedLabelIds.length * copiesPerSku;
  int get sheetsNeeded => totalLabels == 0
      ? 0
      : ((skipFirst + totalLabels) / labelTemplate.perSheet).ceil();

  void toggleLabel(String id, bool selected) {
    selected ? selectedLabelIds.add(id) : selectedLabelIds.remove(id);
    update();
  }

  /// Selects every shown material, or clears them if all are already selected.
  void selectAllLabels(List<InventoryMaterial> shown) {
    final allSelected = shown.every((m) => selectedLabelIds.contains(m.id));
    for (final m in shown) {
      allSelected ? selectedLabelIds.remove(m.id) : selectedLabelIds.add(m.id);
    }
    update();
  }

  void setLabelTemplate(LabelTemplate? t) {
    if (t == null) return;
    labelTemplate = t;
    update();
  }

  void setSymbology(LabelSymbology? s) {
    if (s == null) return;
    symbology = s;
    update();
  }

  /// Assigns barcodes to selected materials that lack one, then (stub)
  /// renders the sheet. Swap the toast for `pdf` + `printing` output.
  void printLabels() {
    if (selectedLabelIds.isEmpty) {
      _toast('Select at least one material');
      return;
    }
    final used = materials.map((m) => m.barcode.toLowerCase()).toSet();
    for (var i = 0; i < materials.length; i++) {
      final m = materials[i];
      if (selectedLabelIds.contains(m.id) && m.barcode.isEmpty) {
        // PATCH /inventory/materials/{id}
        final code = _newBarcode(used);
        used.add(code.toLowerCase());
        materials[i] = m.copyWith(barcode: code);
      }
    }
    update();
    _toast('$totalLabels labels on $sheetsNeeded sheet(s) ready - PDF output not wired yet');
  }

  // ---- internals ----------------------------------------------------------
  bool _fail(StockFormState f) {
    if (f.errors.isEmpty) return false;
    update();
    return true;
  }

  void _apply(String materialId, String locationId, double delta) {
    for (final s in stock) {
      if (s.materialId == materialId && s.locationId == locationId) {
        s.qty += delta;
        return;
      }
    }
    stock.add(StockLevel(
        materialId: materialId, locationId: locationId, qty: delta));
  }

  void _record(InventoryTransaction t) {
    // POST /inventory/transactions
    transactions.insert(0, t);
  }

  void _done(StockFormState f, String message) {
    f.reset();
    FocusManager.instance.primaryFocus?.unfocus();
    update();
    _toast(message);
  }

  String _id(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';

  String _newBarcode(Set<String> used) {
    final r = Random();
    String code;
    do {
      final letters = String.fromCharCodes(
          List.generate(2, (_) => 97 + r.nextInt(26)));
      code = 'PCM${1000 + r.nextInt(9000)}$letters';
    } while (used.contains(code.toLowerCase()));
    return code;
  }

  static String _fmt(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);

  void _toast(String message) {
    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: InvStyle.successBg,
      colorText: Colors.black87,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }
}
