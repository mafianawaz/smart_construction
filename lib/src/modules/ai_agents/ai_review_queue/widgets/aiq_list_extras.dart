import 'package:flutter/material.dart';

import '../models/ai_review_models.dart';
import 'aiq_palette.dart';

/// Bulk accept bar at the top of the list.
class AiqBulkAcceptBar extends StatelessWidget {
  const AiqBulkAcceptBar({
    super.key,
    required this.selectedCount,
    required this.onPressed,
  });

  final int selectedCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = selectedCount > 0;
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AiqPalette.fillMuted,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AiqPalette.border),
        ),
        alignment: Alignment.center,
        child: Text(
          enabled ? 'Bulk accept ($selectedCount selected)' : 'Bulk accept',
          style: TextStyle(
            fontSize: 13,
            fontWeight: enabled ? FontWeight.w600 : FontWeight.w400,
            color: enabled ? AiqPalette.text : AiqPalette.faint,
          ),
        ),
      ),
    );
  }
}

/// "Item types" legend — outlined chips for every draft type.
class AiqItemTypesLegend extends StatelessWidget {
  const AiqItemTypesLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Item types',
          style: TextStyle(fontSize: 12, color: AiqPalette.muted),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in ReviewItemType.values)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: AiqPalette.card,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AiqPalette.border),
                ),
                child: Text(
                  t.wire,
                  style: const TextStyle(fontSize: 11, color: AiqPalette.text),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Card for the existing Approvals page: "AI drafts awaiting review: 14
/// (4 human-gated) — Open AI Review Queue →". Screen-agnostic; the Approvals
/// page passes its own [onOpen] (e.g. `Get.to(() => const AiReviewQueueView())`).
class AiqApprovalsLinkCard extends StatelessWidget {
  const AiqApprovalsLinkCard({
    super.key,
    required this.awaiting,
    required this.humanGated,
    required this.onOpen,
  });

  final int awaiting;
  final int humanGated;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AiqPalette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AiqPalette.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: AiqPalette.fillMuted,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: const Text(
              'Link Card On Approvals (Existing Approvals Page)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AiqPalette.text,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 12.5, color: AiqPalette.muted),
                children: [
                  const TextSpan(text: 'AI drafts awaiting review: '),
                  TextSpan(
                    text: '$awaiting',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AiqPalette.text,
                    ),
                  ),
                  TextSpan(text: ' ($humanGated human-gated) — '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: GestureDetector(
                      onTap: onOpen,
                      child: const Text(
                        'Open AI Review Queue →',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AiqPalette.orange,
                          decoration: TextDecoration.underline,
                          decorationColor: AiqPalette.orange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact Type / Title / $ card shown above the inline sheet.
class AiqCompactCard extends StatelessWidget {
  const AiqCompactCard({super.key, required this.item, this.onTap});

  final ReviewItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget row(String label, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              SizedBox(
                width: 62,
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: AiqPalette.muted),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 13, color: AiqPalette.text),
                ),
              ),
            ],
          ),
        );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
        decoration: BoxDecoration(
          color: AiqPalette.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AiqPalette.border),
        ),
        child: Column(
          children: [
            row('Type', item.type.wire),
            row('Title', item.shortTitle),
            row('\$', AiqFormat.money(item.amountAtStake)),
          ],
        ),
      ),
    );
  }
}
