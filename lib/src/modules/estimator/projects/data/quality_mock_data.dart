import '../models/quality_models.dart';

/// Mock-data seam for Daily Notes, Inspections, Material Testing and the
/// Production Rates sub-tabs. The references show empty states only, so
/// everything starts empty; Daily Notes fills as entries are added.
class QualityMockData {
  QualityMockData._();

  // API: GET /projects/{id}/daily-notes
  static List<DailyNoteModel> dailyNotes(String projectId) => const [];

  // API: GET /projects/{id}/inspections
  static List<InspectionModel> inspections(String projectId) => const [];

  // API: GET /projects/{id}/material-tests
  static List<MaterialTestModel> materialTests(String projectId) => const [];

  // API: GET /projects/{id}/production-rates/benchmarks
  static List<ProductionBenchmarkModel> benchmarks(String projectId) => const [];

  // API: GET /projects/{id}/production-rates/cost-analytics
  static List<CostPerUnitModel> costAnalytics(String projectId) => const [];
}
