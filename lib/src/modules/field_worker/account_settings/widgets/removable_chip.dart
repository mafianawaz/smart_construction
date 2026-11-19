import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';


/// A pill-shaped chip with a trailing remove ("x") button. Screen-agnostic —
/// used for skills/equipment tags here, but fits any "added items" list
/// elsewhere in the app.
class RemovableChip extends StatelessWidget {
  const RemovableChip({super.key, required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 16, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
