import '../models/inventory_models.dart';

/// Mock-data seam for Materials Inventory.
///
/// Each method marks the HTTP call that replaces it. By default the screen
/// opens the way the Figma does: one material (SK24), no locations, no stock,
/// no field activity. Flip [seedDemo] to true to see populated states
/// (stock by location, low-stock alert, slow-moving list, devices behind).
class InventoryMockData {
  static const bool seedDemo = false;

  // GET /inventory/materials
  static List<InventoryMaterial> materials() => [
        const InventoryMaterial(
          id: 'm-sk24',
          sku: 'SK24',
          name: 'Cement Materials',
          barcode: 'PCM1853ya',
          uom: 'EA',
        ),
        if (seedDemo) ...const [
          InventoryMaterial(
            id: 'm-rb10',
            sku: 'RB10',
            name: 'Rebar #4, 20 ft',
            barcode: 'PCM2210kd',
            uom: 'EA',
            category: 'Rebar',
            unitCost: 12.5,
            reorderPoint: 50,
            reorderQty: 200,
          ),
          InventoryMaterial(
            id: 'm-cn01',
            sku: 'CN01',
            name: 'Concrete mix, Grade A',
            uom: 'BAG',
            category: 'Concrete',
            unitCost: 6.2,
            reorderPoint: 20,
            reorderQty: 100,
          ),
        ],
      ];

  // GET /inventory/locations
  static List<StockLocation> locations() => seedDemo
      ? const [
          StockLocation(
            id: 'l-wh1',
            code: 'WH-01',
            name: 'Main Yard',
            type: LocationType.yard,
            address: '12 Industrial Rd, Lahore',
          ),
          StockLocation(
            id: 'l-tr1',
            code: 'TR-01',
            name: 'Site Trailer',
            type: LocationType.truck,
          ),
        ]
      : const [];

  // GET /inventory/stock
  static List<StockLevel> stock() => seedDemo
      ? [
          StockLevel(materialId: 'm-rb10', locationId: 'l-wh1', qty: 30),
          StockLevel(materialId: 'm-cn01', locationId: 'l-wh1', qty: 80),
        ]
      : [];

  // GET /inventory/transactions?limit=50
  static List<InventoryTransaction> transactions() => seedDemo
      ? [
          InventoryTransaction(
            id: 't-seed-1',
            type: InventoryTxnType.receive,
            materialId: 'm-cn01',
            toLocationId: 'l-wh1',
            qty: 80,
            createdAt: DateTime.now().subtract(const Duration(days: 120)),
            reference: 'PS-1001',
          ),
          InventoryTransaction(
            id: 't-seed-2',
            type: InventoryTxnType.receive,
            materialId: 'm-rb10',
            toLocationId: 'l-wh1',
            qty: 100,
            createdAt: DateTime.now().subtract(const Duration(days: 10)),
            reference: 'PS-1042',
          ),
          InventoryTransaction(
            id: 't-seed-3',
            type: InventoryTxnType.issue,
            materialId: 'm-rb10',
            fromLocationId: 'l-wh1',
            qty: 70,
            project: 'Riverside Tower',
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
        ]
      : [];

  // GET /inventory/devices/sync-status
  static List<DeviceSyncStatus> devices() => seedDemo
      ? [
          DeviceSyncStatus(
            name: 'Ali - Pixel 7',
            lastSync: DateTime.now().subtract(const Duration(hours: 30)),
          ),
        ]
      : [];

  // GET /projects?status=active
  static const List<String> projects = [
    'Riverside Tower',
    'Harbor Warehouse',
    'City Center Retrofit',
  ];

  // GET /purchase-orders?status=open
  static const List<String> purchaseOrders = [
    'PO-1001',
    'PO-1002',
    'PO-1003',
  ];

  // GET /inventory/categories
  static const List<String> categories = [
    'Concrete',
    'Rebar',
    'Lumber',
    'Masonry',
    'Electrical',
    'Plumbing',
    'Fasteners',
    'Other',
  ];

  static const List<String> uoms = [
    'EA',
    'BAG',
    'BOX',
    'LF',
    'SF',
    'CY',
    'TON',
    'GAL',
  ];
}
