import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/cfo_org_models.dart';
import 'cfo_org_palette.dart';
import 'cfo_org_widgets.dart';

/// Hand-painted donut — no chart package dependency.
class _DonutPainter extends CustomPainter {
  _DonutPainter(this.slices, {required this.strokeWidth});

  final List<CfoChartSlice> slices;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final total = slices.fold<int>(0, (sum, s) => sum + s.value);
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    if (total == 0) {
      paint.color = CfoOrgPalette.slateSoft;
      canvas.drawArc(rect, 0, math.pi * 2, false, paint);
      return;
    }

    var start = -math.pi / 2;
    for (final slice in slices) {
      if (slice.value == 0) continue;
      final sweep = (slice.value / total) * math.pi * 2;
      paint.color = slice.color;
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.slices != slices || old.strokeWidth != strokeWidth;
}

class CfoOrgDonut extends StatelessWidget {
  const CfoOrgDonut({super.key, required this.slices, this.size = 52});

  final List<CfoChartSlice> slices;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _DonutPainter(slices, strokeWidth: 8)),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 7, color: CfoOrgPalette.muted),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small card: title, donut on the left, legend on the right.
class CfoOrgDonutCard extends StatelessWidget {
  const CfoOrgDonutCard({
    super.key,
    required this.title,
    required this.slices,
    this.width = 168,
  });

  final String title;
  final List<CfoChartSlice> slices;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: CfoOrgCard(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    color: CfoOrgPalette.text)),
            const SizedBox(height: 8),
            Row(
              children: [
                CfoOrgDonut(slices: slices),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final s in slices)
                        _LegendDot(
                            color: s.color, label: '${s.label} (${s.value})'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal bars, one row per datum — "Change Orders by Status".
class CfoOrgHorizontalBarsCard extends StatelessWidget {
  const CfoOrgHorizontalBarsCard({
    super.key,
    required this.title,
    required this.data,
  });

  final String title;
  final List<CfoBarDatum> data;

  @override
  Widget build(BuildContext context) {
    final max = data.fold<double>(0, (m, d) => math.max(m, d.value));
    return CfoOrgCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                  color: CfoOrgPalette.text)),
          const SizedBox(height: 8),
          for (final d in data)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    child: Text(d.label,
                        style: const TextStyle(
                            fontSize: 6.5, color: CfoOrgPalette.muted)),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, c) {
                        final w = max == 0 ? 0.0 : c.maxWidth * (d.value / max);
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: w,
                            height: 7,
                            decoration: BoxDecoration(
                              color: d.color,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Vertical bars with bottom labels — "AR Aging".
class CfoOrgVerticalBarsCard extends StatelessWidget {
  const CfoOrgVerticalBarsCard({
    super.key,
    required this.title,
    required this.data,
    this.chartHeight = 56,
  });

  final String title;
  final List<CfoBarDatum> data;
  final double chartHeight;

  @override
  Widget build(BuildContext context) {
    final max = data.fold<double>(0, (m, d) => math.max(m, d.value));
    return CfoOrgCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                  color: CfoOrgPalette.text)),
          const SizedBox(height: 8),
          SizedBox(
            height: chartHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final d in data)
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 10,
                        height: max == 0
                            ? 2
                            : math.max(2, chartHeight * (d.value / max)),
                        decoration: BoxDecoration(
                          color: d.color,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(2)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              for (final d in data)
                Expanded(
                  child: Text(d.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 6, color: CfoOrgPalette.muted)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// "Team Activity" card: single-slice-pair donut with Active / Inactive legend.
CfoOrgDonutCard cfoTeamActivityCard({
  required int active,
  required int inactive,
}) {
  return CfoOrgDonutCard(
    title: 'Team Activity',
    slices: [
      CfoChartSlice(label: 'Active', value: active, color: CfoOrgPalette.blue),
      CfoChartSlice(
          label: 'Inactive', value: inactive, color: CfoOrgPalette.slate),
    ],
  );
}
