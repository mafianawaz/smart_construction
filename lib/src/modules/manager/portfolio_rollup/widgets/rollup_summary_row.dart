import 'package:flutter/material.dart';

import '../logic.dart';
import '../models/rollup_project_model.dart';
import 'rollup_palette.dart';

/// Heatmap summary: "N projects / Avg health X" on the left, avg SPI and
/// avg CPI columns on the right.
class RollupSummaryRow extends StatelessWidget {
  const RollupSummaryRow({super.key, required this.summary});

  final RollupSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${summary.count} projects',
                  style: const TextStyle(
                      fontSize: 12, color: RollupPalette.text),
                ),
                const SizedBox(height: 2),
                Text(
                  'Avg health ${formatHealth(summary.avgHealth)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: RollupPalette.text,
                  ),
                ),
              ],
            ),
          ),
          _Stat(label: 'SPI', value: formatRatio(summary.avgSpi)),
          const SizedBox(width: 36),
          _Stat(label: 'CPI', value: formatRatio(summary.avgCpi)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: RollupPalette.muted)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: RollupPalette.text,
          ),
        ),
      ],
    );
  }
}
