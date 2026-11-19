import 'package:intl/intl.dart';

/// "$47,800" (decimals: 0) or "$965,311.35" (decimals: 2).
String cfoMoney(num value, {int decimals = 0}) =>
    NumberFormat.currency(symbol: r'$', decimalDigits: decimals).format(value);

/// "Jan 25"
String cfoShortDate(DateTime d) => DateFormat('MMM d').format(d);

/// "Aug 5, 2026"
String cfoLongDate(DateTime d) => DateFormat('MMM d, yyyy').format(d);

/// "2026-08-05" — used in CSV exports.
String cfoIsoDate(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

/// Whole calendar days from [from] to [to] (date part only).
int cfoDaysBetween(DateTime from, DateTime to) {
  final a = DateTime(from.year, from.month, from.day);
  final b = DateTime(to.year, to.month, to.day);
  return b.difference(a).inDays;
}
