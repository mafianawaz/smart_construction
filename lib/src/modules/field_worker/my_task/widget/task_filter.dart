import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';

/// A pill-shaped button that looks like a dropdown (label + caret).
/// Wire [onTap] to open a bottom sheet / menu with the actual options —
/// this widget only owns the visual affordance, not the option list.
class TaskFilterDropdown extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const TaskFilterDropdown({
    super.key,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryOrange.withOpacity(0.1) : const Color(0xFFF6F7F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.primaryOrange : AppColors.textDark,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: isActive ? AppColors.primaryOrange : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}