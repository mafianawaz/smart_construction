import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/modules/estimator/projects/models/project_enums.dart';

import '../../../models/financial_models.dart';
import '../../../widgets/project_badge.dart';
import '../../widgets/project_format.dart';

/// Shared row shell for the populated lists on the Financials tab (change
/// orders, receipts, SOVs, payments, waivers). None of these has a populated
/// reference — every screen shows its empty state — so the layout is a
/// guess that mirrors `PurchaseRequestTile`. Flagged in
/// NOTES_PROCUREMENT_FINANCIALS.md.
class _RecordTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final Widget? badge;

  const _RecordTile({
    required this.title,
    required this.subtitle,
    required this.amount,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (badge != null) ...[badge!, const SizedBox(height: 4)],
              Text(amount, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

String _day(DateTime d) => DateFormat('MMM d, y').format(d);

class ChangeOrderRecordTile extends StatelessWidget {
  final ChangeOrderRecord record;
  const ChangeOrderRecordTile({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      if (record.costCode != null) record.costCode!,
      if (record.workType != null) record.workType!,
      _day(record.createdAt),
    ];
    return _RecordTile(
      title: '${record.number}${record.description.isEmpty ? '' : ' · ${record.description}'}',
      subtitle: parts.join(' · '),
      amount: projectMoney(record.amount),
      badge: ProjectBadge(
        label: record.status.label,
        background: record.status.background,
        foreground: record.status.foreground,
      ),
    );
  }
}

class ReceiptRecordTile extends StatelessWidget {
  final ReceiptRecord record;
  const ReceiptRecordTile({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      if (record.category.isNotEmpty) record.category,
      if (record.costCode != null) record.costCode!,
      _day(record.date),
    ];
    return _RecordTile(
      title: record.vendor,
      subtitle: parts.join(' · '),
      amount: projectMoney(record.amount),
    );
  }
}

class SovRecordTile extends StatelessWidget {
  final SovRecord record;
  final double paid;
  const SovRecordTile({super.key, required this.record, required this.paid});

  @override
  Widget build(BuildContext context) {
    return _RecordTile(
      title: '${record.number} · ${record.title}',
      subtitle: 'Created ${_day(record.createdAt)} · paid to date',
      amount: projectMoney(paid),
    );
  }
}

class PaymentRecordTile extends StatelessWidget {
  final PaymentRecord record;
  final String sovLabel;
  const PaymentRecordTile({super.key, required this.record, required this.sovLabel});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      record.method.label,
      if (record.reference != null) '#${record.reference}',
      _day(record.date),
    ];
    return _RecordTile(
      title: sovLabel,
      subtitle: parts.join(' · '),
      amount: projectMoney(record.amount),
    );
  }
}

class LienWaiverRecordTile extends StatelessWidget {
  final LienWaiverRecord record;
  const LienWaiverRecordTile({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      if (record.company != null) record.company!,
      if (record.throughDate != null) 'Through ${_day(record.throughDate!)}',
    ];
    return _RecordTile(
      title: record.recipient,
      subtitle: parts.isEmpty ? record.projectLabel : parts.join(' · '),
      amount: projectMoney(record.amount),
      badge: ProjectBadge(
        label: record.type.label,
        background: const Color(0xFFDCEBFF),
        foreground: const Color(0xFF2B6CB0),
      ),
    );
  }
}
