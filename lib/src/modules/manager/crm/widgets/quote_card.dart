import 'package:flutter/material.dart';

import '../models/crm_activity_models.dart';
import 'crm_activity_style.dart';
import 'crm_controls.dart';
import 'crm_palette.dart';

/// Quote summary: number, title, organization, tappable status badge, total,
/// item count, valid-until date and a PDF action.
class QuoteCard extends StatelessWidget {
  final QuoteModel quote;
  final ValueChanged<QuoteStatus> onStatusChanged;
  final VoidCallback onPdf;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.onStatusChanged,
    required this.onPdf,
  });

  @override
  Widget build(BuildContext context) {
    final validUntil = quote.validUntil;
    final itemCount = quote.lineItems.length;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CrmPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quote.number,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: CrmPalette.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      quote.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: CrmPalette.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      quote.organizationName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: CrmPalette.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<QuoteStatus>(
                onSelected: onStatusChanged,
                color: CrmPalette.surface,
                tooltip: 'Change status',
                itemBuilder: (context) => [
                  for (final s in QuoteStatus.values)
                    PopupMenuItem<QuoteStatus>(
                      value: s,
                      child: Text(s.label, style: const TextStyle(fontSize: 13)),
                    ),
                ],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CrmBadge(label: quote.status.label, color: quote.status.color),
                    const Icon(
                      Icons.arrow_drop_down,
                      size: 18,
                      color: CrmPalette.textMuted,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                crmMoneyPrecise(quote.total),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: CrmPalette.text,
                ),
              ),
              const Spacer(),
              Text(
                '$itemCount item${itemCount == 1 ? '' : 's'}',
                style: const TextStyle(fontSize: 11.5, color: CrmPalette.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (validUntil != null)
                Expanded(
                  child: Text(
                    'Valid until ${crmLongDate(validUntil)}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: CrmPalette.textMuted,
                    ),
                  ),
                )
              else
                const Spacer(),
              CrmSmallButton(
                label: 'PDF',
                icon: Icons.picture_as_pdf_outlined,
                onTap: onPdf,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
