import 'package:flutter/material.dart';

import '../models/ai_agent_models.dart';
import 'ai_agents_palette.dart';
import 'ai_flag_chip.dart';
import 'ai_learning_block.dart';
import 'ai_status_pill.dart';

/// One agent card: title, status pill, purpose, users, learning progress,
/// run times, open flags and pending reviews. A disabled agent swaps the
/// run times for "—" and gains an "Enable in AI Agents Settings" button.
class AgentCard extends StatelessWidget {
  final AiAgentModel agent;
  final VoidCallback onEnableTap;

  const AgentCard({
    super.key,
    required this.agent,
    required this.onEnableTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AiAgentsPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AiAgentsPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            agent.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AiAgentsPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          AiStatusPill(enabled: agent.enabled),
          const SizedBox(height: 10),
          _LabeledText(label: 'Purpose', text: agent.purpose),
          const SizedBox(height: 6),
          _LabeledText(label: 'Users', text: agent.users),
          const SizedBox(height: 10),
          AiLearningBlock(learning: agent.learning),
          const SizedBox(height: 10),
          Text(
            'Last run ${agent.lastRun ?? '—'} · next run ${agent.nextRun ?? '—'}',
            style: const TextStyle(
              fontSize: 12,
              color: AiAgentsPalette.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          AiOpenFlagsRow(flags: agent.flags),
          const SizedBox(height: 8),
          Text(
            'Pending reviews: ${agent.pendingReviews}',
            style: const TextStyle(
              fontSize: 12,
              color: AiAgentsPalette.textMuted,
            ),
          ),
          if (!agent.enabled) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: OutlinedButton(
                onPressed: onEnableTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AiAgentsPalette.textPrimary,
                  side: const BorderSide(color: AiAgentsPalette.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Enable in AI Agents Settings',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LabeledText extends StatelessWidget {
  final String label;
  final String text;

  const _LabeledText({required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label: $text',
      style: const TextStyle(
        fontSize: 12,
        height: 1.35,
        color: AiAgentsPalette.textMuted,
      ),
    );
  }
}
