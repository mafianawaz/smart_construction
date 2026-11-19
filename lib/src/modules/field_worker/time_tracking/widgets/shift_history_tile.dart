import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../../my_task/widget/pill_chip.dart';
import '../models/time_tracking_models.dart';

typedef RequestOvertimeCallback = void Function(ShiftEntry shift);

/// Single row in Shift History. Renders both the "0h 0m" empty-total
/// variant and the completed-with-overtime variant from the same
/// widget — branching lives in the ShiftEntry data, not in this widget.
class ShiftHistoryTile extends StatelessWidget {
  final ShiftEntry shift;
  final RequestOvertimeCallback? onRequestOvertime;

  const ShiftHistoryTile({super.key, required this.shift, this.onRequestOvertime});

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  String _formatDuration(Duration d) => '${d.inHours}h ${d.inMinutes % 60}m';

  String _formatDate(DateTime d) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${weekdays[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _formatDate(shift.date),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              SizedBox(width: 6),
              Text(shift.status.label, style: TextStyle(fontSize: 12,),)
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  shift.projectName,
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  shift.projectCode,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.access_time, size: 13, color: AppColors.textMuted),
              const SizedBox(width: 2),
              Text(
                '${_formatTime(shift.clockIn)}${shift.clockOut != null ? ' - ${_formatTime(shift.clockOut!)}' : ''}',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${shift.total != null ? _formatDuration(shift.total!) : '--'}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              if (shift.overtimeExcess != null)
                Text(
                  '+${_formatDuration(shift.overtimeExcess!)} OT',
                  style: TextStyle(fontSize: 12, color: AppColors.textDark),
                ),
            ],
          ),
          if (shift.canRequestOvertime) ...[
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => onRequestOvertime?.call(shift),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Request OT', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
