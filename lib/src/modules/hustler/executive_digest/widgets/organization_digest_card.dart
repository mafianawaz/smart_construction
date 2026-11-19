import 'package:flutter/material.dart';

import '../models/executive_digest_models.dart';
import 'digest_empty_state.dart';
import 'digest_palette.dart';
import 'digest_primitives.dart';
import 'digest_report_body.dart';

/// Expandable per-organization digest card: name + type, "Generate Now",
/// chevron, then either the generated report or a per-org empty state.
class OrganizationDigestCard extends StatelessWidget {
  const OrganizationDigestCard({
    super.key,
    required this.organization,
    required this.report,
    required this.isExpanded,
    required this.isGenerating,
    required this.onToggle,
    required this.onGenerate,
  });

  final DigestOrganization organization;
  final DigestReport? report;
  final bool isExpanded;
  final bool isGenerating;
  final VoidCallback onToggle;
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organization.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: DigestPalette.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      organization.orgType.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        letterSpacing: 0.4,
                        color: DigestPalette.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              DigestOutlineButton(
                label: 'Generate Now',
                onPressed: onGenerate,
                isLoading: isGenerating,
              ),
              InkWell(
                customBorder: const CircleBorder(),
                onTap: onToggle,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: DigestPalette.body,
                  ),
                ),
              ),
            ],
          ),
          if (isExpanded) ...[
            const SizedBox(height: 14),
            if (report != null)
              DigestReportBody(report: report!)
            else
              DigestEmptyState(
                title: 'No digest yet for this period',
                message:
                    'Click "Generate Now" to create an AI-powered digest.',
                onGenerate: onGenerate,
                isLoading: isGenerating,
              ),
          ],
        ],
      ),
    );
  }
}
