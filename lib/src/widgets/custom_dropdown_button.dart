import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String hintText;
  final Function(T?) onChanged;
  final String Function(T) itemLabel;
  final String? heading;
  final bool enabled;
  final bool isMuted;
  final double fontSize;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.itemLabel,
    this.hintText = "Select option",
    this.heading,
    this.enabled = true,
    this.isMuted = false,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((heading ?? '').isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: isMuted ?
            Text(
              heading!.toUpperCase(),
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ):
            Text(
              heading!,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark
              ),
            ),
          ),

        DropdownButtonFormField<T>(
          dropdownColor: theme.cardColor,
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabel(item),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: theme.textTheme.bodyLarge?.color ??
                      Colors.grey,
                ),
              ),
            );
          }).toList(),

          onChanged: enabled ? onChanged : null,

          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: isDark
                ? theme.cardColor
                : Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 15,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: isDark
                    ? theme.dividerColor
                    : Colors.grey.shade200,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: isDark
                    ? theme.dividerColor
                    : Colors.grey.shade200,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: AppColors.primaryOrange,
              ),
            ),

            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: isDark
                    ? theme.dividerColor
                    : Colors.grey.shade200,
              ),
            ),
          ),

          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}