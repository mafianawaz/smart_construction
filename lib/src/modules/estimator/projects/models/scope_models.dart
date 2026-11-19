import 'project_enums.dart';

/// One line of the project's scope of work (Scope & Progress tab).
/// [status] and [progress] are derived from [completedQuantity] so the
/// filter pill and the progress bar can never disagree.
class ScopeItemModel {
  final String id;
  final String name;
  final String unit;
  final double totalQuantity;
  final double? unitPrice;
  final double completedQuantity;

  const ScopeItemModel({
    required this.id,
    required this.name,
    required this.unit,
    required this.totalQuantity,
    this.unitPrice,
    this.completedQuantity = 0,
  });

  double get progress =>
      totalQuantity <= 0 ? 0 : (completedQuantity / totalQuantity).clamp(0.0, 1.0);

  ScopeItemStatus get status {
    if (completedQuantity <= 0) return ScopeItemStatus.notStarted;
    if (totalQuantity > 0 && completedQuantity >= totalQuantity) {
      return ScopeItemStatus.complete;
    }
    return ScopeItemStatus.inProgress;
  }

  /// Material budget for this item — null when no unit price was entered
  /// (the price field is optional on the Create New Scope Items form).
  double? get budget => unitPrice == null ? null : unitPrice! * totalQuantity;
}
