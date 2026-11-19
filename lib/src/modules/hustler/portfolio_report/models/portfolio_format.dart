import 'package:intl/intl.dart';

/// Display formatting shared by both Portfolio Report screens.
class PortfolioFormat {
  PortfolioFormat._();

  static final NumberFormat _grouped = NumberFormat('#,##0');

  /// `$412,500`
  static String money(double v) => '\$${_grouped.format(v.round())}';

  /// `$83.5M`, `$193.0M`, `$0`
  static String moneyCompact(double v) {
    if (v >= 1e9) return '\$${(v / 1e9).toStringAsFixed(1)}B';
    if (v >= 1e6) return '\$${(v / 1e6).toStringAsFixed(1)}M';
    if (v >= 1e3) return '\$${(v / 1e3).toStringAsFixed(1)}K';
    return '\$${v.round()}';
  }

  /// `$192,964K`, `$0K` (benchmark rows).
  static String moneyK(double v) => '\$${_grouped.format((v / 1000).round())}K';

  /// `32.56 projects/emp`
  static String efficiency(double v) => '${v.toStringAsFixed(2)} projects/emp';

  /// `100%`
  static String percent(double v) => '${v.round()}%';

  /// `August 17, 2026`
  static String date(DateTime d) => DateFormat('MMMM d, y').format(d);
}
