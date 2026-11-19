import 'package:flutter/material.dart';

import '../models/dispatch_models.dart';

/// Mock-data seam for the Dispatch Board.
///
/// Every method marks the REST call that replaces it. Nothing outside this
/// file should construct demo data.
class DispatchMockData {
  DispatchMockData._();

  /// Set to false to start with an empty board (empty-state check).
  static const bool seedDemo = true;

  /// GET /dispatch/crews
  static List<Crew> crews() => const [
        Crew(id: 'crew_a', name: 'Concrete Crew A', color: Color(0xFFF26A21)),
        Crew(id: 'crew_b', name: 'Framing Crew B', color: Color(0xFF10B981)),
        Crew(id: 'crew_c', name: 'Electrical Crew C', color: Color(0xFF8B5CF6)),
      ];

  /// GET /dispatch/projects
  /// The first three come from the reference design; the last two are filler
  /// so the dropdown has something to scroll.
  static List<DispatchProject> projects() => const [
        DispatchProject(id: 'p_downtown', name: 'Downtown Office'),
        DispatchProject(id: 'p_riverside', name: 'Riverside Apartments'),
        DispatchProject(id: 'p_harbor', name: 'Harbor View'),
        DispatchProject(id: 'p_maple', name: 'Maple Street Retail'),
        DispatchProject(id: 'p_airport', name: 'Airport Logistics Hub'),
      ];

  /// GET /dispatch/assignments?from=&to=
  ///
  /// Generated relative to [today] so the board always opens populated, like
  /// the reference: today has all three crews on the reference projects, and
  /// the surrounding weekdays get a deterministic scatter of 0-3 crews.
  static List<CrewAssignment> assignments(DateTime today) {
    if (!seedDemo) return [];
    final crewList = crews();
    final projectList = projects();
    final start = dateOnly(today);
    final out = <CrewAssignment>[];

    for (var offset = -45; offset <= 75; offset++) {
      final d = DateTime(start.year, start.month, start.day + offset);
      final isWeekend =
          d.weekday == DateTime.saturday || d.weekday == DateTime.sunday;

      for (var i = 0; i < crewList.length; i++) {
        final String? projectId;
        if (offset == 0) {
          // Mirrors "Today's Assignments" in the reference design.
          projectId = const ['p_downtown', 'p_riverside', 'p_harbor'][i];
        } else if (isWeekend) {
          projectId = null;
        } else if ((d.day + d.month + i * 2) % 3 == 0) {
          projectId = null; // crew is free that day
        } else {
          projectId = projectList[(d.day + i) % projectList.length].id;
        }
        if (projectId == null) continue;
        out.add(CrewAssignment(
          id: 'asg_${dateKey(d)}_${crewList[i].id}',
          crewId: crewList[i].id,
          projectId: projectId,
          date: d,
        ));
      }
    }
    return out;
  }
}
