import 'package:flutter/material.dart';
import '../../../../widgets/app_calendar/view.dart';


/// Legend used on a "Tasks" screen.
const List<CalendarLegendItem> kPriorityLegends = [
  CalendarLegendItem(label: 'Critical', color: Color(0xFFE53935)),
  CalendarLegendItem(label: 'High', color: Color(0xFFF2703C)),
  CalendarLegendItem(label: 'Medium', color: Color(0xFF3E7BFA)),
  CalendarLegendItem(label: 'Low', color: Color(0xFFA0A0A6)),
];

/// A completely different legend used on an "Attendance" screen — same
/// widget, zero changes needed.
const List<CalendarLegendItem> kAttendanceLegends = [
  CalendarLegendItem(label: 'Present', color: Color(0xFF2ECC71)),
  CalendarLegendItem(label: 'Absent', color: Color(0xFFE53935)),
  CalendarLegendItem(label: 'On leave', color: Color(0xFF9B59B6)),
];

/// Fake per-day data source, keyed as "y-m-d". In a real screen this would
/// come from your bloc/provider/repository for the currently focused month.
final Map<String, List<Color>> _mockDayData = {
  '2026-7-4': [const Color(0xFF2ECC71), const Color(0xFF9B59B6)],
  '2026-7-6': [const Color(0xFFF2703C)],
  '2026-7-8': [const Color(0xFF2ECC71)],
  '2026-7-11': [const Color(0xFF2ECC71), const Color(0xFF9B59B6)],
  '2026-7-13': [const Color(0xFFF2703C), const Color(0xFF3E7BFA)],
  '2026-7-18': [const Color(0xFF2ECC71)],
  '2026-7-20': [const Color(0xFFF2703C), const Color(0xFF2ECC71)],
  '2026-7-25': [const Color(0xFF2ECC71), const Color(0xFF9B59B6)],
  '2026-7-27': [const Color(0xFFF2703C)],
};

class CalendarDemoScreen extends StatefulWidget {
  const CalendarDemoScreen({super.key});

  @override
  State<CalendarDemoScreen> createState() => _CalendarDemoScreenState();
}

class _CalendarDemoScreenState extends State<CalendarDemoScreen> {
  DateTime? _selectedForTasks = DateTime(2026, 7, 14);
  DateTime? _selectedForDashboard;

  List<Color> _dayIndicators(DateTime day) {
    final key = '${day.year}-${day.month}-${day.day}';
    return _mockDayData[key] ?? const [];
  }

  @override
  Widget build(BuildContext context) {
    return AppCalendar(
      tag: 'tasks_calendar',
      variant: CalendarVariant.full,
      initialMonth: DateTime(2026, 7),
      selectedDate: _selectedForTasks,
      legends: kPriorityLegends,
      dayIndicatorsBuilder: _dayIndicators,
      onDateSelected: (d) => setState(() => _selectedForTasks = d),
      onMonthChanged: (month) {
        // e.g. Get.find<TasksController>().loadMonth(month);
      },
    );
  }
}