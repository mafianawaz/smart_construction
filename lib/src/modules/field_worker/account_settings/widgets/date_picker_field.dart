import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';

/// A labeled, tappable field that opens [showDatePicker] and displays the
/// chosen date (or a placeholder). Screen-agnostic — any date input in the
/// app (certifications, scheduling, filters) can reuse this rather than
/// wiring `showDatePicker` by hand each time.
class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.heading,
    required this.value,
    required this.onChanged,
    this.hintText = 'Pick a date',
    this.firstDate,
    this.lastDate,
  });

  final String heading;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String hintText;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? now,
              firstDate: firstDate ?? DateTime(now.year - 10),
              lastDate: lastDate ?? DateTime(now.year + 10),
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value != null ? _format(value!) : hintText,
                  style: TextStyle(
                    fontSize: 14,
                    color: value != null ? AppColors.textDark : AppColors.textMuted,
                  ),
                ),
                Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _format(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
