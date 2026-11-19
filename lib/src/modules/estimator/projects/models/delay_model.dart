import 'project_enums.dart';

/// One logged delay on the Delays tab. Populated-state shape is a guess
/// (the reference only shows the empty state) — flagged in
/// NOTES_PROJECT_TABS.md.
class DelayModel {
  final String id;
  final String title;
  final DelayReason reason;
  final DelayStatus status;
  final DateTime startDate;
  final int daysLost;
  final String notes;

  const DelayModel({
    required this.id,
    required this.title,
    required this.reason,
    required this.status,
    required this.startDate,
    this.daysLost = 0,
    this.notes = '',
  });
}
