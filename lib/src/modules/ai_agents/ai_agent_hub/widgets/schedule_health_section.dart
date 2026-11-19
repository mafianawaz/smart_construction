import 'package:flutter/material.dart';

import '../models/ai_agent_models.dart';
import 'ai_agents_palette.dart';

/// "Schedule health per project" — one bordered row per project with a
/// "Current" chip, or a "Stale" chip plus days since the last update.
class ScheduleHealthSection extends StatelessWidget {
  final List<ProjectScheduleHealth> projects;

  const ScheduleHealthSection({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Schedule health per project',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AiAgentsPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Projects',
          style: TextStyle(fontSize: 12, color: AiAgentsPalette.textMuted),
        ),
        const SizedBox(height: 8),
        for (final p in projects)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ProjectRow(project: p),
          ),
      ],
    );
  }
}

class _ProjectRow extends StatelessWidget {
  final ProjectScheduleHealth project;

  const _ProjectRow({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: AiAgentsPalette.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AiAgentsPalette.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              project.projectName,
              style: const TextStyle(
                fontSize: 13,
                color: AiAgentsPalette.textPrimary,
              ),
            ),
          ),
          if (project.isStale) ...[
            const _HealthChip(
              label: 'Stale',
              background: AiAgentsPalette.staleBg,
              foreground: AiAgentsPalette.staleFg,
            ),
            const SizedBox(width: 8),
            Text(
              '${project.staleDays} d',
              style: const TextStyle(
                fontSize: 12,
                color: AiAgentsPalette.textSecondary,
              ),
            ),
          ] else
            const _HealthChip(
              label: 'Current',
              background: AiAgentsPalette.currentBg,
              foreground: AiAgentsPalette.currentFg,
            ),
        ],
      ),
    );
  }
}

class _HealthChip extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const _HealthChip({
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: foreground,
        ),
      ),
    );
  }
}
