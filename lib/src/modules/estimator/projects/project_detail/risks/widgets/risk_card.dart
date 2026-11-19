import 'package:flutter/material.dart';
import '../../../models/project_enums.dart';
import '../../../models/risk_model.dart';
import 'risk_score_badge.dart';

class RiskCard extends StatelessWidget {
  final RiskModel risk;
  const RiskCard({super.key, required this.risk});

  @override
  Widget build(BuildContext context) {
    final band = risk.severityBand;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(color: band.color, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(risk.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('${risk.category.label} · ${risk.status.label}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          RiskScoreBadge(score: risk.score, size: 28),
        ],
      ),
    );
  }
}
