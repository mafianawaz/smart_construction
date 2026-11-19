import '../models/purchase_order_model.dart';

/// Mock-data-as-API-seam for Purchase Orders.
/// TODO(api): replace with GET /purchase-orders (list, scoped to the
/// current field-worker/vendor's org) and GET /purchase-orders/:id (detail).
class PurchaseOrdersMockData {
  static List<PurchaseOrderModel> list() {
    return [
      PurchaseOrderModel(
        id: 'po_1',
        poNumber: 'PO #DEV-PO-2026-002',
        status: PurchaseOrderStatus.approved,
        contractorOrgName: 'Dev Sandbox Organization',
        projectName: 'Dev Seed Project',
        issuedDate: DateTime(2026, 7, 22),
        lineItemsCount: 2,
        totalValue: 12500.00,
        createdDate: DateTime(2026, 7, 22),
        expectedDeliveryDate: DateTime(2026, 9, 1),
      ),
      PurchaseOrderModel(
        id: 'po_2',
        poNumber: 'PO #DEV-PO-2026-01',
        status: PurchaseOrderStatus.approved,
        contractorOrgName: 'Dev Sandbox Organization',
        projectName: 'Dev Seed Project',
        issuedDate: DateTime(2026, 7, 22),
        lineItemsCount: 2,
        totalValue: 12500.00,
        createdDate: DateTime(2026, 7, 20),
        expectedDeliveryDate: DateTime(2026, 8, 28),
      ),
    ];
  }

  /// Empty-state seam, so the empty screenshot state is reachable without
  /// deleting the populated mock list above.
  static List<PurchaseOrderModel> empty() => [];
}
