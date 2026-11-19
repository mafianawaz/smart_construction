import 'package:intl/intl.dart';

/// One worker line in a crew: `count × hourly × hours/day × (1 + burden)`.
class CrewWorkerModel {
  final String role;
  final int count;
  final double hourlyRate;

  /// Burden as a percentage of base pay (e.g. 32.5 for 32.5%).
  final double burdenPercent;

  const CrewWorkerModel({
    required this.role,
    required this.count,
    required this.hourlyRate,
    this.burdenPercent = 0,
  });

  double dailyCost(double hoursPerDay) =>
      count * hourlyRate * hoursPerDay * (1 + burdenPercent / 100);
}

/// One equipment line in a crew: `count × (daily + fixed)`.
class CrewEquipmentModel {
  final String name;
  final int count;
  final double dailyRate;
  final double fixedCost;

  const CrewEquipmentModel({
    required this.name,
    required this.count,
    required this.dailyRate,
    this.fixedCost = 0,
  });

  double get dailyCost => count * (dailyRate + fixedCost);
}

/// Reusable crew composition used for estimating.
class CrewTemplateModel {
  final String id;
  final String code;
  final String name;
  final String tradeType;
  final double defaultHoursPerDay;
  final String productionUnit;

  /// Null renders as "Empty", like the form's Production / Day field.
  final double? productionPerDay;
  final String description;
  final bool isActive;
  final List<CrewWorkerModel> workers;
  final List<CrewEquipmentModel> equipment;

  const CrewTemplateModel({
    required this.id,
    required this.code,
    required this.name,
    this.tradeType = '',
    this.defaultHoursPerDay = 8,
    this.productionUnit = '',
    this.productionPerDay,
    this.description = '',
    this.isActive = true,
    this.workers = const [],
    this.equipment = const [],
  });

  double get laborCostPerDay => workers.fold(
        0.0,
        (sum, w) => sum + w.dailyCost(defaultHoursPerDay),
      );

  double get equipmentCostPerDay =>
      equipment.fold(0.0, (sum, e) => sum + e.dailyCost);

  /// Recomputed automatically whenever workers/equipment change.
  double get dailyCost => laborCostPerDay + equipmentCostPerDay;

  /// Daily cost spread over daily production; null without a production rate.
  double? get costPerUnit {
    final p = productionPerDay;
    return (p == null || p <= 0) ? null : dailyCost / p;
  }

  int get headcount => workers.fold(0, (sum, w) => sum + w.count);
}

final NumberFormat _usd = NumberFormat.currency(symbol: '\$');

String formatCrewUsd(double v) => _usd.format(v);
