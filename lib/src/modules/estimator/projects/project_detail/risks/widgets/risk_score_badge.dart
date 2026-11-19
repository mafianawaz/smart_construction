import 'package:flutter/material.dart';
import '../../../models/project_enums.dart';

/// Colored circle showing a Probability × Impact score, banded via
/// [RiskSeverityBandX.fromScore] — used on the Add Risk form and on
/// every [RiskCard].
class RiskScoreBadge extends StatelessWidget {
  final int score;
  final double size;

  const RiskScoreBadge({super.key, required this.score, this.size = 32});

  @override
  Widget build(BuildContext context) {
    final color = RiskSeverityBandX.fromScore(score).color;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        '$score',
        style: TextStyle(
            fontSize: size * 0.4, fontWeight: FontWeight.w800, color: Colors.white),
      ),
    );
  }
}
