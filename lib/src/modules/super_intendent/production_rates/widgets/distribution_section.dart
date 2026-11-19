import 'package:flutter/material.dart';

import '../logic.dart';
import '../models/company_settings_models.dart';
import 'cs_palette.dart';

/// Operations → Distribution (organization distribution lists, read-only).
class DistributionSection extends StatelessWidget {
  final CompanySettingsLogic logic;

  const DistributionSection({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final lists = logic.distributionLists;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CsPalette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CsPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.people_outline,
                  size: 18,
                  color: CsPalette.orange,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Organization distribution lists',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: CsPalette.text,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Reusable email recipient groups available in the Send '
                      'Gantt dialog on every project.',
                      style: TextStyle(
                        fontSize: 10,
                        color: CsPalette.muted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: lists.isEmpty
                ? const _EmptyLists()
                : Column(
                    children: [
                      for (var i = 0; i < lists.length; i++) ...[
                        _ListTile(item: lists[i]),
                        if (i != lists.length - 1) const SizedBox(height: 8),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyLists extends StatelessWidget {
  const _EmptyLists();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Icon(Icons.mail_outline, size: 34, color: CsPalette.hint),
          SizedBox(height: 12),
          Text(
            'No organization-wide lists yet. Ask an admin to create one.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.5, color: CsPalette.hint, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final DistributionListModel item;

  const _ListTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final n = item.emails.length;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CsPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: CsPalette.text,
                  ),
                ),
              ),
              Text(
                '$n ${n == 1 ? 'recipient' : 'recipients'}',
                style: const TextStyle(fontSize: 10, color: CsPalette.muted),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.emails.join(', '),
            style: const TextStyle(fontSize: 10.5, color: CsPalette.muted),
          ),
        ],
      ),
    );
  }
}
