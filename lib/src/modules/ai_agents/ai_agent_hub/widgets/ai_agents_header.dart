import 'package:flutter/material.dart';

import 'ai_agents_palette.dart';

/// Breadcrumb ("Home › AI Agents") plus the screen title.
class AiAgentsHeader extends StatelessWidget {
  final VoidCallback? onHomeTap;

  const AiAgentsHeader({super.key, this.onHomeTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onHomeTap,
              behavior: HitTestBehavior.opaque,
              child: const Text(
                'Home',
                style: TextStyle(
                  fontSize: 12,
                  color: AiAgentsPalette.textMuted,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Icons.chevron_right,
                size: 14,
                color: AiAgentsPalette.textMuted,
              ),
            ),
            const Text(
              'AI Agents',
              style: TextStyle(
                fontSize: 12,
                color: AiAgentsPalette.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'AI Agents',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AiAgentsPalette.textPrimary,
          ),
        ),
      ],
    );
  }
}
