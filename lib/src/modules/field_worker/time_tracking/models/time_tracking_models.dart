import 'package:flutter/foundation.dart';

/// Status of a logged shift, driving the pill color/label on the
/// Shift History tile.
enum ShiftStatus { pending, approved, rejected }

extension ShiftStatusX on ShiftStatus {
  String get label {
    switch (this) {
      case ShiftStatus.pending:
        return 'Pending';
      case ShiftStatus.approved:
        return 'Approved';
      case ShiftStatus.rejected:
        return 'Rejected';
    }
  }
}

/// Device GPS state for the Clock In flow. `unavailable` drives the
/// warning banner shown on the reference screens.
enum GpsStatus { unknown, checking, available, unavailable }

@immutable
class ProjectOption {
  final String id;
  final String name;

  const ProjectOption({required this.id, required this.name});
}

@immutable
class CostCodeOption {
  final String id;
  final String code;
  final String? description;

  const CostCodeOption({required this.id, required this.code, this.description});
}

@immutable
class ApproverOption {
  final String id;
  final String name;
  final String? role;

  const ApproverOption({required this.id, required this.name, this.role});
}

/// A single row in Shift History. `canRequestOvertime` toggles the
/// "Request OT" action on the tile — set by whatever produced the entry
/// (mock data today, API response later), never inferred by the widget.
@immutable
class ShiftEntry {
  final String id;
  final DateTime date;
  final ShiftStatus status;
  final String projectName;
  final String projectCode;
  final DateTime clockIn;
  final DateTime? clockOut;
  final Duration? total;
  final Duration? overtimeExcess;
  final bool canRequestOvertime;

  const ShiftEntry({
    required this.id,
    required this.date,
    required this.status,
    required this.projectName,
    required this.projectCode,
    required this.clockIn,
    this.clockOut,
    this.total,
    this.overtimeExcess,
    this.canRequestOvertime = false,
  });
}
