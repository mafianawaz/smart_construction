/// Models for the Materials Inventory workflow.

enum LocationType {
  warehouse('Warehouse'),
  yard('Yard'),
  jobsite('Job Site'),
  truck('Truck / Trailer'),
  other('Other');

  const LocationType(this.label);
  final String label;
}

enum InventoryTab {
  onHand('On-Hand'),
  receive('Receive'),
  issue('Issue'),
  transfer('Transfer'),
  adjust('Adjust'),
  reports('Reports'),
  labels('Labels');

  const InventoryTab(this.label);
  final String label;
}

enum InventoryTxnType {
  receive('Receive'),
  issue('Issue'),
  transfer('Transfer'),
  adjust('Adjust');

  const InventoryTxnType(this.label);
  final String label;
}

enum AdjustReason {
  correction('CORRECTION'),
  damage('DAMAGE'),
  loss('LOSS / THEFT'),
  cycleCount('CYCLE COUNT'),
  other('OTHER');

  const AdjustReason(this.label);
  final String label;
}

enum LabelSymbology {
  code128('Code-128 (1-D)'),
  code39('Code-39 (1-D)'),
  ean13('EAN-13 (1-D)'),
  qr('QR Code (2-D)');

  const LabelSymbology(this.label);
  final String label;
}

class InventoryMaterial {
  final String id;
  final String sku;
  final String barcode; // empty = not assigned yet (auto-assigned before printing)
  final String name;
  final String uom;
  final String category; // empty = uncategorised
  final double unitCost;
  final double reorderPoint; // 0 = no alert
  final double reorderQty;

  const InventoryMaterial({
    required this.id,
    required this.sku,
    required this.name,
    this.barcode = '',
    this.uom = 'EA',
    this.category = '',
    this.unitCost = 0,
    this.reorderPoint = 0,
    this.reorderQty = 0,
  });

  InventoryMaterial copyWith({String? barcode}) => InventoryMaterial(
        id: id,
        sku: sku,
        name: name,
        barcode: barcode ?? this.barcode,
        uom: uom,
        category: category,
        unitCost: unitCost,
        reorderPoint: reorderPoint,
        reorderQty: reorderQty,
      );

  String get dropdownLabel => '$sku - $name';
}

class StockLocation {
  final String id;
  final String code;
  final String name;
  final LocationType type;
  final String address;
  final String notes;

  const StockLocation({
    required this.id,
    required this.code,
    required this.name,
    this.type = LocationType.warehouse,
    this.address = '',
    this.notes = '',
  });

  String get dropdownLabel => '$code - $name';
}

/// Quantity of one material at one location. Mutable on purpose: the logic
/// layer adjusts [qty] in place and calls `update()`.
class StockLevel {
  final String materialId;
  final String locationId;
  double qty;

  StockLevel({
    required this.materialId,
    required this.locationId,
    required this.qty,
  });
}

/// One row of the "Stock By Location" view.
class StockRow {
  final StockLocation location;
  final InventoryMaterial material;
  final double qty;

  const StockRow({
    required this.location,
    required this.material,
    required this.qty,
  });
}

class InventoryTransaction {
  final String id;
  final InventoryTxnType type;
  final String materialId;
  final String? fromLocationId; // issue / transfer / negative adjust
  final String? toLocationId; // receive / transfer / positive adjust
  final double qty; // always signed from the stock's point of view for adjust
  final double unitCost;
  final String reference;
  final String project; // issue only
  final String costCode; // issue only
  final String purchaseOrder; // receive only
  final String reason; // adjust only
  final String note;
  final DateTime createdAt;

  const InventoryTransaction({
    required this.id,
    required this.type,
    required this.materialId,
    required this.qty,
    required this.createdAt,
    this.fromLocationId,
    this.toLocationId,
    this.unitCost = 0,
    this.reference = '',
    this.project = '',
    this.costCode = '',
    this.purchaseOrder = '',
    this.reason = '',
    this.note = '',
  });
}

class DeviceSyncStatus {
  final String name;
  final DateTime lastSync;

  const DeviceSyncStatus({required this.name, required this.lastSync});

  bool isBehind(DateTime now) =>
      now.difference(lastSync) > const Duration(hours: 24);
}

class LabelTemplate {
  final String name;
  final String description;
  final int perSheet;

  const LabelTemplate({
    required this.name,
    required this.description,
    required this.perSheet,
  });
}

const List<LabelTemplate> kLabelTemplates = [
  LabelTemplate(
    name: 'Avery 5160 (3 x 10)',
    description: '1" x 2.625" address labels. 30 per US Letter sheet.',
    perSheet: 30,
  ),
  LabelTemplate(
    name: 'Avery 5161 (2 x 10)',
    description: '1" x 4" address labels. 20 per US Letter sheet.',
    perSheet: 20,
  ),
  LabelTemplate(
    name: 'Avery 5163 (2 x 5)',
    description: '2" x 4" shipping labels. 10 per US Letter sheet.',
    perSheet: 10,
  ),
  LabelTemplate(
    name: 'Avery 5167 (4 x 20)',
    description: '0.5" x 1.75" return-address labels. 80 per US Letter sheet.',
    perSheet: 80,
  ),
];
