import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/modules/field_worker/my_task/widget/pill_chip.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../../../models/project_enums.dart';
import '../../../models/schedule_model.dart';

const double _dayWidth = 12; // px per day on the scrollable timeline
const double _rowHeight = 36;
const double _barHeight = 18;
const double _axisHeight = 24;
const double _nameColumnWidth = 140;

/// The Gantt Chart card: legend + Export/Send To, a FIXED task-name
/// column on the left, and a horizontally scrollable timeline (week
/// ticks + proportional bars) on the right. Both columns use the same
/// fixed row height so names and bars always line up.
///
/// Task positions are the data's own `startOffsetDays` — a simplified
/// sequential layout rather than true critical-path-method scheduling,
/// flagged in NOTES_PROJECTS.md.
class GanttChartCard extends StatelessWidget {
  final List<GanttTaskModel> tasks;

  /// Calendar date of day 0 on the timeline (labels the week ticks).
  final DateTime startDate;
  final VoidCallback onExport;
  final VoidCallback onSend;

  const GanttChartCard({
    super.key,
    required this.tasks,
    required this.startDate,
    required this.onExport,
    required this.onSend,
  });

  int get _timelineDays => tasks.isEmpty
      ? 0
      : tasks.map((t) => t.endOffsetDays).reduce((a, b) => a > b ? a : b);

  @override
  Widget build(BuildContext context) {
    final days = _timelineDays;
    final chartWidth = days * _dayWidth + 24; // trailing breathing room
    final criticalCount = tasks.where((t) => t.isCriticalPath).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tasks',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 10,
                  runSpacing: 4,
                  children: [for (final kind in GanttBarKind.values) _LegendItem(kind: kind)],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${tasks.length} tasks · $days days · $criticalCount on critical path',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onExport,
                child: WhitePillChip(
                  label: 'Export', color: Colors.grey.shade400,filled: true,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onSend,
                child: WhitePillChip(
                  label: 'Send To', color: Colors.grey.shade400,filled: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fixed names column.
              SizedBox(
                width: _nameColumnWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: _axisHeight),
                    for (final task in tasks) _NameCell(task: task),
                  ],
                ),
              ),
              // Scrollable timeline.
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: chartWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DayAxis(days: days, width: chartWidth, startDate: startDate),
                        for (final task in tasks)
                          _BarRow(task: task, days: days, width: chartWidth),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final GanttBarKind kind;
  const _LegendItem({required this.kind});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: kind.color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(kind.label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
      ],
    );
  }
}

class _NameCell extends StatelessWidget {
  final GanttTaskModel task;
  const _NameCell({required this.task});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _rowHeight,
      child: Row(
        children: [
          Expanded(
            child: Text(
              task.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, height: 1.15),
            ),
          ),
          if (task.isCriticalPath) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                  color: Color(0xFFB81E1E), borderRadius: BorderRadius.circular(4)),
              child: const Text('CP',
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
            const SizedBox(width: 6),
          ] else
            const SizedBox(width: 6),
        ],
      ),
    );
  }
}

/// Week ticks along the top, labelled with the calendar date.
class _DayAxis extends StatelessWidget {
  final int days;
  final double width;
  final DateTime startDate;
  const _DayAxis({required this.days, required this.width, required this.startDate});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d');
    return SizedBox(
      width: width,
      height: _axisHeight,
      child: Stack(
        children: [
          for (int d = 0; d <= days; d += 7)
            Positioned(
              left: d * _dayWidth,
              top: 4,
              child: Text(
                fmt.format(startDate.add(Duration(days: d))),
                style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
              ),
            ),
        ],
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  final GanttTaskModel task;
  final int days;
  final double width;
  const _BarRow({required this.task, required this.days, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: _rowHeight,
      child: Stack(
        children: [
          // Week gridlines.
          for (int d = 0; d <= days; d += 7)
            Positioned(
              left: d * _dayWidth,
              top: 0,
              bottom: 0,
              child: Container(width: 1, color: Colors.grey.shade100),
            ),
          Positioned(
            left: task.startOffsetDays * _dayWidth,
            top: (_rowHeight - _barHeight) / 2,
            child: Container(
              width: task.durationDays * _dayWidth,
              height: _barHeight,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: task.barKind.color, borderRadius: BorderRadius.circular(4)),
              child: Text(
                '${task.durationDays}d',
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
