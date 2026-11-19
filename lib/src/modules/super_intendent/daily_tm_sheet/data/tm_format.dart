/// Formatting helpers (no `intl` dependency).
class TmFormat {
  TmFormat._();

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static String ordinal(int n) {
    if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }

  /// "August 5th, 2026"
  static String longDate(DateTime d) =>
      '${_months[d.month - 1]} ${ordinal(d.day)}, ${d.year}';

  /// "Oct 28, 2026"
  static String shortDate(DateTime d) =>
      '${_months[d.month - 1].substring(0, 3)} ${d.day}, ${d.year}';
}
