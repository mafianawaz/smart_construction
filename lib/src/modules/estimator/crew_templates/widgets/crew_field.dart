import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../utils/app_color.dart';
import 'crew_palette.dart';

/// Labelled text field with the design's rounded border and orange focus
/// ring. Local stand-in for the shared `CustomTextField` (same
/// heading/hintText/controller/keyboardType/maxLines surface, plus
/// readOnly/onTap/suffixIcon/errorText); swap the body once its path is known.
class CrewField extends StatelessWidget {
  final String heading;
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;

  const CrewField({
    super.key,
    required this.heading,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.errorText,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
  });

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: CrewPalette.ink,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          style: const TextStyle(fontSize: 12, color: CrewPalette.ink),
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 12, color: AppColors.textMuted),
            errorText: errorText,
            errorStyle: const TextStyle(fontSize: 10),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: _border(CrewPalette.cardBorder),
            focusedBorder: _border(AppColors.primaryOrange),
            errorBorder: _border(CrewPalette.danger),
            focusedErrorBorder: _border(CrewPalette.danger),
          ),
        ),
      ],
    );
  }
}
