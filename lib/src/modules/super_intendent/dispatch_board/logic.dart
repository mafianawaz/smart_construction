import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'crew_capacity/view.dart';
import 'data/dispatch_format.dart';
import 'data/dispatch_mock_data.dart';
import 'models/dispatch_models.dart';
import 'widgets/assign_crew_sheet.dart';


/// Controller for the Dispatch Board and Crew Capacity screens.
///
/// Plain fields + `update()` (GetBuilder), matching PricingLogic. The
/// calendar's own month/selection state stays in its `CalendarController`;
/// this controller only owns the dispatch data and the selected date.
class DispatchLogic extends GetxController {
  DateTime selectedDate = dateOnly(DateTime.now());

  List<Crew> crews = [];
  List<DispatchProject> projects = [];
  List<CrewAssignment> assignments = [];

  /// Monday of the week shown on Crew Capacity.
  DateTime capacityWeekStart = _mondayOf(DateTime.now());

  Map<String, List<CrewAssignment>> _byDate = {};

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() {
    // TODO(api): GET /dispatch/crews, /dispatch/projects, /dispatch/assignments
    crews = DispatchMockData.crews();
    projects = DispatchMockData.projects();
    assignments = DispatchMockData.assignments(DateTime.now());
    _reindex();
    update();
  }

  // ───────────── lookups ─────────────

  void _reindex() {
    final order = {for (var i = 0; i < crews.length; i++) crews[i].id: i};
    final map = <String, List<CrewAssignment>>{};
    for (final a in assignments) {
      (map[dateKey(a.date)] ??= []).add(a);
    }
    for (final list in map.values) {
      list.sort((a, b) => (order[a.crewId] ?? 0).compareTo(order[b.crewId] ?? 0));
    }
    _byDate = map;
  }

  Crew? crewById(String id) {
    for (final c in crews) {
      if (c.id == id) return c;
    }
    return null;
  }

  DispatchProject? projectById(String id) {
    for (final p in projects) {
      if (p.id == id) return p;
    }
    return null;
  }

  List<CrewAssignment> assignmentsOn(DateTime day) =>
      _byDate[dateKey(day)] ?? const [];

  CrewAssignment? assignmentFor(String crewId, DateTime day) {
    for (final a in assignmentsOn(day)) {
      if (a.crewId == crewId) return a;
    }
    return null;
  }

  // ───────────── calendar ─────────────

  /// Dot colours for a calendar day: one per assigned crew, in crew order.
  List<Color> indicatorColorsFor(DateTime day) {
    final list = assignmentsOn(day);
    if (list.isEmpty) return const [];
    return [
      for (final a in list)
        if (crewById(a.crewId) != null) crewById(a.crewId)!.color,
    ];
  }

  void selectDate(DateTime date) {
    final d = dateOnly(date);
    if (d == selectedDate) return;
    selectedDate = d;
    update();
  }

  bool get isSelectedToday => selectedDate == dateOnly(DateTime.now());

  String get assignmentsTitle => isSelectedToday
      ? "Today's Assignments"
      : 'Assignments · ${DispatchFormat.shortDate(selectedDate)}';

  List<CrewAssignment> get selectedAssignments => assignmentsOn(selectedDate);

  // ───────────── assigning ─────────────

  /// Opens the Assign Crew sheet for [crew] on [date] (defaults to the
  /// selected date). If the crew already has an assignment that day the
  /// sheet is pre-filled with it, and saving replaces it.
  Future<void> openAssignSheet(Crew crew, {DateTime? date}) async {
    final target = dateOnly(date ?? selectedDate);
    final existing = assignmentFor(crew.id, target);

    final result = await Get.bottomSheet<AssignCrewResult>(
      AssignCrewSheet(
        crew: crew,
        date: target,
        projects: projects,
        initialProjectId: existing?.projectId,
        initialNotes: existing?.notes ?? '',
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
    if (result == null) return;
    assignCrew(crew, target, result);
  }

  void assignCrew(Crew crew, DateTime date, AssignCrewResult result) {
    // TODO(api): PUT /dispatch/assignments  { crewId, projectId, date, notes }
    final day = dateOnly(date);
    final existing = assignmentFor(crew.id, day);
    if (existing != null) {
      assignments = [
        for (final a in assignments)
          if (a.id == existing.id)
            a.copyWith(projectId: result.projectId, notes: result.notes)
          else
            a,
      ];
    } else {
      assignments = [
        ...assignments,
        CrewAssignment(
          id: 'asg_${DateTime.now().microsecondsSinceEpoch}',
          crewId: crew.id,
          projectId: result.projectId,
          date: day,
          notes: result.notes,
        ),
      ];
    }
    _reindex();
    update();

    final project = projectById(result.projectId);
    Get.snackbar(
      'Crew assigned',
      '${crew.name} → ${project?.name ?? 'project'} · ${DispatchFormat.shortDate(day)}',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  // ───────────── crew capacity ─────────────

  static DateTime _mondayOf(DateTime d) =>
      DateTime(d.year, d.month, d.day - (d.weekday - DateTime.monday));

  /// Mon-Fri of the week being viewed on Crew Capacity.
  List<DateTime> get capacityDays => [
        for (var i = 0; i < 5; i++)
          DateTime(capacityWeekStart.year, capacityWeekStart.month,
              capacityWeekStart.day + i),
      ];

  String get capacityRangeLabel {
    final days = capacityDays;
    return DispatchFormat.range(days.first, days.last);
  }

  int bookedDays(Crew crew) =>
      capacityDays.where((d) => assignmentFor(crew.id, d) != null).length;

  void shiftCapacityWeek(int weeks) {
    capacityWeekStart = DateTime(capacityWeekStart.year, capacityWeekStart.month,
        capacityWeekStart.day + 7 * weeks);
    update();
  }

  void openCrewCapacity() {
    capacityWeekStart = _mondayOf(selectedDate);
    update();
    Get.to(() => const CrewCapacityView());
  }
}
