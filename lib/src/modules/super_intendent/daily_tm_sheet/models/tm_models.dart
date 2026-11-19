/// Models for the Daily T&M (Time & Materials) Sheet feature.
/// Plain Dart only — reusable by whatever API layer replaces the mock seam.

class TmProject {
  const TmProject({required this.id, required this.label});

  final String id;

  /// Display label, e.g. "261202 - testing general contractor".
  final String label;
}

class TmSheet {
  const TmSheet({
    required this.id,
    required this.projectId,
    required this.date,
    required this.crewSize,
    required this.companyRep,
    required this.clientRep,
    required this.weather,
    required this.description,
    required this.submittedAt,
  });

  final String id;
  final String projectId;
  final DateTime date;
  final int crewSize;
  final String companyRep;
  final String clientRep;
  final String weather;
  final String description;
  final DateTime submittedAt;
}

/// Values the form opens with (the reference shows it pre-filled).
class TmFormDefaults {
  const TmFormDefaults({
    required this.crewSize,
    required this.companyRep,
    required this.clientRep,
    required this.weather,
  });

  final int crewSize;
  final String companyRep;
  final String clientRep;
  final String weather;
}
