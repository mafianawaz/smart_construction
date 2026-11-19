import '../models/equipment_models.dart';

/// Mock-data seam for Equipment & Tools. Replace each method with the REST
/// call in its comment; nothing else should construct demo data.
class EquipmentMockData {
  EquipmentMockData._();

  /// Set to false to start with an empty fleet (empty-state check).
  static const bool seedDemo = true;

  /// GET /equipment
  /// Matches the reference: 3 available heavy-equipment items, $160k fleet value.
  static List<EquipmentItem> items() {
    if (!seedDemo) return [];
    return const [
      EquipmentItem(
        id: 'eq_2',
        code: 'EQ-0002',
        details: EquipmentDraft(
          name: 'Cat 299D',
          type: EquipmentType.heavyEquipment,
          make: 'Caterpillar',
          model: '299D',
          currentHours: 1000,
          purchasePrice: 85000,
        ),
      ),
      EquipmentItem(
        id: 'eq_1',
        code: 'EQ-0001',
        details: EquipmentDraft(
          name: 'John Deere 60G',
          type: EquipmentType.heavyEquipment,
          make: 'John Deere',
          model: '60G',
          currentHours: 1300,
          purchasePrice: 60000,
        ),
      ),
      EquipmentItem(
        id: 'eq_3',
        code: 'EQ-0003',
        details: EquipmentDraft(
          name: 'Rippa Pro 32',
          type: EquipmentType.heavyEquipment,
          make: 'Rippa',
          model: 'Pro 32',
          currentHours: 55,
          purchasePrice: 15000,
        ),
      ),
    ];
  }
}
