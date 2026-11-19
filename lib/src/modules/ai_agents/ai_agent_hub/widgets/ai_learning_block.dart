import 'package:flutter/material.dart';

import '../models/ai_agent_models.dart';
import 'ai_agents_palette.dart';

/// "Learning:" block — bordered state box, then an optional thin progress bar
/// toward the data threshold, then an optional caption
/// (e.g. "1 of 3 consecutive closes" for a locked agent).
class AiLearningBlock extends StatelessWidget {
  final AgentLearning learning;

  const AiLearningBlock({super.key, required this.learning});

  @override
  Widget build(BuildContext context) {
    final progress = learning.progress;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Learning:',
          style: TextStyle(fontSize: 12, color: AiAgentsPalette.textMuted),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AiAgentsPalette.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AiAgentsPalette.border),
          ),
          child: Text(
            learning.label,
            style: const TextStyle(
              fontSize: 12,
              color: AiAgentsPalette.textSecondary,
            ),
          ),
        ),
        if (progress != null) ...[
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: AiAgentsPalette.border,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AiAgentsPalette.primary),
            ),
          ),
        ],
        if (learning.caption != null) ...[
          const SizedBox(height: 6),
          Text(
            learning.caption!,
            style: const TextStyle(
              fontSize: 12,
              color: AiAgentsPalette.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
