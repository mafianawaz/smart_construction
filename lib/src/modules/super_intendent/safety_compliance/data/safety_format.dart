/// Small formatting helpers (no `intl` dependency needed here).
class SafetyFormat {
  SafetyFormat._();

  /// 200000 -> "200,000"
  static String count(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  /// 0 -> "0", 1.0389 -> "1.04"
  static String rate(double v) => v == 0 ? '0' : v.toStringAsFixed(2);

  /// 2026-08-04 -> "8/4/2026"
  static String date(DateTime d) => '${d.month}/${d.day}/${d.year}';
}
