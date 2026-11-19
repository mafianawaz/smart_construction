import 'package:flutter/material.dart';

import '../models/portfolio_report_models.dart';
import 'report_palette.dart';
import 'report_primitives.dart';

/// "Organization Health" card: name, status pill, type tag and a
/// Projects / Bids / Tasks / Staff stat row.
class OrgHealthCard extends StatelessWidget {
  const OrgHealthCard({super.key, required this.org});

  final PortfolioOrgMetrics org;

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  org.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ReportPalette.text,
                  ),
                ),
              ),
              ReportStatusPill(status: org.status),
            ],
          ),
          const SizedBox(height: 6),
          ReportTypeTag(org.typeLabel),
          const SizedBox(height: 14),
          Row(
            children: [
              _Stat(label: 'Projects', value: '${org.activeProjects}'),
              _Stat(label: 'Bids', value: '${org.bids}'),
              _Stat(label: 'Tasks', value: '${org.tasks}'),
              _Stat(label: 'Staff', value: '${org.employees}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10.5, color: ReportPalette.muted),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: ReportPalette.text,
            ),
          ),
        ],
      ),
    );
  }
}
