import 'package:flutter/material.dart';

/// Category of a calendar entry — mirrors the "meetings, milestones,
/// deadlines, and events" language used in the Calendar screen subtitle.
///
/// Screens never hard-code colors/labels per type; everything funnels
/// through [CalendarEventTypeX] so the mapping lives in exactly one place.
enum CalendarEventType { meeting, milestone, deadline, event }

extension CalendarEventTypeX on CalendarEventType {
  String get label {
    switch (this) {
      case CalendarEventType.meeting:
        return 'Meeting';
      case CalendarEventType.milestone:
        return 'Milestone';
      case CalendarEventType.deadline:
        return 'Deadline';
      case CalendarEventType.event:
        return 'Event';
    }
  }

  /// Dot / chip color for this type.
  ///
  /// NOTE: swap these for the real `AppColors` fields once confirmed — this
  /// module doesn't have visibility into `core/theme/app_colors.dart`, so
  /// raw values are used as a placeholder. See NOTES_CALENDAR.md.
  Color get color {
    switch (this) {
      case CalendarEventType.meeting:
        return const Color(0xFF3E7BFA); // -> AppColors.info
      case CalendarEventType.milestone:
        return const Color(0xFF8B5CF6); // -> AppColors.secondary / purple
      case CalendarEventType.deadline:
        return const Color(0xFFE53935); // -> AppColors.error
      case CalendarEventType.event:
        return const Color(0xFFF2703C); // -> AppColors.primary
    }
  }

  IconData get icon {
    switch (this) {
      case CalendarEventType.meeting:
        return Icons.groups_outlined;
      case CalendarEventType.milestone:
        return Icons.flag_outlined;
      case CalendarEventType.deadline:
        return Icons.alarm_outlined;
      case CalendarEventType.event:
        return Icons.event_outlined;
    }
  }
}

/// A single calendar entry.
///
/// Kept intentionally flat/serializable-shaped (no Flutter-only fields
/// except [TimeOfDay]) so it's a one-to-one swap for a future
/// `CalendarEvent.fromJson` API model — mirrors the mock-data-as-API-seam
/// pattern already used by `MessagesMockData` / `ProjectDetailLogic`.
@immutable
class CalendarEvent {
  final String id;
  final CalendarEventType type;
  final String title;
  final String? description;
  final bool isAllDay;
  final DateTime startDate;
  final DateTime? endDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  const CalendarEvent({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    this.isAllDay = false,
    required this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
  });

  /// Whether this event should render an indicator on [day].
  ///
  /// Multi-day events (start..end) light up every day in the range;
  /// single-day events only light up [startDate].
  bool occursOn(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = endDate == null
        ? start
        : DateTime(endDate!.year, endDate!.month, endDate!.day);
    return !d.isBefore(start) && !d.isAfter(end);
  }

  CalendarEvent copyWith({
    String? id,
    CalendarEventType? type,
    String? title,
    String? description,
    bool? isAllDay,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      isAllDay: isAllDay ?? this.isAllDay,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

const List<String> kWeekdayFullNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const List<String> kMonthFullNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// 'Tuesday, July 14' — matches the label above the Upcoming Events list.
String formatFullDate(DateTime date) {
  final weekday = kWeekdayFullNames[date.weekday - 1];
  final month = kMonthFullNames[date.month - 1];
  return '$weekday, $month ${date.day}';
}

/// 'Jul 14, 2026' — compact form used in the date-picker fields.
String formatCompactDate(DateTime date) {
  const short = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${short[date.month - 1]} ${date.day}, ${date.year}';
}

/// '09:00 AM' — compact form used in the time-picker fields.
String formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '${hour.toString().padLeft(2, '0')}:$minute $period';
}