import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'safety_palette.dart';

/// Back arrow + title + subtitle shared by every tab of the hub.
class SafetyHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  const SafetyHeader({
    super.key,
    this.title = 'Safety & Compliance',
    this.subtitle =
        'Unified hub for incidents, observations, inspections, training, and OSHA reporting.',
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onBack ?? () => Get.back(),
            customBorder: const CircleBorder(),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: SafetyPalette.border),
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 18,
                color: SafetyPalette.textDark,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: SafetyPalette.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.35,
                    color: SafetyPalette.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
