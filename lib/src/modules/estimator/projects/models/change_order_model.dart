enum ChangeOrderStatus { pending, approved, rejected }

extension ChangeOrderStatusX on ChangeOrderStatus {
  String get label {
    switch (this) {
      case ChangeOrderStatus.pending:
        return 'Pending';
      case ChangeOrderStatus.approved:
        return 'Approved';
      case ChangeOrderStatus.rejected:
        return 'Rejected';
    }
  }
}

class ChangeOrderModel {
  final String id;
  final String title;
  final ChangeOrderStatus status;
  final double amount;

  const ChangeOrderModel({
    required this.id,
    required this.title,
    required this.status,
    required this.amount,
  });
}
