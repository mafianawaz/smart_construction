import 'package:flutter/material.dart';

import 'crm_palette.dart';

/// Icon + title + light count badge on the left, optional action widgets on
/// the right ("CRM Tasks 0 · Open ⌄ · + New Task").
///
/// The left group shrinks (title ellipsizes) before the actions overflow.
class CrmSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final List<Widget> actions;

  const CrmSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(icon, size: 18, color: CrmPalette.text),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: CrmPalette.text,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: CrmPalette.chipFill,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: CrmPalette.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
        for (final action in actions) ...[
          const SizedBox(width: 8),
          action,
        ],
      ],
    );
  }
}
