import 'project_enums.dart';

/// One row of the Gantt Chart. [startOffsetDays] is this task's start,
/// in days from the project's schedule start — the reference lays
/// tasks out sequentially rather than showing true critical-path-method
/// overlap, so `GanttTasks` in mock data are positioned the same way
/// (cumulative, not computed), flagged in NOTES_PROJECTS.md.
class GanttTaskModel {
  final String id;
  final String name;
  final int durationDays;
  final int startOffsetDays;
  final bool isCriticalPath;
  final GanttBarKind barKind;

  /// Slack before this task would delay the project. Critical-path tasks
  /// are 0 by definition ("Float: 0d" in the Critical Path chain).
  final int floatDays;
  final GanttTaskStatus status;

  const GanttTaskModel({
    required this.id,
    required this.name,
    required this.durationDays,
    required this.startOffsetDays,
    this.isCriticalPath = false,
    this.barKind = GanttBarKind.planned,
    this.floatDays = 0,
    this.status = GanttTaskStatus.notStarted,
  });

  /// Exclusive end, in days from the schedule start.
  int get endOffsetDays => startOffsetDays + durationDays;
}

/// Forecast tab numbers. Mock-only for now: they are NOT derived from the
/// Gantt tasks (the reference shows them with no schedule at all), so
/// they stay independent until the API supplies them — flagged in
/// NOTES_PROJECT_TABS.md.
class ScheduleForecastModel {
  final DateTime projectedCompletion;
  final DateTime baselineCompletion;

  /// null renders as "N/A" (no locked baseline yet).
  final double? schedulePerformanceIndex;

  /// Positive = behind baseline.
  final int baselineVarianceDays;
  final int criticalPathRemainingDays;

  const ScheduleForecastModel({
    required this.projectedCompletion,
    required this.baselineCompletion,
    this.schedulePerformanceIndex,
    this.baselineVarianceDays = 0,
    this.criticalPathRemainingDays = 0,
  });

  String get spiLabel => schedulePerformanceIndex == null
      ? 'N/A'
      : schedulePerformanceIndex!.toStringAsFixed(2);

  String get varianceLabel {
    final d = baselineVarianceDays;
    final unit = d.abs() == 1 ? 'day' : 'days';
    return d > 0 ? '+$d $unit' : '$d $unit';
  }
}

/// One row of the Resources tab's "Crew Assignments".
class CrewAssignmentModel {
  final String id;
  final String crewName;
  final String taskName;
  final int headcount;

  const CrewAssignmentModel({
    required this.id,
    required this.crewName,
    required this.taskName,
    required this.headcount,
  });
}

/// One "AI Optimization Recommendation" card — dismissible, with an
/// estimated schedule saving.
class OptimizationRecommendationModel {
  final String id;
  final String title;
  final String description;
  final int daysSaved;

  const OptimizationRecommendationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.daysSaved,
  });
}

/// One row of "Recent Sends" — a past schedule email/export.
class ScheduleSendRecord {
  final String id;
  final DateTime sentAt;
  final String recipientSummary;

  const ScheduleSendRecord({
    required this.id,
    required this.sentAt,
    required this.recipientSummary,
  });
}
