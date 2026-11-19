import 'package:intl/intl.dart';

import 'rollup_enums.dart';

/// One project row as the rollup needs it. A single model feeds all three
/// views so the shared filters (PM / dates / min health) apply to each.
class RollupProject {
  const RollupProject({
    required this.code,
    required this.name,
    required this.status,
    required this.health,
    required this.spi,
    required this.cpi,
    this.pm,
    this.openRfis = 0,
    this.openCos = 0,
    this.punch = 0,
    this.contract = 0,
    this.actual = 0,
    this.start,
    this.end,
  });

  /// Display id: '260389' (shown as '#260389' on the financial card) or
  /// 'DS-001' on the Gantt rows.
  final String code;
  final String name;
  final RollupStatus status;
  final String? pm;

  /// 0–100.
  final double health;

  /// Schedule / cost performance indices (1.0 = on plan).
  final double spi;
  final double cpi;

  final int openRfis;
  final int openCos;
  final int punch;

  final double contract;
  final double actual;
  final DateTime? start;
  final DateTime? end;

  /// Budget variance as shown on the Financial Rollup card:
  /// (contract − actual) / contract. Positive = under budget (green).
  /// Contract of 0 reads as 0%.
  double get variancePct =>
      contract <= 0 ? 0 : (contract - actual) / contract * 100;
}

/// '1', '1.5', '2.45' — up to two decimals, trailing zeros trimmed.
String formatRatio(double v) {
  final s = v.toStringAsFixed(2);
  if (!s.contains('.')) return s;
  return s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
}

/// '99.8', '100' — one decimal, '.0' trimmed.
String formatHealth(double v) {
  final s = v.toStringAsFixed(1);
  return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
}

/// '\$2,451'
String formatMoney(double v) =>
    NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(v);

/// '59.2%', '0%', '-12.5%'
String formatPct(double v) => '${formatHealth(v)}%';
