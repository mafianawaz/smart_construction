import 'package:flutter/material.dart';

import '../models/crm_models.dart';
import 'crm_palette.dart';

/// Yellow "Compliance Alert" banner. Hidden by the caller when [entries] is empty.
class CrmComplianceAlert extends StatelessWidget {
  final List<ComplianceAlertEntry> entries;

  const CrmComplianceAlert({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final count = entries.length;
    final expired = entries
        .where((e) => e.item.state == ComplianceItemState.expired)
        .length;
    final expiring = count - expired;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CrmPalette.warnFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CrmPalette.warnBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 18,
                color: CrmPalette.warnText,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Compliance Alert: $count item${count == 1 ? '' : 's'} '
                  'require attention',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: CrmPalette.warnText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (expired > 0)
            Text(
              '$expired expired',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: CrmPalette.danger,
              ),
            ),
          if (expiring > 0)
            Text(
              '$expiring expiring soon',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: CrmPalette.amber,
              ),
            ),
          const SizedBox(height: 4),
          for (final entry in entries) _AlertRow(entry: entry),
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final ComplianceAlertEntry entry;

  const _AlertRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final isExpired = entry.item.state == ComplianceItemState.expired;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isExpired ? CrmPalette.dangerTint : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isExpired ? CrmPalette.danger : CrmPalette.amber,
              ),
            ),
            child: Text(
              isExpired ? 'Expired' : 'Expiring',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: isExpired ? CrmPalette.danger : CrmPalette.amber,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: entry.organizationName,
                    style: const TextStyle(color: CrmPalette.warnText),
                  ),
                  TextSpan(
                    text: ' - ${entry.item.label}',
                    style: const TextStyle(
                      color: CrmPalette.orangeDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
