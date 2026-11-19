import 'package:flutter/material.dart';
import 'calendar_event_model.dart';

/// Mock event source, structured as the future API seam:
/// `CalendarEventMockData.forMonth(month)` today, something like
/// `CalendarEventRepository.fetchMonth(month)` tomorrow — same call
/// shape, same return type, so `CalendarEventLogic` doesn't change.
class CalendarEventMockData {
  CalendarEventMockData._();

  /// Sample events scattered across [month] so the calendar has something
  /// to show out of the box.
  static List<CalendarEvent> forMonth(DateTime month) {
    DateTime on(int day) => DateTime(month.year, month.month, day);
    final lastDay = DateTime(month.year, month.month + 1, 0).day;
    int clamp(int day) => day.clamp(1, lastDay);

    return [
      CalendarEvent(
        id: 'evt_standup_${month.year}_${month.month}',
        type: CalendarEventType.meeting,
        title: 'Team standup',
        description: 'Daily sync on active site tasks.',
        startDate: on(clamp(3)),
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 9, minute: 30),
      ),
      CalendarEvent(
        id: 'evt_review_${month.year}_${month.month}',
        type: CalendarEventType.meeting,
        title: 'Project review',
        description: 'Walkthrough of milestone progress with the client.',
        startDate: on(clamp(7)),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 15, minute: 0),
      ),
      CalendarEvent(
        id: 'evt_milestone_${month.year}_${month.month}',
        type: CalendarEventType.milestone,
        title: 'Foundation work complete',
        isAllDay: true,
        startDate: on(clamp(12)),
      ),
      CalendarEvent(
        id: 'evt_deadline_${month.year}_${month.month}',
        type: CalendarEventType.deadline,
        title: 'Permit submission due',
        isAllDay: true,
        startDate: on(clamp(18)),
      ),
      CalendarEvent(
        id: 'evt_event_${month.year}_${month.month}',
        type: CalendarEventType.event,
        title: 'Safety training',
        description: 'Mandatory site safety refresher.',
        startDate: on(clamp(22)),
        endDate: on(clamp(23)),
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 12, minute: 0),
      ),
    ];
  }
}