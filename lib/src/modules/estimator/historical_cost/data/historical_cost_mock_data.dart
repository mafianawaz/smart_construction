import '../models/cost_record_model.dart';

/// Mock seam. Replace with:
///   GET    /estimating/historical-costs
///   POST   /estimating/historical-costs
///   DELETE /estimating/historical-costs/:id
class HistoricalCostMockData {
  static List<CostRecordModel> records() => [
        CostRecordModel(
          id: 'hc_1',
          description: '4-inch concrete slab on grade (3,000 psi)',
          scopeCategory: 'MASONRY',
          trade: 'Concrete',
          costCode: '03-300',
          completedDate: DateTime(2026, 3, 14),
          quantity: 330,
          unit: 'SF',
          unitCost: 11.75,
          projectName: 'Mar. Residential Project',
          projectType: 'Residential',
        ),
        CostRecordModel(
          id: 'hc_2',
          description: '4-inch concrete slab on grade (3,000 psi)',
          scopeCategory: 'CONCRETE',
          trade: 'Concrete',
          costCode: '03-300',
          completedDate: DateTime(2026, 4, 2),
          quantity: 250,
          unit: 'CY',
          unitCost: 48.50,
          projectName: 'Concrete slab on grade...',
          projectType: 'Commercial',
        ),
        CostRecordModel(
          id: 'hc_3',
          description: 'test',
          scopeCategory: 'test',
          trade: 'test',
          costCode: '34',
          completedDate: DateTime(2026, 6, 25),
          quantity: 0.02,
          unit: 'cy',
          unitCost: 56,
        ),
        CostRecordModel(
          id: 'hc_4',
          description: 'concerete',
          scopeCategory: 'concerete',
          trade: 'trade',
          costCode: '33',
          completedDate: DateTime(2026, 6, 25),
          quantity: 33,
          unit: 'ls',
          unitCost: 0,
        ),
      ];
}
