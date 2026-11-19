import '../models/project_docs_models.dart';
import '../models/project_enums.dart';

/// Mock-data seam for RFIs, Transmittals, Submittals, Closeout, Warranty
/// and Maintenance. The references show empty states for everything except
/// the Project Closeout checklist, so only that is seeded.
class ProjectDocsMockData {
  ProjectDocsMockData._();

  // API: GET /projects/{id}/rfis
  static List<RfiModel> rfis(String projectId) => const [];

  // API: GET /projects/{id}/transmittals
  static List<TransmittalModel> transmittals(String projectId) => const [];

  // API: GET /projects/{id}/submittals
  static List<SubmittalModel> submittals(String projectId) => const [];

  /// Guessed — the reference text is small; categories and wording follow
  /// the standard closeout deliverables.
  // API: GET /projects/{id}/closeout/items
  static List<CloseoutItemModel> closeoutItems(String projectId) => const [
        CloseoutItemModel(
          id: 'co_1',
          category: 'Mechanical',
          title: 'Operations & Maintenance manuals',
          description: 'Compile O&M manuals for all installed systems.',
        ),
        CloseoutItemModel(
          id: 'co_2',
          category: 'Warranty',
          title: 'Warranty certificates',
          description: 'Manufacturer and installer warranty documents.',
        ),
        CloseoutItemModel(
          id: 'co_3',
          category: 'Drawings',
          title: 'As-built drawings (record set)',
          description: 'Final marked-up record drawings reflecting field changes.',
        ),
        CloseoutItemModel(
          id: 'co_4',
          category: 'Materials',
          title: 'Attic stock & spare parts',
          description: 'Delivery of spare parts and extra stock to the owner.',
        ),
        CloseoutItemModel(
          id: 'co_5',
          category: 'Training',
          title: 'Owner training sessions',
          description: 'Systems training for owner and facility staff.',
        ),
        CloseoutItemModel(
          id: 'co_6',
          category: 'Financial',
          title: 'Final lien releases',
          description: 'Signed lien waivers from all subcontractors and suppliers.',
        ),
      ];

  // API: GET /projects/{id}/warranty-cases
  static List<WarrantyCaseModel> warrantyCases(String projectId) => const [];

  // API: GET /projects/{id}/maintenance/logs
  static List<MaintenanceLogModel> maintenanceLogs(String projectId) => const [];

  // API: GET /projects/{id}/maintenance/schedules
  static List<MaintenanceScheduleModel> maintenanceSchedules(String projectId) => const [];

  /// Drawing / design-discipline style lists used by the forms.
  static const List<String> warrantyResponsibilities = [
    'General Contractor',
    'Subcontractor',
    'Manufacturer',
    'Owner',
  ];
}
