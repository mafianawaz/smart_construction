import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/schedule_event_model.dart';

/// Solid (non-dot) status badge used on schedule cards and the details
/// screen — visually distinct from `ComplianceStatusPill`'s dot-prefixed
/// style, matching the reference design's plain colored badge.
class ScheduleStatusBadge extends StatelessWidget {
  final ScheduleEventStatus status;

  const ScheduleStatusBadge({super.key, required this.status});

  Color get _color {
    switch (status) {
      case ScheduleEventStatus.upcoming:
        return AppColors.primaryOrange;
      case ScheduleEventStatus.inProgress:
        return AppColors.primaryOrangeDark;
      case ScheduleEventStatus.completed:
        return AppColors.statusChip;
    }
  }

  IconData get _icon {
    switch (status) {
      case ScheduleEventStatus.upcoming:
        return Icons.schedule;
      case ScheduleEventStatus.inProgress:
        return Icons.autorenew;
      case ScheduleEventStatus.completed:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
