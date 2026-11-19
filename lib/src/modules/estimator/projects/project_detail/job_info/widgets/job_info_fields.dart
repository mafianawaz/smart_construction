import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../../../../../utils/app_color.dart';

const jobInfoFieldGap = SizedBox(height: 12);

/// Tap-to-pick date field, built on the shared `CustomTextField` (same
/// as every plain text field on this screen) so it matches visually —
/// the field itself is read-only and the tap opens `showDatePicker`.
/// `readOnly`/`onTap` on `CustomTextField` are assumed to exist and
/// behave like Flutter's `TextField`; flagged in NOTES_PROJECTS.md in
/// case the real widget doesn't expose them.
class JobInfoDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  const JobInfoDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: DateTime(now.year - 3),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      heading: label,
      hintText: 'Pick a date',
      controller: TextEditingController(
        text: value == null ? '' : DateFormat('MMM d, y').format(value!),
      ),
      readOnly: true,
      onClick: () => _pick(context),
    );
  }
}

class JobInfoCheckboxRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const JobInfoCheckboxRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                // checkColor: Colors.white,
                activeColor: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
