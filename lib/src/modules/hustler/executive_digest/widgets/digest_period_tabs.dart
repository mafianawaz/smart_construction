import 'package:flutter/material.dart';

import '../models/executive_digest_models.dart';
import 'digest_palette.dart';

/// Daily / Weekly / Monthly pill row.
class DigestPeriodTabs extends StatelessWidget {
  const DigestPeriodTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final DigestPeriod selected;
  final ValueChanged<DigestPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final p in DigestPeriod.values) ...[
          _PeriodPill(
            label: p.label,
            selected: p == selected,
            onTap: () => onChanged(p),
          ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _PeriodPill extends StatelessWidget {
  const _PeriodPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? DigestPalette.primary : Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? DigestPalette.primary : DigestPalette.border,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : DigestPalette.text,
            ),
          ),
        ),
      ),
    );
  }
}
