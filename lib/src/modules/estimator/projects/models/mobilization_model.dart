/// One Site Mobilization checklist row. Populated-state shape is a guess
/// (the reference only shows empty states) — flagged in
/// NOTES_PROJECT_TABS.md.
class MobilizationChecklistItem {
  final String id;
  final String title;
  final bool isDone;

  const MobilizationChecklistItem({
    required this.id,
    required this.title,
    this.isDone = false,
  });

  MobilizationChecklistItem copyWith({bool? isDone}) => MobilizationChecklistItem(
        id: id,
        title: title,
        isDone: isDone ?? this.isDone,
      );
}

class MethodStatementModel {
  final String id;
  final String title;
  final DateTime updatedAt;

  const MethodStatementModel({
    required this.id,
    required this.title,
    required this.updatedAt,
  });
}
