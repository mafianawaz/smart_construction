import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'cfo_palette.dart';

/// One cell of a [CfoStatGrid].
class CfoStat {
  const CfoStat(this.label, this.value, {this.valueColor});

  final String label;
  final String value;

  /// null = default text colour.
  final Color? valueColor;
}

/// Bordered grid of label/value cells with shared hairlines, as in the
/// reference. [columns] cells per row; a short last row is padded with empty
/// cells so the grid stays rectangular.
class CfoStatGrid extends StatelessWidget {
  const CfoStatGrid({super.key, required this.stats, required this.columns});

  final List<CfoStat> stats;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final rows = <List<CfoStat?>>[];
    for (var i = 0; i < stats.length; i += columns) {
      final slice = <CfoStat?>[
        ...stats.sublist(i, math.min(i + columns, stats.length)),
      ];
      while (slice.length < columns) {
        slice.add(null);
      }
      rows.add(slice);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CfoPalette.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var r = 0; r < rows.length; r++)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var c = 0; c < columns; c++)
                    Expanded(
                      child: _Cell(
                        stat: rows[r][c],
                        showRight: c != columns - 1,
                        showBottom: r != rows.length - 1,
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

class _Cell extends StatelessWidget {
  const _Cell({
    required this.stat,
    required this.showRight,
    required this.showBottom,
  });

  final CfoStat? stat;
  final bool showRight;
  final bool showBottom;

  @override
  Widget build(BuildContext context) {
    const side = BorderSide(color: CfoPalette.border);
    final s = stat;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          right: showRight ? side : BorderSide.none,
          bottom: showBottom ? side : BorderSide.none,
        ),
      ),
      child: s == null
          ? const SizedBox.shrink()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  s.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 10.5, color: CfoPalette.muted),
                ),
                const SizedBox(height: 3),
                // Large currency values (e.g. $113,795,000) shrink to fit a
                // three-column cell instead of wrapping.
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    s.value,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: s.valueColor ?? CfoPalette.text,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
