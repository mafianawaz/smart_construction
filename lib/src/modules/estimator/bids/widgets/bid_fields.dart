import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_color.dart';

/// Labeled text input used by every wizard form.
class BidTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;

  const BidTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint ?? 'e.g.',
            isDense: true,
          ),
        ),
      ],
    );
  }
}

/// Tap-to-pick date field. Uses Flutter's `showDatePicker` for now;
/// swap the body of [_pick] for the app's `AppCalendar` bottom sheet
/// when wiring it in (flagged in NOTES_BIDS.md).
class BidDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  const BidDateField({
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
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _pick(context),
          borderRadius: BorderRadius.circular(10),
          child: InputDecorator(
            decoration:  InputDecoration(
              isDense: true,
              suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:  BorderSide(color: AppColors.fieldBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.fieldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryOrange),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
            ),
            child: Text(
              value == null ? 'Pick a date' : DateFormat('MMM d, y').format(value!),
              style: TextStyle(
                fontSize: 14,
                color: value == null ? Colors.grey.shade500 : AppColors.textDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Labeled dropdown (CRM Integration fields).
class BidDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;

  const BidDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          decoration: const InputDecoration(isDense: true),
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
          items: [
            for (final o in options) DropdownMenuItem(value: o, child: Text(o)),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
