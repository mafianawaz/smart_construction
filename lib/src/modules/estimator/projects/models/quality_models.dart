import 'project_enums.dart';

/// One Daily Report entry (Notes & Progress, optionally tied to a scope
/// item for material usage tracking).
class DailyNoteModel {
  final String id;
  final String text;
  final String? materialScopeItem;
  final DateTime createdAt;

  const DailyNoteModel({
    required this.id,
    required this.text,
    this.materialScopeItem,
    required this.createdAt,
  });
}

class InspectionModel {
  final String id;
  final String title;
  final InspectionType type;
  final InspectionStatus status;
  final DateTime scheduledFor;

  const InspectionModel({
    required this.id,
    required this.title,
    required this.type,
    this.status = InspectionStatus.pending,
    required this.scheduledFor,
  });
}

class MaterialTestModel {
  final String id;
  final String title;
  final MaterialTestType type;
  final MaterialTestStatus status;
  final DateTime date;

  const MaterialTestModel({
    required this.id,
    required this.title,
    required this.type,
    this.status = MaterialTestStatus.pending,
    required this.date,
  });
}

/// A row on Production Rate Benchmarks (average daily production per scope
/// of work). Only the empty state is in the reference, so the fields are
/// a guess.
class ProductionBenchmarkModel {
  final String scopeName;
  final String unit;
  final double avgDailyQuantity;
  final int daysRecorded;

  const ProductionBenchmarkModel({
    required this.scopeName,
    required this.unit,
    required this.avgDailyQuantity,
    required this.daysRecorded,
  });
}

/// A row on Cost Per Unit Analytics (labor + material cost per unit and
/// profitability). Guessed fields, same reason as above.
class CostPerUnitModel {
  final String scopeName;
  final String unit;
  final double laborCostPerUnit;
  final double materialCostPerUnit;
  final double? unitPrice;

  const CostPerUnitModel({
    required this.scopeName,
    required this.unit,
    required this.laborCostPerUnit,
    required this.materialCostPerUnit,
    this.unitPrice,
  });

  double get costPerUnit => laborCostPerUnit + materialCostPerUnit;
  double? get marginPerUnit => unitPrice == null ? null : unitPrice! - costPerUnit;
}
