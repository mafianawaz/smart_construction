import 'package:flutter/material.dart';

import 'equipment_palette.dart';

/// Centered-title app bar with a round back button, as in the reference.
/// Plain widget (not a PreferredSizeWidget), like `HomeAppBar`.
class EquipmentHeader extends StatelessWidget {
  const EquipmentHeader({
    super.key,
    this.title = 'Equipment & Tools',
    required this.onBack,
  });

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: EquipmentPalette.card,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            customBorder: const CircleBorder(),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: EquipmentPalette.border),
              ),
              child: const Icon(Icons.chevron_left,
                  size: 18, color: EquipmentPalette.textPrimary),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: EquipmentPalette.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 28), // balances the back button
        ],
      ),
    );
  }
}
