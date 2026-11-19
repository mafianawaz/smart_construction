import 'package:flutter/material.dart';
import 'package:smart_construction/src/modules/manager/portfolio_rollup/models/rollup_enums.dart';

import '../logic.dart';
import '../models/rollup_project_model.dart';
import 'rollup_palette.dart';

/// One compact Gantt row: id + name, a mini timeline bar positioned inside the
/// portfolio's date range, and the status label.
///
/// Rows are meant to sit inside a single rounded card; [showDivider] draws the
/// hairline between them (false on the last row).
class GanttRow extends StatelessWidget {
  const GanttRow({
    super.key,
    required this.project,
    required this.segment,
    this.showDivider = true,
  });

  final RollupProject project;
  final GanttSegment? segment;
  final bool showDivider;

  static const double _barWidth = 92;
  static const double _statusWidth = 64;

  @override
  Widget build(BuildContext context) {
    final p = project;
    final color = RollupPalette.statusColor(p.status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: showDivider
            ? const Border(bottom: BorderSide(color: RollupPalette.border))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.code,
                  style: const TextStyle(
                      fontSize: 10, color: RollupPalette.muted),
                ),
                const SizedBox(height: 1),
                Text(
                  p.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: RollupPalette.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: _barWidth,
            height: 6,
            child: _Track(segment: segment, color: color),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: _statusWidth,
            child: Text(
              p.status.upperLabel,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Track extends StatelessWidget {
  const _Track({required this.segment, required this.color});

  final GanttSegment? segment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        final s = segment;
        return Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: RollupPalette.track,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            if (s != null)
              Positioned(
                left: s.left * w,
                width: s.width * w,
                top: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
