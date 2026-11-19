/// Small date-formatting helpers (no `intl` needed).
class DispatchFormat {
  DispatchFormat._();

  static const List<String> _weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String weekdayShort(DateTime d) => _weekdays[d.weekday - 1].substring(0, 3);

  static String monthShort(DateTime d) => _months[d.month - 1];

  /// Thursday, Aug 6, 2026
  static String longDate(DateTime d) =>
      '${_weekdays[d.weekday - 1]}, ${monthShort(d)} ${d.day}, ${d.year}';

  /// Thu, Aug 6
  static String shortDate(DateTime d) =>
      '${weekdayShort(d)}, ${monthShort(d)} ${d.day}';

  /// Aug 3 - Aug 7   (months repeated only when they differ)
  static String range(DateTime a, DateTime b) {
    final left = '${monthShort(a)} ${a.day}';
    final right = a.month == b.month ? '${b.day}' : '${monthShort(b)} ${b.day}';
    return '$left – $right';
  }
}
