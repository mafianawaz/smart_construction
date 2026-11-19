import 'package:flutter/material.dart';

import '../models/executive_digest_models.dart';
import 'digest_palette.dart';
import 'digest_primitives.dart';
import 'digest_report_body.dart';

/// "Portfolio Digest — cross-organization AI summary" card.
///
/// Once a portfolio digest exists for the selected period it renders below the
/// button using the same [DigestReportBody] as organization cards. (The
/// reference only shows the pre-generation state; the generated layout is
/// reused, not separately designed.)
class PortfolioDigestCard extends StatelessWidget {
  const PortfolioDigestCard({
    super.key,
    required this.report,
    required this.isLoading,
    required this.onGenerate,
  });

  final DigestReport? report;
  final bool isLoading;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return DigestCard(
      shadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: DigestPalette.primaryTint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.work_outline_rounded,
                  size: 18,
                  color: DigestPalette.primary,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portfolio Digest',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: DigestPalette.text,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'CROSS-ORGANIZATION AI SUMMARY',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 0.4,
                        color: DigestPalette.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Generate a single AI digest covering all your linked '
            'organizations at once — surfacing cross-portfolio insights and '
            'risk rankings.',
            style: TextStyle(
              fontSize: 12.5,
              height: 1.45,
              color: DigestPalette.body,
            ),
          ),
          const SizedBox(height: 14),
          DigestTonalButton(
            label: report == null
                ? 'Generate Portfolio Digest'
                : 'Regenerate Portfolio Digest',
            onPressed: onGenerate,
            isLoading: isLoading,
          ),
          if (report != null) ...[
            const SizedBox(height: 16),
            DigestReportBody(report: report!),
          ],
        ],
      ),
    );
  }
}
