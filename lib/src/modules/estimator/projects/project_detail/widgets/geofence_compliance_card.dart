import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../models/geofence_models.dart';
import 'detail_card.dart';

class GeofenceComplianceCard extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  final List<ShiftGeofenceStatus> shifts;
  final bool isLoading;
  final void Function(DateTime start, DateTime end) onRangeChanged;

  const GeofenceComplianceCard({
    super.key,
    required this.start,
    required this.end,
    required this.shifts,
    required this.isLoading,
    required this.onRangeChanged,
  });

  Future<void> _pick(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? start : end,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;
    onRangeChanged(isStart ? picked : start, isStart ? end : picked);
  }

  Widget _dateField(BuildContext context, String label, DateTime value, bool isStart) {
    return Expanded(
      child: CustomTextField(
        heading: label,
        hintText: 'Pick a date',
        controller: TextEditingController(text: DateFormat('MM/dd/yyyy').format(value)),
        readOnly: true,
        onClick: () => _pick(context, isStart),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Geo-fence Compliance',
      subtitle: "Recent shift geo-fence statuses for this project",
      children: [
        Row(
          children: [
            _dateField(context, 'Start Date', start, true),
            const SizedBox(width: 10),
            _dateField(context, 'End Date', end, false),
          ],
        ),
        const SizedBox(height: 14),
        if (isLoading)
          const Center(child: Padding(
            padding: EdgeInsets.all(12),
            child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
          ))
        else if (shifts.isEmpty)
          Center(
            child: Text('No shifts found for this date range.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          )
        else
          for (final s in shifts)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(s.workerName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  Text(
                    s.wasInsideGeofence ? 'Inside' : 'Outside',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: s.wasInsideGeofence ? Colors.green : AppColors.redColor),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
