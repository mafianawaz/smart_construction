import 'package:flutter/material.dart';

import 'ai_agents_palette.dart';

/// Two-column row: muted label on the left, value (text or widget) on the
/// right. Used by the orchestrator card.
class AiKeyValueRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? valueWidget;

  const AiKeyValueRow({
    super.key,
    required this.label,
    this.value,
    this.valueWidget,
  }) : assert(value != null || valueWidget != null);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AiAgentsPalette.textMuted,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: valueWidget ??
              Text(
                value!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AiAgentsPalette.textPrimary,
                ),
              ),
        ),
      ],
    );
  }
}

/// Small orange-tinted text link, e.g. "→ Flags".
class AiLinkText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const AiLinkText({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AiAgentsPalette.primary,
        ),
      ),
    );
  }
}
