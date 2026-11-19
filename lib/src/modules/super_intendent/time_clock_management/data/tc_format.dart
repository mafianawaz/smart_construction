/// Formatting helpers for Time Clock Management (no `intl` dependency).
class TcFormat {
  TcFormat._();

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String two(int n) => n.toString().padLeft(2, '0');

  /// "May 21, 2026"
  static String date(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

  /// "17:58"
  static String time24(DateTime d) => '${two(d.hour)}:${two(d.minute)}';

  /// "7:20 PM"
  static String time12(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final p = d.hour >= 12 ? 'PM' : 'AM';
    return '$h:${two(d.minute)} $p';
  }

  /// "3066h 45m"
  static String hm(Duration d) => '${d.inHours}h ${d.inMinutes.remainder(60)}m';

  /// "0h 0m" style used by the Duration row.
  static String durationLabel(Duration d) => hm(d);

  /// "8.00h"
  static String hours(double h) => '${h.toStringAsFixed(2)}h';

  /// "+20.0h"
  static String overtime(double h) => '+${h.toStringAsFixed(1)}h';

  /// "4 months ago", "3 days ago", "just now".
  static String ago(DateTime d, [DateTime? now]) {
    final diff = (now ?? DateTime.now()).difference(d);
    if (diff.inDays >= 365) {
      final y = diff.inDays ~/ 365;
      return '$y ${y == 1 ? 'year' : 'years'} ago';
    }
    if (diff.inDays >= 30) {
      final m = diff.inDays ~/ 30;
      return '$m ${m == 1 ? 'month' : 'months'} ago';
    }
    if (diff.inDays >= 1) {
      return '${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'} ago';
    }
    if (diff.inHours >= 1) {
      return '${diff.inHours} ${diff.inHours == 1 ? 'hour' : 'hours'} ago';
    }
    if (diff.inMinutes >= 1) return '${diff.inMinutes} min ago';
    return 'just now';
  }
}
