import '../models/tm_models.dart';

/// Mock-data seam for the Daily T&M Sheet.
class TmMockData {
  TmMockData._();

  /// GET /projects?assigned=me
  static List<TmProject> projects() => const [
        TmProject(id: 'p-261202', label: '261202 - testing general contractor'),
        TmProject(id: 'p-07465', label: '07465 - E2 Convenience Store'),
        TmProject(id: 'p-89197', label: '89197 - EZ Convenience Store'),
      ];

  /// GET /tm-sheets/defaults?projectId=...
  static TmFormDefaults defaults() => const TmFormDefaults(
        crewSize: 8,
        companyRep: 'John Smith',
        clientRep: 'Jane Doe',
        weather: 'Sunny, 72°F',
      );

  /// GET /projects/{id}/tm-sheets
  /// The first project is intentionally empty (matches the reference's
  /// "No T&M sheets found for this project" state).
  static List<TmSheet> sheetsFor(String projectId) {
    if (projectId != 'p-07465') return [];
    return [
      TmSheet(
        id: 'tm-2',
        projectId: projectId,
        date: DateTime(2026, 10, 28),
        crewSize: 6,
        companyRep: 'John Smith',
        clientRep: 'Jane Doe',
        weather: 'Cloudy, 61°F',
        description: 'Installed conduit runs on level 2 and patched drywall at the east corridor.',
        submittedAt: DateTime(2026, 10, 28, 17, 40),
      ),
      TmSheet(
        id: 'tm-1',
        projectId: projectId,
        date: DateTime(2026, 10, 27),
        crewSize: 5,
        companyRep: 'John Smith',
        clientRep: 'Jane Doe',
        weather: 'Rain, 54°F',
        description: 'Site cleanup and material staging after delivery.',
        submittedAt: DateTime(2026, 10, 27, 16, 55),
      ),
    ];
  }

  // POST /projects/{id}/tm-sheets
  //   { date, crewSize, companyRep, clientRep, weather, description }
}
