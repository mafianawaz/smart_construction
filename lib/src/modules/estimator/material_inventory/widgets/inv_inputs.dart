import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'inv_style.dart';

/// Digits and one decimal point; optional leading minus for signed fields.
List<TextInputFormatter> invNumberFormatters({bool signed = false}) => [
      FilteringTextInputFormatter.allow(
        RegExp(signed ? r'[0-9.\-]' : r'[0-9.]'),
      ),
    ];

List<TextInputFormatter> invDigitsOnly() =>
    [FilteringTextInputFormatter.digitsOnly];

class _InvLabel extends StatelessWidget {
  final String text;
  final bool required;
  final Color? color;

  const _InvLabel({required this.text, required this.required, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        required ? '$text *' : text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color ?? Colors.black87,
        ),
      ),
    );
  }
}

class _InvError extends StatelessWidget {
  final String? text;

  const _InvError(this.text);

  @override
  Widget build(BuildContext context) {
    if (text == null) return const SizedBox(height: 10);
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 6),
      child: Text(
        text!,
        style: const TextStyle(fontSize: 11, color: InvStyle.danger),
      ),
    );
  }
}

/// Labelled single/multi-line text field in the Materials Inventory style.
class InvField extends StatelessWidget {
  final String? label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final String? errorText;
  final bool required;
  final Color? labelColor;
  final Widget? prefix;
  final Widget? suffix;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  const InvField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.errorText,
    this.required = false,
    this.labelColor,
    this.prefix,
    this.suffix,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
  });

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: c),
      );

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          _InvLabel(text: label!, required: required, color: labelColor),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          minLines: maxLines,
          autofocus: autofocus,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: textInputAction,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: InvStyle.muted),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: prefix,
            suffixIcon: suffix,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: _border(hasError ? InvStyle.danger : InvStyle.border),
            focusedBorder: _border(hasError ? InvStyle.danger : InvStyle.orange),
            border: _border(InvStyle.border),
          ),
        ),
        _InvError(errorText),
      ],
    );
  }
}

class InvOption<T> {
  final T value;
  final String label;

  const InvOption(this.value, this.label);
}

/// Labelled dropdown. Built on [DropdownButton] (not the form-field variant)
/// so it has no deprecated `value:` parameter and renders the same in every
/// Flutter version. [value] must be null or one of [options].
class InvDropdown<T> extends StatelessWidget {
  final String? label;
  final String hint;
  final T? value;
  final List<InvOption<T>> options;
  final ValueChanged<T?> onChanged;
  final String? errorText;
  final bool required;
  final Color? labelColor;

  const InvDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.options,
    required this.onChanged,
    this.label,
    this.errorText,
    this.required = false,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final safeValue = options.any((o) => o.value == value) ? value : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          _InvLabel(text: label!, required: required, color: labelColor),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasError ? InvStyle.danger : InvStyle.border,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: safeValue,
              isExpanded: true,
              borderRadius: BorderRadius.circular(8),
              icon: Icon(Icons.keyboard_arrow_down,
                  size: 20, color: InvStyle.muted),
              hint: Text(
                hint,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: InvStyle.muted),
              ),
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              items: [
                for (final o in options)
                  DropdownMenuItem<T>(
                    value: o.value,
                    child: Text(o.label, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
        _InvError(errorText),
      ],
    );
  }
}
