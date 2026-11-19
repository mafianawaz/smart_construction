import '../models/procurement_orders_models.dart';
import '../models/purchase_request_models.dart';

/// Mock-data seam for Procurement. Replace each method with the HTTP call
/// in its comment; keep the return types.
class ProcurementMockData {
  // GET /purchase-requests
  static List<PurchaseRequest> requests() => [
        PurchaseRequest(
          id: 'pr-3',
          number: 'PR-0003',
          project: "Maker's House",
          title: 'test',
          requestedBy: 'Test ADMIN',
          status: PurchaseRequestStatus.draft,
          neededBy: DateTime(2026, 5, 19),
        ),
        PurchaseRequest(
          id: 'pr-2',
          number: 'PR-0002',
          project: 'Gettysburg Fire Station 305',
          title: 'Cement',
          requestedBy: 'Test ADMIN',
          status: PurchaseRequestStatus.convertedToPo,
          neededBy: DateTime(2026, 4, 17),
          items: const [
            PurchaseLineItem(
              description: 'Cement',
              qty: 1000,
              unit: 'bag',
              estUnitCost: 31,
              costCode: '03-300',
            ),
          ],
        ),
      ];

  // GET /projects?status=active
  static const List<String> projects = [
    "Maker's House",
    'Gettysburg Fire Station 305',
    'Riverside Tower',
    'Downtown Office',
    'Harbor Bridge',
    'Mall Renovation',
    'Residential Complex',
  ];

  // GET /cost-codes
  static const List<String> costCodes = [
    '03-300 Cast-in-place concrete',
    '04-200 Unit masonry',
    '05-120 Structural steel',
    '06-100 Rough carpentry',
  ];

  // GET /vendors
  static const List<String> vendors = [
    'ABC Lumber Supply',
    'Steel Works Inc',
    'Concrete Solutions',
    'PlumbTech',
    'ElectroPro',
  ];

  static const List<String> inspectors = [
    'John Smith',
    'Mike Davis',
    'Sarah Lee',
  ];

  // GET /purchase-orders
  static List<PurchaseOrder> orders() => const [
        PurchaseOrder(
          id: 'po-1',
          number: 'PO-2024-001',
          vendor: 'ABC Lumber Supply',
          project: 'Downtown Office',
          status: PoStatus.approved,
          estimate: 4250,
        ),
        PurchaseOrder(
          id: 'po-2',
          number: 'PO-2024-002',
          vendor: 'Steel Works Inc',
          project: 'Harbor Bridge',
          status: PoStatus.pending,
          estimate: 3800,
        ),
        PurchaseOrder(
          id: 'po-3',
          number: 'PO-2024-003',
          vendor: 'Concrete Solutions',
          project: 'Mall Renovation',
          status: PoStatus.approved,
          estimate: 2600,
        ),
        PurchaseOrder(
          id: 'po-4',
          number: 'PO-2024-004',
          vendor: 'PlumbTech',
          project: 'Residential Complex',
          status: PoStatus.rejected,
          estimate: 1800,
        ),
        PurchaseOrder(
          id: 'po-5',
          number: 'PO-2024-005',
          vendor: 'ElectroPro',
          project: 'Residential Complex',
          status: PoStatus.approved,
          estimate: 1800,
        ),
      ];

