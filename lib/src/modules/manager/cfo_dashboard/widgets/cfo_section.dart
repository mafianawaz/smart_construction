import 'package:flutter/material.dart';

import 'cfo_palette.dart';
import 'cfo_stat_grid.dart';

/// Upper-case section label ("PROJECTS") followed by its stat grid.
class CfoSection extends StatelessWidget {
  const CfoSection({
    super.key,
    required this.title,
    required this.stats,
    required this.columns,
  });

  final String title;
  final List<CfoStat> stats;
  final int columns;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: CfoPalette.muted,
          ),
        ),
        const SizedBox(height: 6),
        CfoStatGrid(stats: stats, columns: columns),
      ],
    );
  }
}
