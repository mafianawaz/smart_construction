/// Models for the Time Clock Management feature.
///
/// Plain Dart only (no Flutter / GetX imports) so they can be reused by
/// whatever real API layer replaces `TimeClockMockData`.

enum TimeClockTab {
  liveMonitoring('Live Monitoring'),
  shiftApprovals('Shift Approvals'),
  timeEntry('Time Entry'),
  otRequests('OT Requests');

  const TimeClockTab(this.label);
  final String label;
}

/// A shift that is currently clocked in.
class ActiveShift {
  const ActiveShift({
    required this.id,
    required this.employeeName,
    required this.role,
    required this.location,
    required this.employeeId,
    required this.clockIn,
    this.latitude,
    this.longitude,
    this.hasGeofence = false,
  });

  final String id;
  final String employeeName;

  /// Raw role key as the API sends it, e.g. `FIELD_WORKER`.
  final String role;
  final String location;
  final String employeeId;
  final DateTime clockIn;
  final double? latitude;
  final double? longitude;
  final bool hasGeofence;

  Duration elapsed([DateTime? now]) {
    final d = (now ?? DateTime.now()).difference(clockIn);
    return d.isNegative ? Duration.zero : d;
  }

  String get coordinatesLabel {
    final lat = (latitude ?? 0).toStringAsFixed(6);
    final lng = (longitude ?? 0).toStringAsFixed(6);
    return '$lat, $lng';
  }
}

/// A completed shift waiting for a supervisor's approval.
class PendingShift {
  const PendingShift({
    required this.id,
    required this.employeeName,
    required this.role,
    required this.projectLabel,
    required this.employeeId,
    required this.clockIn,
    required this.clockOut,
  });

  final String id;
  final String employeeName;
  final String role;
  final String projectLabel;
  final String employeeId;
  final DateTime clockIn;
  final DateTime clockOut;

  DateTime get date => clockIn;

  /// Never negative: a clock-out before the clock-in shows as 0h 0m.
  Duration get duration {
    final d = clockOut.difference(clockIn);
    return d.isNegative ? Duration.zero : d;
  }

  PendingShift copyWith({DateTime? clockIn, DateTime? clockOut}) {
    return PendingShift(
      id: id,
      employeeName: employeeName,
      role: role,
      projectLabel: projectLabel,
      employeeId: employeeId,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
    );
  }
}

/// An overtime request waiting for approval.
class OvertimeRequest {
  const OvertimeRequest({
    required this.id,
    required this.employeeName,
    required this.role,
    required this.location,
    required this.date,
    required this.note,
    required this.regularHours,
    required this.overtimeHours,
    required this.requestedAt,
  });

  final String id;
  final String employeeName;
  final String role;
  final String location;
  final DateTime date;
  final String note;
  final double regularHours;
  final double overtimeHours;
  final DateTime requestedAt;
}
