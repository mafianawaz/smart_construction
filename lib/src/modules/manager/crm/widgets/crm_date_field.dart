import 'package:flutter/material.dart';

import 'crm_activity_style.dart';
import 'crm_palette.dart';

/// Tap-to-pick date field showing "mm/dd/yyyy" (the reference's date inputs).
///
/// Not a `FormField`: the dates in this module are all optional. A set value
/// can be cleared with the × button.
class CrmDateField extends StatelessWidget {
  /// Optional label above the field; the compact filter variant has none.
  final String? label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String hint;

  /// Title shown at the top of the picker dialog ("From date").
  final String? pickerHelp;
  final bool compact;

  const CrmDateField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.firstDate,
    this.lastDate,
    this.hint = 'mm/dd/yyyy',
    this.pickerHelp,
    this.compact = false,
  });

  Future<void> _pick(BuildContext context) async {
    final first = firstDate ?? DateTime(2000);
    final last = lastDate ?? DateTime(2100);
    var initial = value ?? DateTime.now();
    if (initial.isBefore(first)) initial = first;
    if (initial.isAfter(last)) initial = last;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      helpText: pickerHelp,
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final current = value;
    final field = InkWell(
      onTap: () => _pick(context),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: compact ? 40 : 48,
        padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 12),
        decoration: BoxDecoration(
          color: CrmPalette.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: CrmPalette.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                current == null ? hint : crmSlashDate(current),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: compact ? 12 : 13,
                  color:
                      current == null ? CrmPalette.textFaint : CrmPalette.text,
                ),
              ),
            ),
            if (current != null)
              GestureDetector(
                onTap: () => onChanged(null),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, size: 16, color: CrmPalette.textMuted),
                ),
              )
            else
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: CrmPalette.textMuted,
              ),
          ],
        ),
      ),
    );

    final text = label;
    if (text == null) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: CrmPalette.text,
            ),
          ),
        ),
        field,
      ],
    );
  }
}
