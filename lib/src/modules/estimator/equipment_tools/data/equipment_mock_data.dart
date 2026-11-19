import '../models/equipment_models.dart';

/// Mock-data seam for Equipment & Tools.
///
/// Replace each method with the real call:
///   equipment()        -> GET /equipment
///   (assignments, repairs and hour logs ride along on each item for now;
///    split into GET /equipment/{id}/assignments|repairs|hour-logs later)
class EquipmentMockData {
  EquipmentMockData._();

  static List<EquipmentModel> equipment() => [
        // Matches the reference: both history tabs empty.
        const EquipmentModel(
          id: 'eq-1',
          name: 'Cat 296D',
          code: 'CQ-1800',
          make: 'Caterpillar',
          model: '296D',
          year: 2016,
          type: 'Heavy Equipment',
          serialNumber: null,
          currentHours: 1300.0,
          status: EquipmentStatus.available,
        ),
        // Populated sample so the non-empty history layouts can be checked.
        EquipmentModel(
          id: 'eq-2',
          name: 'John Deere 400',
          code: 'CQ-MPH',
          make: 'John Deere',
          model: '400',
          year: 2019,
          type: 'Heavy Equipment',
          serialNumber: 'JD400-77219',
          currentHours: 1300.0,
          status: EquipmentStatus.available,
          assignments: [
            EquipmentAssignment(
              id: 'as-1',
              assignee: 'Riverside Plaza',
              startDate: DateTime(2026, 8, 3),
              endDate: DateTime(2026, 9, 12),
            ),
          ],
          repairs: [
            EquipmentRepair(
              id: 'rp-1',
              description: 'Hydraulic hose replacement',
              date: DateTime(2026, 7, 21),
              cost: '\$420.00',
            ),
          ],
          hourLogs: [
            EquipmentHourLog(
              id: 'hl-1',
              date: DateTime(2026, 10, 15),
              hours: 8.5,
              note: 'Site grading',
            ),
          ],
        ),
      ];
}
