import 'package:intl/intl.dart';

final NumberFormat _money = NumberFormat.currency(symbol: '\$');

/// "$1,250.00" — shared by the estimating tabs.
String projectMoney(num value) => _money.format(value);

/// "12" or "12.5" — quantities without trailing ".0".
String projectNumber(double value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
}

/// "12%" or "12.5%".
String projectPercent(double value) => '${projectNumber(value)}%';
