import 'package:flutter/material.dart';
import '../models/production_models.dart';
import 'production_card.dart';
import 'production_figure.dart';
import 'production_palette.dart';
import 'unit_badge.dart';

/// Benchmark row: scope + unit badge, AVG/DAY · MIN/MAX RANGE · TOTAL QTY,
/// then DAYS · PROJECTS.
class BenchmarkCard extends StatelessWidget {
  final ProductionBenchmarkModel benchmark;

  const BenchmarkCard({super.key, required this.benchmark});

  @override
  Widget build(BuildContext context) {
    return ProductionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  benchmark.scopeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: ProductionPalette.ink,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              UnitBadge(unit: benchmark.unit),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ProductionFigure(
                  label: 'AVG / DAY',
                  value: formatQty(benchmark.avgDaily),
                ),
              ),
              Expanded(
                child: ProductionFigure(
                  label: 'MIN/MAX RANGE',
                  value: benchmark.rangeLabel,
                ),
              ),
              Expanded(
                child: ProductionFigure(
                  label: 'TOTAL QTY',
                  value: formatQty(benchmark.totalQty),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ProductionFigure(
                  label: 'DAYS',
                  value: '${benchmark.days}',
                ),
              ),
              Expanded(
                child: ProductionFigure(
                  label: 'PROJECTS',
                  value: '${benchmark.projects}',
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }
}
