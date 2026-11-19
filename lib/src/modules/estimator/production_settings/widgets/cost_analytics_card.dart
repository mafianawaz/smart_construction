import 'package:flutter/material.dart';
import '../models/production_models.dart';
import 'production_card.dart';
import 'production_figure.dart';
import 'production_palette.dart';
import 'unit_badge.dart';

/// Cost analytics row: scope + unit badge, LABOR/UNIT · MATERIAL/UNIT ·
/// PROFIT/UNIT (green or red), then TOTAL QTY · CONFIDENCE.
class CostAnalyticsCard extends StatelessWidget {
  final CostAnalyticsModel analytics;

  const CostAnalyticsCard({super.key, required this.analytics});

  Color get _confidenceColor {
    switch (analytics.confidence) {
      case ProductionConfidence.high:
        return ProductionPalette.profit;
      case ProductionConfidence.medium:
        return ProductionPalette.blueFg;
      case ProductionConfidence.low:
        return const Color(0xFFF59E0B);
      case ProductionConfidence.unknown:
        return const Color(0xFF9CA3AF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final unknown = analytics.confidence == ProductionConfidence.unknown;
    return ProductionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  analytics.scopeName,
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
              UnitBadge(unit: analytics.unit),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ProductionFigure(
                  label: 'LABOR/UNIT',
                  value: formatMoney(analytics.laborPerUnit),
                ),
              ),
              Expanded(
                child: ProductionFigure(
                  label: 'MATERIAL/UNIT',
                  value: formatMoney(analytics.materialPerUnit),
                ),
              ),
              Expanded(
                child: ProductionFigure(
                  label: 'PROFIT/UNIT',
                  value: formatSignedMoney(analytics.profitPerUnit),
                  valueColor: analytics.isProfitable
                      ? ProductionPalette.profit
                      : ProductionPalette.loss,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ProductionFigure(
                  label: 'TOTAL QTY',
                  value: formatQty(analytics.totalQty),
                ),
              ),
              Expanded(
                child: ProductionFigure(
                  label: 'CONFIDENCE',
                  value: analytics.confidence.label,
                  valueColor: _confidenceColor,
                  dot: !unknown,
                  muted: unknown,
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
