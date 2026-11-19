import 'package:flutter/material.dart';

import 'ai_agents_palette.dart';

/// "Enabled" (outlined) / "Disabled" (muted fill) pill.
class AiStatusPill extends StatelessWidget {
  final bool enabled;

  const AiStatusPill({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: enabled ? AiAgentsPalette.surface : AiAgentsPalette.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AiAgentsPalette.border),
      ),
      child: Text(
        enabled ? 'Enabled' : 'Disabled',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AiAgentsPalette.textPrimary,
        ),
      ),
    );
  }
}