  // GET /delivery-receipts
  static List<DeliveryReceipt> receipts() => [
        DeliveryReceipt(
          id: 'dr-1',
          number: 'DR-2024-001',
          poNumber: 'PO-2024-001',
          vendor: 'ABC Lumber Supply',
          project: 'Downtown Office',
          status: ReceiptStatus.received,
          receivedOn: DateTime(2024, 8, 2),
          itemsReceived: 12,
          inspectedBy: 'John Smith',
        ),
        DeliveryReceipt(
          id: 'dr-2',
          number: 'DR-2024-002',
          poNumber: 'PO-2024-003',
          vendor: 'Concrete Solutions',
          project: 'Mall Renovation',
          status: ReceiptStatus.partial,
          receivedOn: DateTime(2024, 8, 4),
          itemsReceived: 8,
          itemsExpected: 15,
          inspectedBy: 'Mike Davis',
        ),
        DeliveryReceipt(
          id: 'dr-3',
          number: 'DR-2024-003',
          poNumber: 'PO-2024-002',
          vendor: 'Steel Works Inc',
          project: 'Harbor Bridge',
          status: ReceiptStatus.received,
          receivedOn: DateTime(2024, 8, 5),
          itemsReceived: 20,
          inspectedBy: 'Sarah Lee',
        ),
      ];

  // GET /vendor-invoices
  static List<VendorInvoice> invoices() => [
        VendorInvoice(
          id: 'inv-1',
          number: 'INV-2024-001',
          poNumber: 'PO-2024-001',
          vendor: 'ABC Lumber Supply',
          project: 'Downtown Office',
          status: InvoiceStatus.paid,
          amount: 4250,
          dueDate: DateTime(2024, 7, 15),
          paidDate: DateTime(2024, 7, 12),
        ),
        VendorInvoice(
          id: 'inv-2',
          number: 'INV-2024-002',
          poNumber: 'PO-2024-001',
          vendor: 'Concrete Solutions',
          project: 'Downtown Office',
          status: InvoiceStatus.overdue,
          amount: 3800,
          dueDate: DateTime(2024, 7, 20),
        ),
        VendorInvoice(
          id: 'inv-3',
          number: 'INV-2024-003',
          poNumber: 'PO-2024-001',
          vendor: 'Concrete Solutions',
          project: 'Mall Renovation',
          status: InvoiceStatus.pending,
          amount: 2600,
          dueDate: DateTime(2024, 8, 10),
        ),
        VendorInvoice(
          id: 'inv-4',
          number: 'INV-2024-004',
          poNumber: 'PO-2024-005',
          vendor: 'ElectroPro',
          project: 'Residential Complex',
          status: InvoiceStatus.paid,
          amount: 2500,
          dueDate: DateTime(2024, 8, 1),
          paidDate: DateTime(2024, 7, 30),
        ),
      ];

  // GET /deliveries?from=today. Dates are relative to today so the
  // "within 5 days" highlight and the range filter always have data.
  static List<DeliveryEvent> deliveries() {
    final t = DateTime.now();
    DateTime inDays(int n) => DateTime(t.year, t.month, t.day + n);
    return [
      DeliveryEvent(
        id: 'd-1',
        date: inDays(1),
        title: 'Lumber Delivery',
        poNumber: 'PO-2024-001',
        vendor: 'ABC Lumber Supply',
        project: 'Downtown Office',
        itemsLabel: '12 items',
      ),
      DeliveryEvent(
        id: 'd-2',
        date: inDays(3),
        title: 'Steel Beam Shipment',
        poNumber: 'PO-2024-002',
        vendor: 'Steel Works Inc',
        project: 'Harbor Bridge',
        itemsLabel: '8 items',
      ),
      DeliveryEvent(
        id: 'd-3',
        date: inDays(5),
        title: 'Concrete Mix Delivery',
        poNumber: 'PO-2024-003',
        vendor: 'Concrete Solutions',
        project: 'Mall Renovation',
        itemsLabel: '20 bags',
      ),
      DeliveryEvent(
        id: 'd-4',
        date: inDays(8),
        title: 'Electrical Supplies',
        poNumber: 'PO-2024-005',
        vendor: 'ElectroPro',
        project: 'Residential Complex',
        itemsLabel: '35 items',
      ),
      DeliveryEvent(
        id: 'd-5',
        date: inDays(11),
        title: 'Plumbing Fixtures',
        poNumber: 'PO-2024-004',
        vendor: 'PlumbTech',
        project: 'Residential Complex',
        itemsLabel: '14 items',
      ),
    ];
  }
}
