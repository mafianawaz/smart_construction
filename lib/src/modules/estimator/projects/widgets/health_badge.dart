import 'package:flutter/material.dart';
import '../models/project_enums.dart';

/// Small colored dot + "Health: NN%" text used on project cards.
class HealthIndicator extends StatelessWidget {
  final int score;
  const HealthIndicator({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final color = healthScoreColor(score);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text('Health: $score%',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}

/// Filled circle badge used on the Project Detail header ("81").
class HealthScoreBadge extends StatelessWidget {
  final int score;
  const HealthScoreBadge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final color = healthScoreColor(score);
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text('$score',
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
    );
  }
}
