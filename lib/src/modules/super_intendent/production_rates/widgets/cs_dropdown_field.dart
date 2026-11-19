import 'package:flutter/material.dart';

import 'cs_palette.dart';

/// Labelled dropdown used inside the sheets (orange border on focus).
class CsDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final String hint;
  final String? errorText;
  final ValueChanged<String?> onChanged;

  const CsDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.errorText,
  });

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: c),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: CsPalette.text),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          style: const TextStyle(fontSize: 12, color: CsPalette.text),
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 12, color: CsPalette.hint),
          ),
          decoration: InputDecoration(
            isDense: true,
            errorText: errorText,
            filled: true,
            fillColor: CsPalette.fieldFill,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            border: _border(CsPalette.border),
            enabledBorder: _border(CsPalette.border),
            focusedBorder: _border(CsPalette.orange),
          ),
          items: [
            for (final i in items)
              DropdownMenuItem<String>(value: i, child: Text(i)),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
