import 'package:flutter/material.dart';

import 'reports_palette.dart';

/// Dropdown-looking field showing the active report; tap opens the picker sheet.
class ReportSelectorField extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const ReportSelectorField({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: ReportsPalette.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ReportsPalette.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ReportsPalette.textDark,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                size: 20, color: ReportsPalette.textSecondary),
          ],
        ),
      ),
    );
  }
}
