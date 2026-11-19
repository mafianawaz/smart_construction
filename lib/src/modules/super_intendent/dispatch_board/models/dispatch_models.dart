import 'package:flutter/material.dart';

/// Strips the time part so dates can be compared and used as map keys.
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// 'yyyy-MM-dd' key for a date.
String dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// A crew that can be dispatched. [color] is the dot colour on the calendar.
class Crew {
  final String id;
  final String name;
  final Color color;

  const Crew({required this.id, required this.name, required this.color});
}

/// A project a crew can be assigned to.
class DispatchProject {
  final String id;
  final String name;

  const DispatchProject({required this.id, required this.name});
}

/// One crew on one project for one day. A crew has at most one assignment
/// per day (assigning again replaces it).
class CrewAssignment {
  final String id;
  final String crewId;
  final String projectId;
  final DateTime date; // date-only
  final String notes;

  const CrewAssignment({
    required this.id,
    required this.crewId,
    required this.projectId,
    required this.date,
    this.notes = '',
  });

  CrewAssignment copyWith({String? projectId, String? notes}) {
    return CrewAssignment(
      id: id,
      crewId: crewId,
      projectId: projectId ?? this.projectId,
      date: date,
      notes: notes ?? this.notes,
    );
  }
}

/// What the Assign Crew sheet hands back when the user taps Assign.
class AssignCrewResult {
  final String projectId;
  final String notes;

  const AssignCrewResult({required this.projectId, required this.notes});
}
