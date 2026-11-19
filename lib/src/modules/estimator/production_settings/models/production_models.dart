import 'package:intl/intl.dart';

enum ProductionTab {
  benchmarks('Benchmarks'),
  costAnalytics('Cost Analytics');

  const ProductionTab(this.label);
  final String label;
}

/// Time-window filter next to the unit filter ("All Time" by default).
enum ProductionTimeRange {
  allTime('All Time', null),
  last30('Last 30 Days', 30),
  last90('Last 90 Days', 90),
  last365('Last 12 Months', 365);

  const ProductionTimeRange(this.label, this.days);
  final String label;
  final int? days;

  bool includes(DateTime date) {
    final d = days;
    if (d == null) return true;
    return date.isAfter(DateTime.now().subtract(Duration(days: d)));
  }
}

/// Data-quality grade shown on the Cost Analytics cards.
enum ProductionConfidence {
  high('High'),
  medium('Medium'),
  low('Low'),
  unknown('Unknown');

  const ProductionConfidence(this.label);
  final String label;
}

/// Average daily production for one scope-of-work type.
class ProductionBenchmarkModel {
  final String id;
  final String scopeName;
  final String unit;
  final double avgDaily;
  final double minDaily;
  final double maxDaily;
  final double totalQty;
  final int days;
  final int projects;

  /// Latest day that fed this benchmark; drives the time filter.
  final DateTime lastRecorded;

  const ProductionBenchmarkModel({
    required this.id,
    required this.scopeName,
    required this.unit,
    required this.avgDaily,
    required this.minDaily,
    required this.maxDaily,
    required this.totalQty,
    required this.days,
    required this.projects,
    required this.lastRecorded,
  });

  String get rangeLabel => '${_qty.format(minDaily)}–${_qty.format(maxDaily)}';
}

/// Cost-per-unit analytics for one scope-of-work type.
class CostAnalyticsModel {
  final String id;
  final String scopeName;
  final String unit;
  final double laborPerUnit;
  final double materialPerUnit;
  final double profitPerUnit;
  final double totalQty;
  final ProductionConfidence confidence;
  final DateTime lastRecorded;

  const CostAnalyticsModel({
    required this.id,
    required this.scopeName,
    required this.unit,
    required this.laborPerUnit,
    required this.materialPerUnit,
    required this.profitPerUnit,
    required this.totalQty,
    required this.confidence,
    required this.lastRecorded,
  });

  bool get isProfitable => profitPerUnit >= 0;
}

final NumberFormat _qty = NumberFormat('#,##0.##');
final NumberFormat _usd = NumberFormat.currency(symbol: '\$');

String formatQty(double v) => _qty.format(v);

String formatMoney(double v) => _usd.format(v);

/// `+$30.80` / `-$114,000.00`.
String formatSignedMoney(double v) =>
    '${v < 0 ? '-' : '+'}${_usd.format(v.abs())}';
