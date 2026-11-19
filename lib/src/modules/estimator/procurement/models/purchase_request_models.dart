import 'package:flutter/material.dart';

enum ProcTab {
  requests('Requests'),
  orders('Orders'),
  receipts('Receipts'),
  invoices('Invoices'),
  deliverySchedule('Delivery Schedule');

  const ProcTab(this.label);
  final String label;
}

enum PurchaseRequestStatus {
  draft('DRAFT', 'Draft'),
  submitted('SUBMITTED', 'Submitted'),
  approved('APPROVED', 'Approved'),
  rejected('REJECTED', 'Rejected'),
  convertedToPo('CONVERTED TO PO', 'Converted to PO');

  const PurchaseRequestStatus(this.badge, this.label);
  final String badge; // text on the card badge
  final String label; // text in the filter menu

  /// Badge text / background colours.
  Color get fg {
    switch (this) {
      case PurchaseRequestStatus.draft:
        return const Color(0xFF6B7280);
      case PurchaseRequestStatus.submitted:
        return const Color(0xFF2563EB);
      case PurchaseRequestStatus.approved:
        return const Color(0xFF16A34A);
      case PurchaseRequestStatus.rejected:
        return const Color(0xFFDC2626);
      case PurchaseRequestStatus.convertedToPo:
        return const Color(0xFFEA580C);
    }
  }

  Color get bg {
    switch (this) {
      case PurchaseRequestStatus.draft:
        return const Color(0xFFF3F4F6);
      case PurchaseRequestStatus.submitted:
        return const Color(0xFFE8F0FE);
      case PurchaseRequestStatus.approved:
        return const Color(0xFFE8F8EF);
      case PurchaseRequestStatus.rejected:
        return const Color(0xFFFDECEC);
      case PurchaseRequestStatus.convertedToPo:
        return const Color(0xFFFFE8D9);
    }
  }
}

class PurchaseLineItem {
  final String description;
  final double qty;
  final String unit;
  final double estUnitCost;
  final String costCode;

  const PurchaseLineItem({
    required this.description,
    required this.qty,
    this.unit = '',
    this.estUnitCost = 0,
    this.costCode = '',
  });

  double get estTotal => qty * estUnitCost;
}

class PurchaseRequest {
  final String id;
  final String number; // PR-0003
  final String project;
  final String title;
  final String notes;
  final DateTime? neededBy;
  final String requestedBy;
  final PurchaseRequestStatus status;
  final List<PurchaseLineItem> items;

  const PurchaseRequest({
    required this.id,
    required this.number,
    required this.project,
    required this.title,
    required this.requestedBy,
    required this.status,
    this.notes = '',
    this.neededBy,
    this.items = const [],
  });

  /// Sum of line totals (0 when there are no priced lines).
  double get estTotal => items.fold(0.0, (s, i) => s + i.estTotal);

  PurchaseRequest copyWith({PurchaseRequestStatus? status}) => PurchaseRequest(
        id: id,
        number: number,
        project: project,
        title: title,
        notes: notes,
        neededBy: neededBy,
        requestedBy: requestedBy,
        status: status ?? this.status,
        items: items,
      );
}

/// "19 May 2026"
String formatProcDate(DateTime d) {
  const m = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${d.day} ${m[d.month - 1]} ${d.year}';
}

/// "$31,000.00"
String formatProcMoney(double v) {
  final fixed = v.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return '\$$whole.${parts[1]}';
}
