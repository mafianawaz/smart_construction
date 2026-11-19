import '../models/production_models.dart';

/// Mock-data seam for Production Settings.
class ProductionMockData {
  ProductionMockData._();

  // TODO(api): GET /production-rates/benchmarks
  static List<ProductionBenchmarkModel> benchmarks() {
    final now = DateTime.now();
    return [
      ProductionBenchmarkModel(
        id: 'bm-1',
        scopeName: 'Painting of walls and ceilings',
        unit: 'SF',
        avgDaily: 2750,
        minDaily: 1500,
        maxDaily: 5000,
        totalQty: 5530,
        days: 2,
        projects: 1,
        lastRecorded: now.subtract(const Duration(days: 12)),
      ),
      ProductionBenchmarkModel(
        id: 'bm-2',
        scopeName: 'Install 6-inch Gutter',
        unit: 'EA',
        avgDaily: 2750,
        minDaily: 1500,
        maxDaily: 5000,
        totalQty: 5530,
        days: 2,
        projects: 1,
        lastRecorded: now.subtract(const Duration(days: 40)),
      ),
    ];
  }

  // TODO(api): GET /production-rates/cost-analytics
  static List<CostAnalyticsModel> costAnalytics() {
    final now = DateTime.now();
    return [
      CostAnalyticsModel(
        id: 'ca-1',
        scopeName: 'HVAC modifications and ductwork',
        unit: 'EA',
        laborPerUnit: 120000,
        materialPerUnit: 45000,
        profitPerUnit: -114000,
        totalQty: 0.01,
        confidence: ProductionConfidence.unknown,
        lastRecorded: now.subtract(const Duration(days: 8)),
      ),
      CostAnalyticsModel(
        id: 'ca-2',
        scopeName: 'Install 6-inch Gutter',
        unit: 'LF',
        laborPerUnit: 0,
        materialPerUnit: 0,
        profitPerUnit: 30.80,
        totalQty: 2301,
        confidence: ProductionConfidence.medium,
        lastRecorded: now.subtract(const Duration(days: 40)),
      ),
    ];
  }
}
