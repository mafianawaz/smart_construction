import 'package:flutter/material.dart';

import 'ai_agents_palette.dart';

/// Placeholder body for the Review queue and Flags tabs (no reference
/// design yet). Shows the live count so the tab pills and the orchestrator
/// links still land somewhere meaningful.
class AiTabPlaceholder extends StatelessWidget {
  final String title;
  final String message;

  const AiTabPlaceholder({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: AiAgentsPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AiAgentsPalette.border),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AiAgentsPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: AiAgentsPalette.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
