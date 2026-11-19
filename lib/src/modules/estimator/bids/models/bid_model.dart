import 'package:intl/intl.dart';
import 'clarification_model.dart';

enum BidStatus { draft, active, awarded, expired }

extension BidStatusX on BidStatus {
  String get label {
    switch (this) {
      case BidStatus.draft:
        return 'Draft';
      case BidStatus.active:
        return 'Active';
      case BidStatus.awarded:
        return 'Awarded';
      case BidStatus.expired:
        return 'Expired';
    }
  }
}

/// One bid, used by the Bid Board cards, the Bid Inbox cards and the
/// Bid Details screen.
class BidModel {
  final String id;
  final String number;
  final String title;
  final String clientName;
  final BidStatus status;
  final double? amount;
  final DateTime? dueDate;
  final DateTime? projectStart;
  final String? location;
  final String ownerLabel;
  final String scopeOfWork;
  final String additionalDescription;
  final List<String> requiredTrades;
  final List<ClarificationModel> clarifications;

  const BidModel({
    required this.id,
    required this.number,
    required this.title,
    required this.clientName,
    required this.status,
    this.amount,
    this.dueDate,
    this.projectStart,
    this.location,
    this.ownerLabel = 'Organization Admin',
    this.scopeOfWork = '',
    this.additionalDescription = '',
    this.requiredTrades = const [],
    this.clarifications = const [],
  });

  bool get isExpired => status == BidStatus.expired;

  bool get isPastDue =>
      dueDate != null && dueDate!.isBefore(DateTime.now());

  String get amountLabel => amount == null
      ? 'TBD'
      : NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(amount);

  String get dueDateLabel =>
      dueDate == null ? '-' : DateFormat('MMM d, y').format(dueDate!);

  String get dueDateLongLabel => dueDate == null
      ? '-'
      : DateFormat("MMMM d, y 'at' h:mm a").format(dueDate!);

  String get projectStartLabel => projectStart == null
      ? '-'
      : DateFormat('MMMM d, y').format(projectStart!);

  String get locationLabel =>
      (location == null || location!.trim().isEmpty) ? '-' : location!;

  bool matchesQuery(String q) {
    if (q.isEmpty) return true;
    return title.toLowerCase().contains(q) ||
        clientName.toLowerCase().contains(q) ||
        number.toLowerCase().contains(q);
  }
}
