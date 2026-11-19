import 'project_enums.dart';

/// One node of the Building / Floor / Room / Zone hierarchy. The
/// reference "Add Location" form has no parent picker, so the hierarchy
/// is flat and ordered by [level] — flagged in NOTES_ESTIMATING_TABS.md.
class LocationModel {
  final String id;
  final String name;
  final LocationLevel level;
  final String? description;

  const LocationModel({
    required this.id,
    required this.name,
    required this.level,
    this.description,
  });
}
