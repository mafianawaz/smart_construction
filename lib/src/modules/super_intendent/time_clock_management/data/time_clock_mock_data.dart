import '../models/time_clock_models.dart';

/// Mock-data seam for Time Clock Management.
///
/// Every method marks the endpoint that replaces it. Times are generated
/// relative to `DateTime.now()` so "4 months ago" style labels stay stable.
class TimeClockMockData {
  TimeClockMockData._();

  /// GET /time-clock/active-shifts
  static List<ActiveShift> activeShifts() {
    final now = DateTime.now();
    return [
      ActiveShift(
        id: 'as-1',
        employeeName: 'Test HOURLY EMPLOYEE',
        role: 'FIELD_WORKER',
        location: 'EZ Convenience Store',
        employeeId: '260025',
        clockIn: now.subtract(const Duration(hours: 3066, minutes: 45)),
        latitude: 0,
        longitude: 0,
        hasGeofence: false,
      ),
    ];
  }

  /// GET /time-clock/pending-shifts
  static List<PendingShift> pendingShifts() {
    final base = DateTime(2026, 5, 21);
    final shifts = <PendingShift>[
      PendingShift(
        id: 'ps-1',
        employeeName: 'Test FIELD WORKER',
        role: 'FIELD_WORKER',
        projectLabel: 'Project 07465',
        employeeId: '#89197',
        // Clock-out before clock-in on purpose: reproduces the reference's
        // "0h 0m" row and exercises the clamp in `PendingShift.duration`.
        clockIn: DateTime(base.year, base.month, base.day, 17, 58),
        clockOut: DateTime(base.year, base.month, base.day, 5, 18),
      ),
      PendingShift(
        id: 'ps-2',
        employeeName: 'Test FIELD WORKER',
        role: 'FIELD_WORKER',
        projectLabel: 'E2 Convenience Store',
        employeeId: '#89400',
        clockIn: DateTime(2026, 4, 17, 12, 15),
        clockOut: DateTime(2026, 4, 17, 16, 30),
      ),
    ];
    // Eight more rows so the badge reads 10 like the reference.
    for (var i = 3; i <= 10; i++) {
      final day = DateTime(2026, 4, 17 - (i % 14));
      shifts.add(
        PendingShift(
          id: 'ps-$i',
          employeeName: 'Test FIELD WORKER',
          role: 'FIELD_WORKER',
          projectLabel: i.isEven ? 'E2 Convenience Store' : 'Project 07465',
          employeeId: '#89${400 + i}',
          clockIn: DateTime(day.year, day.month, day.day, 8, 0),
          clockOut: DateTime(day.year, day.month, day.day, 16, 30),
        ),
      );
    }
    return shifts;
  }

  /// GET /time-clock/pending-entries — count only, the entries themselves
  /// live on the Time Entry Management page.
  static int pendingTimeEntryCount() => 0;

  /// GET /time-clock/overtime-requests?status=pending
  static List<OvertimeRequest> overtimeRequests() {
    final now = DateTime.now();
    return [
      OvertimeRequest(
        id: 'ot-1',
        employeeName: 'Test FIELD WORKER',
        role: 'FIELD_WORKER',
        location: 'E2 Convenience Store',
        date: DateTime(2026, 4, 6),
        note: 'test',
        regularHours: 8.0,
        overtimeHours: 20.0,
        requestedAt: now.subtract(const Duration(days: 118)),
      ),
    ];
  }

  // POST /time-clock/shifts/{id}/approve
  // POST /time-clock/shifts/{id}/adjust   { clockIn, clockOut }
  // POST /time-clock/shifts/{id}/reject   { reason }
  // POST /time-clock/overtime-requests/{id}/approve
  // POST /time-clock/overtime-requests/{id}/reject
}
