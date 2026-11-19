import 'package:flutter/material.dart';

import '../models/rollup_project_model.dart';
import 'rollup_palette.dart';
import 'rollup_status_badge.dart';

/// One project on the Financial Rollup: name + status, id, PM, and the
/// Contract / Actual / Var row. Var is green when at or under budget and red
/// when over.
class FinancialProjectCard extends StatelessWidget {
  const FinancialProjectCard({super.key, required this.project});

  final RollupProject project;

  @override
  Widget build(BuildContext context) {
    final p = project;
    final v = p.variancePct;
    final varColor = v < 0 ? RollupPalette.red : RollupPalette.green;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: RollupPalette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RollupPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  p.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: RollupPalette.text,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              RollupStatusBadge(status: p.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'ID: #${p.code}',
            style: const TextStyle(fontSize: 11, color: RollupPalette.muted),
          ),
          const SizedBox(height: 2),
          Text(
            'PM: ${p.pm ?? '-'}',
            style: const TextStyle(fontSize: 11, color: RollupPalette.muted),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contract: ${formatMoney(p.contract)}',
                style: const TextStyle(
                    fontSize: 11, color: RollupPalette.muted),
              ),
              Text(
                'Actual: ${formatMoney(p.actual)}',
                style: const TextStyle(
                    fontSize: 11, color: RollupPalette.muted),
              ),
              Text(
                'Var: ${formatPct(v)}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: varColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
