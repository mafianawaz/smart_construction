import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_icons.dart';

const kLeaveOrange = Color(0xFFF26A21);

enum LeaveType {
  vacation('Vacation', AppIcons.calendar, 15),
  sick('Sick', AppIcons.temperature, 10),
  personal('Personal', AppIcons.personal, 3),
  juryDuty('Jury Duty', AppIcons.jury, null); // no balance card

  final String label;
  final String icon;
  final int? totalDays; // null = no balance tracked
  const LeaveType(this.label, this.icon, this.totalDays);

  bool get hasBalance => totalDays != null;
}

enum LeaveStatus { pending, approved, rejected }

class LeaveRequest {
  final String id;
  final LeaveType type;
  final DateTime start;
  final DateTime end;
  final String reason;
  final LeaveStatus status;

  const LeaveRequest({
    required this.id,
    required this.type,
    required this.start,
    required this.end,
    required this.reason,
    this.status = LeaveStatus.pending,
  });

  /// Inclusive day count (Aug 6 -> Aug 20 = 15 days).
  int get days => end.difference(start).inDays + 1;
}

String isoDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';