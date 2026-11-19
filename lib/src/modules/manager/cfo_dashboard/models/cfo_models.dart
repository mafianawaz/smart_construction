import 'package:intl/intl.dart';

/// Projects block of one organisation.
class CfoProjectStats {
  const CfoProjectStats({
    required this.total,
    required this.active,
    required this.completed,
    required this.planning,
    required this.totalContract,
    required this.activeContract,
  });

  final int total;
  final int active;
  final int completed;
  final int planning;
  final double totalContract;
  final double activeContract;
}

/// Change orders block.
class CfoChangeOrderStats {
  const CfoChangeOrderStats({
    required this.pending,
    required this.approved,
    required this.approvedValue,
  });

  final int pending;
  final int approved;
  final double approvedValue;
}

/// Open bids block.
class CfoBidStats {
  const CfoBidStats({required this.count, required this.pipelineValue});

  final int count;
  final double pipelineValue;
}

/// Accounts receivable block.
class CfoReceivablesStats {
  const CfoReceivablesStats({
    required this.outstanding,
    required this.overdue,
    required this.collectionRate,
    required this.openCoValue,
  });

  final double outstanding;
  final double overdue;

  /// Percentage, 0–100.
  final double collectionRate;
  final double openCoValue;
}

/// One linked organisation's financial overview.
class CfoOrgSummary {
  const CfoOrgSummary({
    required this.id,
    required this.name,
    required this.orgType,
    required this.projects,
    required this.changeOrders,
    required this.bids,
    required this.receivables,
  });

  final String id;
  final String name;

  /// Raw backend value, e.g. 'GENERAL_CONTRACTOR'. Shown as-is (upper case).
  final String orgType;

  final CfoProjectStats projects;
  final CfoChangeOrderStats changeOrders;
  final CfoBidStats bids;
  final CfoReceivablesStats receivables;

  /// 'Hust Concrete Comp' -> 'HC'. First letter of the first two words.
  String get initials {
    final words =
        name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '?';
    final letters = words.take(2).map((w) => w[0]).join();
    return letters.toUpperCase();
  }
}

/// '$83,472,981'
String formatMoney(double v) =>
    NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(v);

/// '1,268'
String formatCount(int v) => NumberFormat('#,##0').format(v);

/// '0.0%', '87.5%'
String formatRate(double v) => '${v.toStringAsFixed(1)}%';
