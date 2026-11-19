import 'package:flutter/material.dart';

import '../models/ai_agent_models.dart';
import 'ai_agents_palette.dart';

/// "Today's digest / Review queue (n) / Flags (n)" pill row.
/// Wraps onto a second line on narrow screens, like the reference.
class AiAgentsTabPills extends StatelessWidget {
  final AiAgentsTab selected;
  final int reviewCount;
  final int flagCount;
  final ValueChanged<AiAgentsTab> onChanged;

  const AiAgentsTabPills({
    super.key,
    required this.selected,
    required this.reviewCount,
    required this.flagCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _Pill(
          label: "Today's digest",
          selected: selected == AiAgentsTab.digest,
          onTap: () => onChanged(AiAgentsTab.digest),
        ),
        _Pill(
          label: 'Review queue ($reviewCount)',
          selected: selected == AiAgentsTab.reviewQueue,
          onTap: () => onChanged(AiAgentsTab.reviewQueue),
        ),
        _Pill(
          label: 'Flags ($flagCount)',
          selected: selected == AiAgentsTab.flags,
          onTap: () => onChanged(AiAgentsTab.flags),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? AiAgentsPalette.primary
              : AiAgentsPalette.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AiAgentsPalette.primary : AiAgentsPalette.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AiAgentsPalette.textPrimary,
          ),
        ),
      ),
    );
  }
}
