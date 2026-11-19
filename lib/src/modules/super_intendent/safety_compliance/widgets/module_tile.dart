import 'package:flutter/material.dart';

import '../models/safety_models.dart';
import 'safety_common_widgets.dart';
import 'safety_palette.dart';

/// Row card on the Modules tab: purple icon, title + arrow, description, chips.
class SafetyModuleTile extends StatelessWidget {
  final SafetyModuleItem module;
  final VoidCallback onTap;

  const SafetyModuleTile({
    super.key,
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafetyCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: SafetyPalette.purpleSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(module.icon, size: 18, color: SafetyPalette.purple),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        module.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: SafetyPalette.textDark,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      size: 15,
                      color: SafetyPalette.textFaint,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  module.description,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.35,
                    color: SafetyPalette.textMuted,
                  ),
                ),
                if (module.chips.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final chip in module.chips)
                        SafetyTonePill(
                          label: chip.label,
                          tone: chip.tone,
                          icon: chip.icon,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
