/// One actual-cost line item captured from a completed project.
class CostRecordModel {
  final String id;
  final String description;
  final String scopeCategory;
  final String trade;
  final String costCode;
  final DateTime completedDate;
  final double quantity;
  final String unit;
  final double unitCost;
  final String projectName;
  final String projectType;
  final double material;
  final double labor;
  final double equipment;
  final double subcontract;

  const CostRecordModel({
    required this.id,
    required this.description,
    required this.scopeCategory,
    required this.trade,
    required this.costCode,
    required this.completedDate,
    required this.quantity,
    required this.unit,
    required this.unitCost,
    this.projectName = '',
    this.projectType = '',
    this.material = 0,
    this.labor = 0,
    this.equipment = 0,
    this.subcontract = 0,
  });

  /// Quantity x unit cost (see NOTES_HISTORICAL_COST.md re: reference mismatch).
  double get totalCost => quantity * unitCost;

  double get breakdownTotal => material + labor + equipment + subcontract;
}

/// Aggregated unit costs for one Scope + Trade + Cost Code combination
/// (the cards on the "Summary" tab).
class CostSummaryGroup {
  final String scopeCategory;
  final String trade;
  final String costCode;
  final double avgUnitCost;
  final double minUnitCost;
  final double maxUnitCost;
  final double totalQty;
  final String unit;
  final double totalCost;
  final int recordCount;
  final DateTime firstDate;
  final DateTime lastDate;

  const CostSummaryGroup({
    required this.scopeCategory,
    required this.trade,
    required this.costCode,
    required this.avgUnitCost,
    required this.minUnitCost,
    required this.maxUnitCost,
    required this.totalQty,
    required this.unit,
    required this.totalCost,
    required this.recordCount,
    required this.firstDate,
    required this.lastDate,
  });

  static List<CostSummaryGroup> fromRecords(List<CostRecordModel> records) {
    final buckets = <String, List<CostRecordModel>>{};
    for (final r in records) {
      buckets
          .putIfAbsent('${r.scopeCategory}|${r.trade}|${r.costCode}', () => [])
          .add(r);
    }
    return buckets.values.map((list) {
      final costs = list.map((r) => r.unitCost).toList();
      final dates = list.map((r) => r.completedDate).toList()..sort();
      return CostSummaryGroup(
        scopeCategory: list.first.scopeCategory,
        trade: list.first.trade,
        costCode: list.first.costCode,
        avgUnitCost: costs.reduce((a, b) => a + b) / costs.length,
        minUnitCost: costs.reduce((a, b) => a < b ? a : b),
        maxUnitCost: costs.reduce((a, b) => a > b ? a : b),
        totalQty: list.fold(0.0, (s, r) => s + r.quantity),
        unit: list.first.unit,
        totalCost: list.fold(0.0, (s, r) => s + r.totalCost),
        recordCount: list.length,
        firstDate: dates.first,
        lastDate: dates.last,
      );
    }).toList();
  }
}
