import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';

/// Local style tokens (shared `AppColors.primaryOrange` / `textMuted` are
/// confirmed; the rest are local until the shared theme is reconciled).
class ProcStyle {
  static Color get orange => AppColors.primaryOrange;
  static Color get muted => AppColors.textMuted;
  static const Color border = Color(0xFFE5E7EB);
  static const Color panel = Color(0xFFF5F6F8);
  static const Color danger = Color(0xFFDC2626);
}

List<TextInputFormatter> procDecimalFormatters() => [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    ];

List<TextInputFormatter> procDigitsFormatters() =>
    [FilteringTextInputFormatter.digitsOnly];

class _Label extends StatelessWidget {
  final String text;
  final bool required;

  const _Label(this.text, this.required);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(
          required ? '$text *' : text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      );
}

class _ErrorLine extends StatelessWidget {
  final String? text;

  const _ErrorLine(this.text);

  @override
  Widget build(BuildContext context) {
    if (text == null) return const SizedBox(height: 10);
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 6),
      child: Text(text!,
          style: const TextStyle(fontSize: 11, color: ProcStyle.danger)),
    );
  }
}

OutlineInputBorder _border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: c),
    );

class ProcField extends StatelessWidget {
  final String? label;
  final String hint;
  final TextEditingController controller;
  final bool required;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final Widget? prefix;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  const ProcField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.required = false,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.errorText,
    this.prefix,
    this.onChanged,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final err = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) _Label(label!, required),
        TextField(
          controller: controller,
          maxLines: maxLines,
          minLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          textInputAction: textInputAction,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: ProcStyle.muted),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: prefix,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: _border(err ? ProcStyle.danger : ProcStyle.border),
            focusedBorder: _border(err ? ProcStyle.danger : ProcStyle.orange),
            border: _border(ProcStyle.border),
          ),
        ),
        _ErrorLine(errorText),
      ],
    );
  }
}

/// Dropdown built on [DropdownButton]; [value] must be null or in [options].
class ProcDropdown extends StatelessWidget {
  final String? label;
  final String hint;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final bool required;
  final String? errorText;

  /// Orange outline (Figma highlights the Project field on the PR form).
  final bool highlight;

  const ProcDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.options,
    required this.onChanged,
    this.label,
    this.required = false,
    this.errorText,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final err = errorText != null;
    final safe = options.contains(value) ? value : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) _Label(label!, required),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: err
                    ? ProcStyle.danger
                    : (highlight ? ProcStyle.orange : ProcStyle.border)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: safe,
              isExpanded: true,
              borderRadius: BorderRadius.circular(8),
              icon: Icon(Icons.keyboard_arrow_down,
                  size: 20, color: ProcStyle.muted),
              hint: Text(hint,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: ProcStyle.muted)),
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              items: [
                for (final o in options)
                  DropdownMenuItem<String>(
                    value: o,
                    child: Text(o, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
        _ErrorLine(errorText),
      ],
    );
  }
}

/// Date field that opens the date picker (read-only text look).
class ProcDateField extends StatelessWidget {
  final String label;
  final String text; // empty = show hint
  final VoidCallback onTap;

  const ProcDateField({
    super.key,
    required this.label,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label, false),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ProcStyle.border),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 16, color: ProcStyle.muted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text.isEmpty ? 'mm/dd/yyyy' : text,
                    style: TextStyle(
                      fontSize: 13,
                      color: text.isEmpty ? ProcStyle.muted : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class ProcButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool fullWidth;
  final bool compact; // small pill (Submit / + Add Item)
  final bool outlined; // orange outline (+ New Request / + Add Item)

  const ProcButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fullWidth = false,
    this.compact = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(compact ? 18 : 10);
    final h = compact ? 34.0 : 48.0;
    final child = Text(
      text,
      style: TextStyle(
        fontSize: compact ? 12 : 14,
        fontWeight: FontWeight.w600,
        color: outlined ? ProcStyle.orange : Colors.white,
      ),
    );
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: h,
      child: outlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: ProcStyle.orange),
                padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 18),
                shape: RoundedRectangleBorder(borderRadius: radius),
              ),
              child: child,
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: ProcStyle.orange,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 18),
                shape: RoundedRectangleBorder(borderRadius: radius),
              ),
              child: child,
            ),
    );
  }
}

/// Opens the system date picker. Returns null when dismissed.
Future<DateTime?> pickProcDate(DateTime? initial) {
  final ctx = Get.context;
  if (ctx == null) return Future.value(null);
  final now = DateTime.now();
  return showDatePicker(
    context: ctx,
    initialDate: initial ?? now,
    firstDate: DateTime(now.year - 5),
    lastDate: DateTime(now.year + 5),
  );
}
