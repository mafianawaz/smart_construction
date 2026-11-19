/// Models for Plans & Takeoff and Field Takeoff. The reference shows
/// only empty states and the fixed folder list, so the file/addendum/
/// drawing-set/takeoff-item shapes are guesses — flagged in
/// NOTES_PROJECT_TABS.md.

enum DocumentFolderKind { folder, library }

class ProjectDocumentModel {
  final String id;
  final String name;
  final String sizeLabel;

  const ProjectDocumentModel({
    required this.id,
    required this.name,
    this.sizeLabel = '',
  });
}

class DocumentFolderModel {
  final String id;
  final String name;
  final DocumentFolderKind kind;
  final List<ProjectDocumentModel> files;

  const DocumentFolderModel({
    required this.id,
    required this.name,
    this.kind = DocumentFolderKind.folder,
    this.files = const [],
  });

  int get count => files.length;

  DocumentFolderModel copyWith({List<ProjectDocumentModel>? files}) =>
      DocumentFolderModel(
        id: id,
        name: name,
        kind: kind,
        files: files ?? this.files,
      );
}

class AddendumModel {
  final String id;
  final String title;
  final DateTime issuedAt;

  const AddendumModel({
    required this.id,
    required this.title,
    required this.issuedAt,
  });
}

class DrawingSetModel {
  final String id;
  final String name;
  final int sheetCount;

  const DrawingSetModel({
    required this.id,
    required this.name,
    this.sheetCount = 0,
  });
}

/// One measured quantity, used by the Reports tab and by Field Takeoff
/// (Field View lists them; Location Breakdown groups them by [location]).
class TakeoffItemModel {
  final String id;
  final String name;
  final String quantityLabel;
  final String location;

  const TakeoffItemModel({
    required this.id,
    required this.name,
    required this.quantityLabel,
    this.location = 'Unassigned',
  });
}

/// One selectable quantity category on "Import Takeoff Quantities". Shape
/// is a guess (the reference shows only the empty state) — flagged in
/// NOTES_ESTIMATING_TABS.md.
class TakeoffCategoryModel {
  final String id;
  final String name;
  final String unit;
  final double quantity;

  const TakeoffCategoryModel({
    required this.id,
    required this.name,
    this.unit = '',
    this.quantity = 0,
  });
}
