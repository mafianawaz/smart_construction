import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';
import '../../../../utils/app_color.dart';
import '../models/time_tracking_models.dart';
import 'shift_history_tile.dart';

/// Composes the "Shift History" header + list/empty-state, reusing the
/// shared EmptyState widget for the "No new project assignments" case
/// shown on the fresh Clock In screen.
class ShiftHistorySection extends StatelessWidget {
  final List<ShiftEntry> entries;
  final VoidCallback? onViewAll;
  final RequestOvertimeCallback? onRequestOvertime;

  const ShiftHistorySection({
    super.key,
    required this.entries,
    this.onViewAll,
    this.onRequestOvertime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Shift History', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            if (entries.isNotEmpty)
              GestureDetector(
                onTap: onViewAll,
                child: Row(
                  children: [
                    Text(
                      'View all',
                      style: TextStyle(color: AppColors.primaryOrange, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.chevron_right, size: 16, color: AppColors.primaryOrange),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (entries.isEmpty)
          const AppEmptyState(
            icon: Icons.event_note_outlined,
            message: 'No new project assignments',
          )
        else
          ...entries.map((e) => ShiftHistoryTile(shift: e, onRequestOvertime: onRequestOvertime)),
      ],
    );
  }
}
