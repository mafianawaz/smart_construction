/// Small formatting helpers (no `intl` needed).
class EquipmentFormat {
  EquipmentFormat._();

  /// 160000 -> "$160k", 1250000 -> "$1.3M", 950 -> "$950"
  static String compactMoney(double v) {
    if (v >= 1000000) return '\$${_trim(v / 1000000)}M';
    if (v >= 1000) return '\$${_trim(v / 1000)}k';
    return '\$${v.toStringAsFixed(0)}';
  }

  static String _trim(double x) {
    final s = x.toStringAsFixed(1);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  }

  /// 1000 -> "1000.0 hrs"
  static String hours(double h) => '${h.toStringAsFixed(1)} hrs';

  /// mm/dd/yyyy
  static String date(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '$mm/$dd/${d.year}';
  }

  /// Lenient number parse: "$1,250.50" -> 1250.5, blank/invalid -> 0.
  static double parseNumber(String s) =>
      double.tryParse(s.replaceAll(',', '').replaceAll('\$', '').trim()) ?? 0;
}
