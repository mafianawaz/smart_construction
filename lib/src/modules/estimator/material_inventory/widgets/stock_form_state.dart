import 'package:flutter/material.dart';

import '../models/inventory_models.dart';


/// Sentinel for the "- No PO -" option in the Receive form's PO dropdown.
const String kNoPurchaseOrder = '';

/// Field state for one stock-move form (Receive / Issue / Transfer / Adjust).
/// One instance per form, owned by [MaterialInventoryLogic], so switching
/// tabs never loses what was typed. Unused fields stay empty.
class StockFormState {
  String? materialId;
  String? locationId; // receive / issue / adjust, and "From" on transfer
  String? toLocationId; // transfer only
  String? project; // issue only
  String purchaseOrder = kNoPurchaseOrder; // receive only
  AdjustReason reason = AdjustReason.correction; // adjust only

  final qty = TextEditingController();
  final unitCost = TextEditingController();
  final costCode = TextEditingController();
  final reference = TextEditingController();
  final reasonNote = TextEditingController();
  final notes = TextEditingController();

  /// Field key -> message, e.g. `errors['qty']`.
  final Map<String, String> errors = {};

  double? get qtyValue => double.tryParse(qty.text.trim());
  double get unitCostValue => double.tryParse(unitCost.text.trim()) ?? 0;

  void reset() {
    materialId = null;
    locationId = null;
    toLocationId = null;
    project = null;
    purchaseOrder = kNoPurchaseOrder;
    reason = AdjustReason.correction;
    for (final c in [qty, unitCost, costCode, reference, reasonNote, notes]) {
      c.clear();
    }
    errors.clear();
  }

  void dispose() {
    for (final c in [qty, unitCost, costCode, reference, reasonNote, notes]) {
      c.dispose();
    }
  }
}
