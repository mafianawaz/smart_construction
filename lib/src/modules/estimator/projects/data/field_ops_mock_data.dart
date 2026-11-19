import '../models/field_ops_models.dart';
import '../models/project_enums.dart';

/// Mock-data seam for Punch List, T&M Tracking, Labor Hours,
/// Subcontractors and Equipment. The references show mostly empty states,
/// so only the Punch List item and the three T&M time entries the
/// references display are seeded — everything else starts empty.
class FieldOpsMockData {
  FieldOpsMockData._();

  /// Guessed — the Assign To (Team Member) dropdown shows no options.
  // API: GET /projects/{id}/team-members
  static const List<String> teamMembers = [
    'Unassigned',
    'Project Manager',
    'Superintendent',
    'Foreman',
    'Safety Contact',
  ];

  // API: GET /projects/{id}/punch-items
  static List<PunchItemModel> punchItems(String projectId) => [
        PunchItemModel(
          id: 'punch_seed_1',
          number: 'PLI-0001',
          title: 'Touch up paint',
          description: 'Touch up paint on corridor walls',
          trade: ProjectTrade.general,
          priority: PunchPriority.low,
          status: PunchStatus.inProgress,
          createdAt: DateTime(2026, 6, 21),
        ),
      ];

  // API: GET /projects/{id}/tm/time-entries
  static List<TmTimeEntryModel> tmTimeEntries(String projectId) => [
        TmTimeEntryModel(
          id: 'tm_seed_1',
          date: DateTime(2026, 6, 21),
          hours: 8.2,
          description: 'Site cleanup and material staging',
          detail: 'Field crew',
        ),
        TmTimeEntryModel(
          id: 'tm_seed_2',
          date: DateTime(2026, 6, 18),
          hours: 5.0,
          description: 'Punch list corrections',
          detail: 'Field crew',
        ),
        TmTimeEntryModel(
          id: 'tm_seed_3',
          date: DateTime(2026, 6, 16),
          hours: 6.38,
          description: 'Access repairs, removal and replacement of damaged panels',
          detail: 'Field crew',
        ),
      ];

  // API: GET /projects/{id}/labor-hours
  static List<LaborEntryModel> laborEntries(String projectId) => const [];

  // API: GET /projects/{id}/subcontractor-assignments
  static List<SubcontractAssignmentModel> subcontractors(String projectId) => const [];

  // API: GET /projects/{id}/equipment/plan
  static List<PlannedEquipmentModel> plannedEquipment(String projectId) => const [];

  // API: GET /projects/{id}/equipment/assigned
  static List<AssignedEquipmentModel> assignedEquipment(String projectId) => const [];
}
