import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'equipment_palette.dart';

OutlineInputBorder _border(Color color, {double width = 1}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: color, width: width),
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: SuperInEquipmentPalette.textDark,
        ),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  final String text;

  const _ErrorText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 2),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: SuperInEquipmentPalette.red),
      ),
    );
  }
}

/// Labelled text field in the reference style (light fill, grey border,
/// orange when focused). Pass `prefix: '\$'` for money fields.
class EquipmentTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? error;
  final String? prefix;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int minLines;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const EquipmentTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.error,
    this.prefix,
    this.keyboardType,
    this.inputFormatters,
    this.minLines = 1,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          minLines: minLines,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 13,
            color: SuperInEquipmentPalette.textDark,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 13,
              color: SuperInEquipmentPalette.textFaint,
            ),
            prefixText: prefix,
            prefixStyle: const TextStyle(
              fontSize: 13,
              color: SuperInEquipmentPalette.textDark,
            ),
            filled: true,
            fillColor: SuperInEquipmentPalette.fieldFill,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            enabledBorder: _border(
              hasError ? SuperInEquipmentPalette.red : SuperInEquipmentPalette.border,
            ),
            focusedBorder: _border(
              hasError ? SuperInEquipmentPalette.red : SuperInEquipmentPalette.orange,
              width: 1.4,
            ),
          ),
        ),
        if (hasError) _ErrorText(error!),
      ],
    );
  }
}

/// Labelled dropdown styled like [EquipmentTextField].
class EquipmentDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final String? error;

  const EquipmentDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: SuperInEquipmentPalette.fieldFill,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasError ? SuperInEquipmentPalette.red : SuperInEquipmentPalette.border,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              dropdownColor: Colors.white,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: SuperInEquipmentPalette.textMuted,
              ),
              hint: Text(
                hint,
                style: const TextStyle(
                  fontSize: 13,
                  color: SuperInEquipmentPalette.textFaint,
                ),
              ),
              style: const TextStyle(
                fontSize: 13,
                color: SuperInEquipmentPalette.textDark,
              ),
              items: [
                for (final item in items)
                  DropdownMenuItem<T>(
                    value: item,
                    child: Text(itemLabel(item)),
                  ),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
        if (hasError) _ErrorText(error!),
      ],
    );
  }
}

/// Read-only date field that calls [onTap] (the view opens the date picker).
class EquipmentDateField extends StatelessWidget {
  final String label;
  final String hint;
  final String? valueText;
  final VoidCallback onTap;

  const EquipmentDateField({
    super.key,
    required this.label,
    required this.hint,
    required this.valueText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = valueText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 46,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: SuperInEquipmentPalette.fieldFill,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: SuperInEquipmentPalette.border),
            ),
            child: Text(
              hasValue ? valueText! : hint,
              style: TextStyle(
                fontSize: 13,
                color: hasValue
                    ? SuperInEquipmentPalette.textDark
                    : SuperInEquipmentPalette.textFaint,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bold section heading used between groups of fields.
class EquipmentSectionTitle extends StatelessWidget {
  final String text;

  const EquipmentSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: SuperInEquipmentPalette.textDark,
      ),
    );
  }
}
