import 'package:flutter/material.dart';

import '../models/rollup_project_model.dart';
import 'rollup_metric_bar.dart';
import 'rollup_palette.dart';
import 'rollup_status_badge.dart';

/// One project on the Health Heatmap: id / name / PM, status badge, Health +
/// SPI + CPI bars, and the Open RFIs / Open COs / Punch footer.
class HeatmapProjectCard extends StatelessWidget {
  const HeatmapProjectCard({super.key, required this.project});

  final RollupProject project;

  /// Health is 0–100. SPI / CPI are indices where 1.0 = on plan, so the bar
  /// is full at 1.0 and above. Placeholder maths, see NOTES.
  static double _indexFraction(double v) => v.clamp(0, 1).toDouble();

  @override
  Widget build(BuildContext context) {
    final p = project;
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.code,
                      style: const TextStyle(
                          fontSize: 10.5, color: RollupPalette.muted),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      p.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: RollupPalette.text,
                      ),
                    ),
                    if (p.pm != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '(${p.pm})',
                          style: const TextStyle(
                              fontSize: 10.5, color: RollupPalette.muted),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              RollupStatusBadge(status: p.status, upperCase: true),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: RollupMetricBar(
                  label: 'Health',
                  valueText: formatHealth(p.health),
                  fraction: p.health / 100,
                  barColor: RollupPalette.green,
                  valueColor: RollupPalette.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RollupMetricBar(
                  label: 'SPI',
                  valueText: formatRatio(p.spi),
                  fraction: _indexFraction(p.spi),
                  barColor: RollupPalette.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RollupMetricBar(
                  label: 'CPI',
                  valueText: formatRatio(p.cpi),
                  fraction: _indexFraction(p.cpi),
                  barColor: RollupPalette.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Footer('Open RFIs: ${p.openRfis}'),
              _Footer('Open COs: ${p.openCos}'),
              _Footer('Punch: ${p.punch}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(fontSize: 10.5, color: RollupPalette.muted),
      );
}
