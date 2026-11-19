import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../analytics/crm_analytics.dart';
import '../models/crm_models.dart';
import 'crm_palette.dart';

/// "$1.2k" / "$45k" / "$1.5M" for tight spaces; whole dollars below $1,000.
String crmCompactMoney(double v) {
  String trim(double x) {
    final s = x.toStringAsFixed(1);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  }

  if (v >= 1e6) return '\$${trim(v / 1e6)}M';
  if (v >= 1e3) return '\$${trim(v / 1e3)}k';
  return crmMoney(v);
}

/// "45,000" (crmMoney without the dollar sign).
String _plainMoney(double v) => crmMoney(v).substring(1);

// ───────────────────────────── Funnel ─────────────────────────────

class CrmFunnelChart extends StatelessWidget {
  final List<FunnelRow> rows;

  const CrmFunnelChart({super.key, required this.rows});

  static const Color countColor = CrmPalette.blue;
  static const Color pipelineColor = CrmPalette.success;
  static const Color weightedColor = CrmPalette.orange;

  @override
  Widget build(BuildContext context) {
    final maxCount = rows.fold<int>(0, (m, r) => math.max(m, r.count));
    final maxValue = rows.fold<double>(0, (m, r) => math.max(m, r.pipeline));

    return Column(
      children: [
        for (final r in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 14),
              child: Row(
                children: [
                  SizedBox(
                    width: 82,
                    child: Text(
                      r.stage.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: CrmPalette.textMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        _bar(maxValue == 0 ? 0 : r.pipeline / maxValue,
                            pipelineColor, 10),
                        if (r.weighted > 0) ...[
                          const SizedBox(height: 2),
                          _bar(maxValue == 0 ? 0 : r.weighted / maxValue,
                              weightedColor, 4),
                        ],
                        if (r.count > 0) ...[
                          const SizedBox(height: 2),
                          _bar(maxCount == 0 ? 0 : r.count / maxCount,
                              countColor, 4),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 56,
                    child: Text(
                      _plainMoney(r.pipeline),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: CrmPalette.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: countColor, label: 'Count'),
            SizedBox(width: 14),
            _LegendDot(color: pipelineColor, label: 'Pipeline \$'),
            SizedBox(width: 14),
            _LegendDot(color: weightedColor, label: 'Weighted \$'),
          ],
        ),
      ],
    );
  }

  Widget _bar(double fraction, Color color, double height) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: fraction.clamp(0.0, 1.0),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: CrmPalette.textMuted),
        ),
      ],
    );
  }
}

// ───────────────────────────── Bar chart ─────────────────────────────

/// Simple vertical bar chart with 4 gridlines, a compact-money y axis and
/// month labels. An all-zero series still draws the $1–$4 axis.
class CrmBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final double height;
  final Color color;

  const CrmBarChart({
    super.key,
    required this.values,
    required this.labels,
    this.height = 120,
    this.color = CrmPalette.orange,
  });

  /// Step so that 4 gridlines land on round numbers (1, 2, 2.5, 5 × 10^n).
  static double niceStep(double maxValue) {
    if (maxValue <= 0) return 1;
    final raw = maxValue / 4;
    final exp = math.pow(10, (math.log(raw) / math.ln10).floor()).toDouble();
    final f = raw / exp;
    final nf = f <= 1 ? 1 : f <= 2 ? 2 : f <= 2.5 ? 2.5 : f <= 5 ? 5 : 10;
    return nf * exp;
  }

  @override
  Widget build(BuildContext context) {
    final maxValue = values.fold<double>(0, (m, v) => math.max(m, v));
    final step = niceStep(maxValue);
    final top = step * 4;

    return Column(
      children: [
        SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 40,
                child: Stack(
                  children: [
                    for (var i = 1; i <= 4; i++)
                      Positioned(
                        right: 6,
                        bottom: height * i / 4 - 7,
                        child: Text(
                          crmCompactMoney(step * i),
                          style: const TextStyle(
                            fontSize: 9,
                            color: CrmPalette.textFaint,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: _GridPainter()),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final v in values)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 7),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FractionallySizedBox(
                                  heightFactor: (v / top).clamp(0.0, 1.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(3),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const SizedBox(width: 40),
            for (final l in labels)
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    l,
                    style: const TextStyle(
                      fontSize: 9,
                      color: CrmPalette.textFaint,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CrmPalette.border
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = size.height - size.height * i / 4;
      canvas.drawLine(
        Offset(0, y.clamp(0.5, size.height - 0.5)),
        Offset(size.width, y.clamp(0.5, size.height - 0.5)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
