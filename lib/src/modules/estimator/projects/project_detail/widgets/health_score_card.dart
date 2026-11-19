import 'package:flutter/material.dart';
import '../../../../../utils/app_color.dart';
import '../../models/project_enums.dart';
import '../../models/project_model.dart';
import 'detail_card.dart';

class HealthScoreCard extends StatelessWidget {
  final ProjectModel project;
  final bool isRefreshing;
  final VoidCallback onRefresh;

  const HealthScoreCard({
    super.key,
    required this.project,
    required this.isRefreshing,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Project Health Score',
      trailing: IconButton(
        onPressed: isRefreshing ? null : onRefresh,
        icon: isRefreshing
            ? const SizedBox(
                width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.sync, size: 20),
      ),
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${project.healthScore}',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: healthScoreColor(project.healthScore)),
              ),
              const TextSpan(
                text: ' / 100 points',
                style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        for (final risk in project.riskBreakdown) ...[
          _RiskRow(risk: risk),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _RiskRow extends StatelessWidget {
  final RiskBreakdownItem risk;
  const _RiskRow({required this.risk});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${risk.label}(${risk.weightLabel})',
                style:  TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: AppColors.textMuted)),
            Text(risk.level.label,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: risk.level.color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: risk.level.barFraction,
            minHeight: 7,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(risk.level.color),
          ),
        ),
      ],
    );
  }
}
