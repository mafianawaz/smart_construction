import '../models/schedule_event_model.dart';

/// Static mock data for the Schedule module.
class ScheduleMockData {
  ScheduleMockData._();

  /// Populated list — matches the second reference frame.
  // TODO(api): GET /api/field-worker/schedule
  static List<ScheduleEventModel> scheduledEvents() {
    return [
      ScheduleEventModel(
        id: 'evt_mobilization',
        title: 'Project Mobilization & Site Setup',
        status: ScheduleEventStatus.upcoming,
        contractorName: 'Dev Sandbox Organization',
        projectLabel: 'Maisie Hicks',
        startDate: DateTime(2026, 5, 11),
        endDate: DateTime(2026, 5, 13), // "2 days" per detail screen badge
      ),
      ScheduleEventModel(
        id: 'evt_life_safety',
        title: 'Life Safety Systems',
        status: ScheduleEventStatus.completed,
        contractorName: 'Dev Sandbox Organization',
        projectLabel: 'Maisie Hicks',
        startDate: DateTime(2026, 6, 23),
        endDate: DateTime(2026, 6, 24),
      ),
    ];
  }

  /// Empty list — matches the first reference frame.
  static List<ScheduleEventModel> emptySchedule() => [];
}
