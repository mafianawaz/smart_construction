import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';

/// A pill-shaped dropdown filter. Not confirmed against an existing
/// shared widget — built new for this module and flagged in
/// NOTES_PRICING.md as a candidate to extract/reconcile if something
/// equivalent already exists (e.g. from the Task module's filter chips).
class PricingDropdownPill extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  /// Filled orange (matches the "All Categories" pill) vs. an outlined
  /// neutral pill (matches "All Status").
  final bool filled;

  const PricingDropdownPill({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = filled ? Colors.white : AppColors.textMuted;
    return PopupMenuButton<String>(
      color: Colors.white,
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final option in options)
          PopupMenuItem(value: option, child: Text(option)),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: filled ? AppColors.primaryOrange : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                color: foreground,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 16, color: foreground),
          ],
        ),
      ),
    );
  }
}
