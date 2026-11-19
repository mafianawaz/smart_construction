import 'package:flutter/material.dart';

import 'ai_agents_palette.dart';

/// Bordered info banner with a leading info icon.
class AiInfoBanner extends StatelessWidget {
  final String message;

  const AiInfoBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AiAgentsPalette.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AiAgentsPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: 15,
            color: AiAgentsPalette.textPrimary,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.35,
              color: AiAgentsPalette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
