import 'package:flutter/material.dart';

import 'dd_palette.dart';

/// "Nothing needs you today" — no ranked items and no conflicts.
class DdEmptyState extends StatelessWidget {
  const DdEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: DdPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DdPalette.border),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 34,
            color: DdPalette.textMuted,
          ),
          SizedBox(height: 10),
          Text(
            'Nothing needs you today',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: DdPalette.textPrimary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'No flags or conflicts are waiting on you for this date.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: DdPalette.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
