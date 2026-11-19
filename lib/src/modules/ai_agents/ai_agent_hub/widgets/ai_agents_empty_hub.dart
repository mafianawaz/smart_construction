import 'package:flutter/material.dart';

import 'ai_agents_palette.dart';

/// Empty hub shown when no agents are enabled: explanation + an
/// "Enable agents" CTA that opens AI Agents Settings (G-06).
class AiAgentsEmptyHub extends StatelessWidget {
  final VoidCallback onEnableTap;

  const AiAgentsEmptyHub({super.key, required this.onEnableTap});

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
          const Icon(
            Icons.smart_toy_outlined,
            size: 36,
            color: AiAgentsPalette.textMuted,
          ),
          const SizedBox(height: 12),
          const Text(
            'No agents enabled',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AiAgentsPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Enable an agent to start receiving a daily digest, flags and '
            'items to review.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: AiAgentsPalette.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: onEnableTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AiAgentsPalette.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Enable agents',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
