import 'package:flutter/material.dart';

import 'crm_palette.dart';

InputDecoration _crmDecoration(String? hint) {
  OutlineInputBorder border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 13, color: CrmPalette.textFaint),
    filled: true,
    fillColor: CrmPalette.surface,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
    border: border(CrmPalette.border),
    enabledBorder: border(CrmPalette.border),
    focusedBorder: border(CrmPalette.orange),
    errorBorder: border(CrmPalette.danger),
    focusedErrorBorder: border(CrmPalette.danger),
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  const _FieldLabel(this.text, this.isRequired);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text.rich(
        TextSpan(
          text: text,
          children: [
            if (isRequired)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: CrmPalette.danger),
              ),
          ],
        ),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: CrmPalette.text,
        ),
      ),
    );
  }
}

/// Labelled text field used by the organization and opportunity forms.
class CrmTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool isRequired;
  final String? Function(String?)? validator;

  const CrmTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.isRequired = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label, isRequired),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13, color: CrmPalette.text),
          decoration: _crmDecoration(hint),
          validator: validator ??
              (isRequired
                  ? (v) => (v == null || v.trim().isEmpty)
                      ? '$label is required'
                      : null
                  : null),
        ),
      ],
    );
  }
}

/// Labelled dropdown. [items] may contain a `null` entry via [nullLabel]
/// (e.g. "Unassigned"); when [nullLabel] is null the field is non-nullable.
class CrmDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final String? nullLabel;
  final bool isRequired;

  const CrmDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
    this.hint,
    this.nullLabel,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label, isRequired),
        DropdownButtonFormField<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          style: const TextStyle(fontSize: 13, color: CrmPalette.text),
          decoration: _crmDecoration(hint),
          items: [
            if (nullLabel != null)
              DropdownMenuItem<T>(value: null, child: Text(nullLabel!)),
            for (final item in items)
              DropdownMenuItem<T>(value: item, child: Text(labelOf(item))),
          ],
          onChanged: onChanged,
          validator: isRequired
              ? (v) => v == null ? 'Please select ${label.toLowerCase()}' : null
              : null,
        ),
      ],
    );
  }
}

/// Full-width orange button for form footers.
class CrmPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CrmPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: CrmPalette.orange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
