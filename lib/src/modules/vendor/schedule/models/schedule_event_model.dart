/// Status of a scheduled event.
enum ScheduleEventStatus { upcoming, inProgress, completed }

extension ScheduleEventStatusX on ScheduleEventStatus {
  String get label {
    switch (this) {
      case ScheduleEventStatus.upcoming:
        return 'Upcoming';
      case ScheduleEventStatus.inProgress:
        return 'In Progress';
      case ScheduleEventStatus.completed:
        return 'Completed';
    }
  }
}

/// A single scheduled event — a delivery window, work date, or project
/// milestone assigned to the field worker.
class ScheduleEventModel {
  final String id;
  final String title;
  final ScheduleEventStatus status;
  final String contractorName;

  /// Value shown under the "PROJECT" label on the details screen. In the
  /// reference design this holds a person's name ("Maisie Hicks") rather
  /// than a project name — kept as-is; see NOTES_SCHEDULE.md.
  final String projectLabel;

  final DateTime startDate;
  final DateTime endDate;

  const ScheduleEventModel({
    required this.id,
    required this.title,
    required this.status,
    required this.contractorName,
    required this.projectLabel,
    required this.startDate,
    required this.endDate,
  });

  int get durationDays => endDate.difference(startDate).inDays + 1;

  String get durationLabel => '$durationDays day${durationDays == 1 ? '' : 's'}';

  static const _shortMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const _weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  static const _longMonths = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December',
  ];

  /// Card row format, e.g. "May 11 - May 15".
  String get formattedDateRange =>
      '${_shortMonths[startDate.month - 1]} ${startDate.day} - '
      '${_shortMonths[endDate.month - 1]} ${endDate.day}';

  /// Details screen format, e.g. "Monday, May 11, 2026".
  String formattedFullDate(DateTime d) =>
      '${_weekdays[d.weekday - 1]}, ${_longMonths[d.month - 1]} ${d.day}, ${d.year}';

  String get formattedStartDate => formattedFullDate(startDate);
  String get formattedEndDate => formattedFullDate(endDate);
}
