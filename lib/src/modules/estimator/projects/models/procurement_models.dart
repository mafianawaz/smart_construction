import 'project_enums.dart';

class PurchaseRequestLineItem {
  final String description;
  final double quantity;
  final String unit;
  final double estCost;
  final String? costCode;

  const PurchaseRequestLineItem({
    required this.description,
    this.quantity = 0,
    this.unit = '',
    this.estCost = 0,
    this.costCode,
  });

  /// Est. Cost is read as a per-unit price (placeholder — the reference
  /// doesn't say; flagged in NOTES_ESTIMATING_TABS.md).
  double get total => quantity * estCost;
}

class PurchaseRequestModel {
  final String id;
  final String number;
  final String title;
  final DateTime? neededBy;
  final String? notes;
  final PurchaseRequestStatus status;
  final List<PurchaseRequestLineItem> lineItems;
  final DateTime createdAt;

  const PurchaseRequestModel({
    required this.id,
    required this.number,
    required this.title,
    this.neededBy,
    this.notes,
    this.status = PurchaseRequestStatus.pending,
    this.lineItems = const [],
    required this.createdAt,
  });

  double get total => lineItems.fold(0.0, (sum, l) => sum + l.total);
}

class PurchaseOrderLineItem {
  final String description;
  final double quantity;
  final String unit;
  final double unitCost;
  final String? costCode;
  final DateTime? expectedDelivery;

  const PurchaseOrderLineItem({
    required this.description,
    this.quantity = 0,
    this.unit = '',
    this.unitCost = 0,
    this.costCode,
    this.expectedDelivery,
  });

  double get total => quantity * unitCost;
}

class PurchaseOrderModel {
  final String id;
  final String number;
  final String vendor;
  final DateTime? neededBy;
  final String? terms;
  final String? deliveryAddress;
  final String? notes;
  final PurchaseOrderStatus status;
  final List<PurchaseOrderLineItem> lineItems;
  final DateTime createdAt;

  const PurchaseOrderModel({
    required this.id,
    required this.number,
    required this.vendor,
    this.neededBy,
    this.terms,
    this.deliveryAddress,
    this.notes,
    this.status = PurchaseOrderStatus.draft,
    this.lineItems = const [],
    required this.createdAt,
  });

  double get total => lineItems.fold(0.0, (sum, l) => sum + l.total);
}
