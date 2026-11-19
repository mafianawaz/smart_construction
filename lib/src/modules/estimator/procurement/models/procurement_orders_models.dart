import 'package:flutter/material.dart';

import 'purchase_request_models.dart';

const Color _kGreen = Color(0xFF16A34A);
const Color _kGreenBg = Color(0xFFE8F8EF);
const Color _kOrange = Color(0xFFEA580C);
const Color _kOrangeBg = Color(0xFFFFE8D9);
const Color _kRed = Color(0xFFDC2626);
const Color _kRedBg = Color(0xFFFDECEC);
const Color _kGrey = Color(0xFF6B7280);
const Color _kGreyBg = Color(0xFFF3F4F6);

// ---- Purchase orders --------------------------------------------------------

enum PoStatus {
  approved('APPROVED', 'Approved', _kGreen, _kGreenBg),
  pending('PENDING', 'Pending', _kOrange, _kOrangeBg),
  rejected('REJECTED', 'Rejected', _kRed, _kRedBg);

  const PoStatus(this.badge, this.label, this.fg, this.bg);
  final String badge;
  final String label;
  final Color fg;
  final Color bg;
}

class PurchaseOrder {
  final String id;
  final String number; // PO-2024-001
  final String vendor;
  final String project;
  final PoStatus status;
  final double estimate;
  final DateTime? neededBy;
  final String terms;
  final String deliveryAddress;
  final String notes;
  final List<PurchaseLineItem> items;
  final bool bookmarked;

  const PurchaseOrder({
    required this.id,
    required this.number,
    required this.vendor,
    required this.project,
    required this.status,
    required this.estimate,
    this.neededBy,
    this.terms = '',
    this.deliveryAddress = '',
    this.notes = '',
    this.items = const [],
    this.bookmarked = false,
  });

  PurchaseOrder copyWith({bool? bookmarked}) => PurchaseOrder(
        id: id,
        number: number,
        vendor: vendor,
        project: project,
        status: status,
        estimate: estimate,
        neededBy: neededBy,
        terms: terms,
        deliveryAddress: deliveryAddress,
        notes: notes,
        items: items,
        bookmarked: bookmarked ?? this.bookmarked,
      );
}

// ---- Delivery receipts ------------------------------------------------------

enum ReceiptStatus {
  received('RECEIVED', 'Received', _kGreen, _kGreenBg),
  partial('PARTIAL', 'Partial', _kOrange, _kOrangeBg);

  const ReceiptStatus(this.badge, this.label, this.fg, this.bg);
  final String badge;
  final String label;
  final Color fg;
  final Color bg;
}

class DeliveryReceipt {
  final String id;
  final String number; // DR-2024-001
  final String poNumber;
  final String vendor;
  final String project;
  final ReceiptStatus status;
  final DateTime receivedOn;
  final int itemsReceived;
  final int itemsExpected; // 0 = unknown / same as received
  final String inspectedBy;
  final String notes;
  final bool bookmarked;

  const DeliveryReceipt({
    required this.id,
    required this.number,
    required this.poNumber,
    required this.vendor,
    required this.project,
    required this.status,
    required this.receivedOn,
    required this.itemsReceived,
    this.itemsExpected = 0,
    this.inspectedBy = '',
    this.notes = '',
    this.bookmarked = false,
  });

  DeliveryReceipt copyWith({bool? bookmarked}) => DeliveryReceipt(
        id: id,
        number: number,
        poNumber: poNumber,
        vendor: vendor,
        project: project,
        status: status,
        receivedOn: receivedOn,
        itemsReceived: itemsReceived,
        itemsExpected: itemsExpected,
        inspectedBy: inspectedBy,
        notes: notes,
        bookmarked: bookmarked ?? this.bookmarked,
      );
}

// ---- Vendor invoices --------------------------------------------------------

enum InvoiceStatus {
  paid('PAID', 'Paid', _kGreen, _kGreenBg),
  overdue('OVERDUE', 'Overdue', _kRed, _kRedBg),
  pending('PENDING', 'Pending', _kGrey, _kGreyBg);

  const InvoiceStatus(this.badge, this.label, this.fg, this.bg);
  final String badge;
  final String label;
  final Color fg;
  final Color bg;
}

class VendorInvoice {
  final String id;
  final String number; // INV-2024-001
  final String poNumber;
  final String vendor;
  final String project;
  final InvoiceStatus status;
  final double amount;
  final DateTime? dueDate;
  final DateTime? paidDate;
  final String notes;
  final bool bookmarked;

  const VendorInvoice({
    required this.id,
    required this.number,
    required this.poNumber,
    required this.vendor,
    required this.project,
    required this.status,
    required this.amount,
    this.dueDate,
    this.paidDate,
    this.notes = '',
    this.bookmarked = false,
  });

  VendorInvoice copyWith({bool? bookmarked}) => VendorInvoice(
        id: id,
        number: number,
        poNumber: poNumber,
        vendor: vendor,
        project: project,
        status: status,
        amount: amount,
        dueDate: dueDate,
        paidDate: paidDate,
        notes: notes,
        bookmarked: bookmarked ?? this.bookmarked,
      );
}

// ---- Delivery schedule ------------------------------------------------------

class DeliveryEvent {
  final String id;
  final DateTime date;
  final String title;
  final String poNumber;
  final String vendor;
  final String project;
  final String itemsLabel; // "12 items", "20 bags"

  const DeliveryEvent({
    required this.id,
    required this.date,
    required this.title,
    required this.poNumber,
    required this.vendor,
    required this.project,
    required this.itemsLabel,
  });
}

enum ScheduleRange {
  all('All Upcoming'),
  thisWeek('This Week'),
  next30('Next 30 Days');

  const ScheduleRange(this.label);
  final String label;
}

/// "Aug 02, 2024"
String formatShortDate(DateTime d) {
  const m = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${m[d.month - 1]} ${d.day.toString().padLeft(2, '0')}, ${d.year}';
}

/// "AUG 08"
String formatBadgeDate(DateTime d) {
  const m = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];
  return '${m[d.month - 1]} ${d.day.toString().padLeft(2, '0')}';
}
