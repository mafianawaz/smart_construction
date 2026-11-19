import 'package:flutter/material.dart';

/// Availability state of a piece of equipment.
enum EquipmentStatus {
  available('Available', Color(0xFF16A34A), Color(0xFFE8F8EE)),
  assigned('Assigned', Color(0xFF2563EB), Color(0xFFE8F0FE)),
  inRepair('In Repair', Color(0xFFD97706), Color(0xFFFEF3E2)),
  outOfService('Out of Service', Color(0xFFDC2626), Color(0xFFFDEBEB));

  const EquipmentStatus(this.label, this.color, this.background);
  final String label;
  final Color color;
  final Color background;
}

/// Tabs on the equipment detail screen, in the order the design shows them.
enum EquipmentDetailTab {
  overview('Overview'),
  assignments('Assignments'),
  repair('Repair'),
  hourLog('Hour Log'),
  preventativeMaintenance('Preventative Maintenance'),
  documents('Documents');

  const EquipmentDetailTab(this.label);
  final String label;
}

class EquipmentAssignment {
  final String id;
  final String assignee; // person or project the unit was assigned to
  final DateTime startDate;
  final DateTime? endDate; // null = still assigned

  const EquipmentAssignment({
    required this.id,
    required this.assignee,
    required this.startDate,
    this.endDate,
  });
}

class EquipmentRepair {
  final String id;
  final String description;
  final DateTime date;
  final String? cost; // pre-formatted, e.g. "\$420.00"

  const EquipmentRepair({
    required this.id,
    required this.description,
    required this.date,
    this.cost,
  });
}

class EquipmentHourLog {
  final String id;
  final DateTime date;
  final double hours;
  final String? note;

  const EquipmentHourLog({
    required this.id,
    required this.date,
    required this.hours,
    this.note,
  });
}

class EquipmentModel {
  final String id;
  final String name; // "Cat 296D"
  final String code; // "CQ-1800"
  final String make; // "Caterpillar"
  final String model; // "296D"
  final int? year;
  final String type; // "Heavy Equipment"
  final String? serialNumber;
  final double currentHours;
  final EquipmentStatus status;
  final int locationCount;
  final List<EquipmentAssignment> assignments;
  final List<EquipmentRepair> repairs;
  final List<EquipmentHourLog> hourLogs;

  const EquipmentModel({
    required this.id,
    required this.name,
    required this.code,
    required this.make,
    required this.model,
    required this.type,
    required this.currentHours,
    required this.status,
    this.year,
    this.serialNumber,
    this.locationCount = 1,
    this.assignments = const [],
    this.repairs = const [],
    this.hourLogs = const [],
  });

  /// "CQ-1800 • Caterpillar 296D"
  String get subtitle => '$code • $make $model';

  /// "1300.0 hrs"
  String get hoursLabel => '${currentHours.toStringAsFixed(1)} hrs';
}
