import 'package:flutter/material.dart';

import '../models/daily_digest_models.dart';
import 'dd_palette.dart';

/// "Top 10 of 37 — cap set per role..." plus the delivery line.
class DdSummaryBlock extends StatelessWidget {
  final int shownCount;
  final int totalCount;
  final int roleCap;
  final DigestDelivery delivery;

  const DdSummaryBlock({
    super.key,
    required this.shownCount,
    required this.totalCount,
    required this.roleCap,
    required this.delivery,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Top $shownCount of $totalCount',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: DdPalette.textPrimary,
                ),
              ),
              TextSpan(
                text: ' — cap set per role in AI Agents Settings ($roleCap). '
                    'Ranked by recoverable \$, ties broken by hierarchy.',
                style: const TextStyle(color: DdPalette.textSecondary),
              ),
            ],
          ),
          style: const TextStyle(fontSize: 12.5, height: 1.4),
        ),
        const SizedBox(height: 8),
        Text(
          'Delivery: in-app delivered ${delivery.inAppTime} · email sent '
          '${delivery.emailTime} to ${delivery.email}',
          style: const TextStyle(
            fontSize: 12,
            height: 1.4,
            color: DdPalette.textMuted,
          ),
        ),
      ],
    );
  }
}
