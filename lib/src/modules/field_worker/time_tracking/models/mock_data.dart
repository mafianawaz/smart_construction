import '../models/time_tracking_models.dart';

/// Mock data standing in for the Time Tracking API. Each factory method
/// is a 1:1 seam — swap the body for a repository/API call and nothing
/// downstream (controllers, widgets) needs to change.
class TimeTrackingMockData {
  TimeTrackingMockData._();

  static List<ProjectOption> projects() => const [
    ProjectOption(id: 'p1', name: 'E2E Project 1778 - 269873'),
    ProjectOption(id: 'p2', name: 'EZ Convenience Store'),
  ];

  static List<CostCodeOption> costCodesForProject(String projectId) => const [
    CostCodeOption(id: 'c1', code: '01-100', description: 'General Labor'),
    CostCodeOption(id: 'c2', code: '02-200', description: 'Site Prep'),
  ];

  static List<ApproverOption> approvers() => const [
    ApproverOption(id: 'a1', name: 'Jordan Blake', role: 'Site Supervisor'),
    ApproverOption(id: 'a2', name: 'Casey Reyes', role: 'Project Manager'),
  ];

  static List<ShiftEntry> shiftHistory() {
    final day = DateTime(2026, 5, 21);
    return [
      ShiftEntry(
        id: 's1',
        date: day,
        status: ShiftStatus.pending,
        projectName: 'E2E Project 1775 - 269873',
        projectCode: '269873',
        clockIn: DateTime(2026, 5, 21, 19, 17),
        clockOut: DateTime(2026, 5, 21, 19, 18),
        total: Duration.zero,
      ),
      ShiftEntry(
        id: 's2',
        date: day,
        status: ShiftStatus.pending,
        projectName: 'E2E Project 1778 - 12',
        projectCode: '269873',
        clockIn: DateTime(2026, 5, 21, 19, 17),
        clockOut: DateTime(2026, 5, 21, 19, 18),
        total: const Duration(hours: 8),
        overtimeExcess: const Duration(hours: 599, minutes: 59),
        canRequestOvertime: true,
      ),
    ];
  }
}
