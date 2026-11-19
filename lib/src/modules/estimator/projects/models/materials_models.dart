/// One "Record Materials Usage" entry. Deducted from the matching scope
/// item's material budget.
class MaterialUsageModel {
  final String id;
  final String scopeItemId;
  final String scopeItemName;
  final DateTime date;
  final String description;
  final double quantity;
  final String unit;
  final double unitCost;
  final String? vendor;
  final String? receiptNumber;
  final String? notes;

  const MaterialUsageModel({
    required this.id,
    required this.scopeItemId,
    required this.scopeItemName,
    required this.date,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.unitCost,
    this.vendor,
    this.receiptNumber,
    this.notes,
  });

  double get cost => quantity * unitCost;
}

/// One row of "Material Budget vs Actual".
class MaterialBudgetRow {
  final String scopeItemName;
  final double budget;
  final double actual;

  const MaterialBudgetRow({
    required this.scopeItemName,
    required this.budget,
    required this.actual,
  });

  double get remaining => budget - actual;
  bool get isOver => actual > budget;
  double get fraction => budget <= 0 ? (actual > 0 ? 1 : 0) : (actual / budget).clamp(0.0, 1.0);
}
