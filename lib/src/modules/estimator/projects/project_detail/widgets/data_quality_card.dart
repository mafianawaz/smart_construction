import 'package:flutter/material.dart';
import '../../models/project_enums.dart';
import 'detail_card.dart';

/// Overall completeness/accuracy score for the project's own data. The
/// reference's subtitle here ("Track status and value of the project
/// change order") appears to be a copy-paste leftover from the Change
/// Order card below it — replaced with sensible copy, flagged in
/// NOTES_PROJECTS.md.
class DataQualityCard extends StatelessWidget {
  final int score;
  const DataQualityCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final color = healthScoreColor(score);
    return DetailCard(
      title: 'Data Quality Score',
      subtitle: "Completeness and accuracy of this project's data.",
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Overall Quality',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text('$score', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
