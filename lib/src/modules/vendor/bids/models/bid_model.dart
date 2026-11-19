import 'clarification_model.dart';
import 'bid_status.dart';

class BidModel {
  final String id;
  final String organizationName;
  final String title;
  final String scopeOfWork;
  final String additionalDescription;
  final List<String> requiredTrades;
  final BidStatus status;
  final DateTime bidDueDate;
  final DateTime projectStartDate;
  final String location;
  final bool insuranceRequired;
  final List<ClarificationModel> clarifications;

  const BidModel({
    required this.id,
    required this.organizationName,
    required this.title,
    required this.scopeOfWork,
    required this.additionalDescription,
    required this.requiredTrades,
    required this.status,
    required this.bidDueDate,
    required this.projectStartDate,
    required this.location,
    required this.insuranceRequired,
    this.clarifications = const [],
  });

  /// Due date has passed, regardless of status — drives the "Overdue" tag
  /// on the inbox card and the expired banner on the details screen.
  bool get isOverdue => DateTime.now().isAfter(bidDueDate);

  /// A pending bid whose due date has passed can no longer be responded
  /// to. Declined/responded bids are already resolved, so this only gates
  /// the response actions, not the "Overdue" label itself.
  bool get isExpired => isOverdue && status == BidStatus.pending;

  BidModel copyWith({
    BidStatus? status,
    List<ClarificationModel>? clarifications,
  }) {
    return BidModel(
      id: id,
      organizationName: organizationName,
      title: title,
      scopeOfWork: scopeOfWork,
      additionalDescription: additionalDescription,
      requiredTrades: requiredTrades,
      status: status ?? this.status,
      bidDueDate: bidDueDate,
      projectStartDate: projectStartDate,
      location: location,
      insuranceRequired: insuranceRequired,
      clarifications: clarifications ?? this.clarifications,
    );
  }

  // TODO(api): replace with BidModel.fromJson when
  // GET /api/bids and GET /api/bids/{id} are wired up.
}
