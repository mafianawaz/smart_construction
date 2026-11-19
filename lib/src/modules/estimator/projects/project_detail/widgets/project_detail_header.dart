import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../../models/project_model.dart';
import '../../widgets/health_badge.dart';
import '../../widgets/project_status_chip.dart';

class ProjectDetailHeader extends StatelessWidget {
  final ProjectModel project;
  const ProjectDetailHeader({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(project.number,
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ),
              const SizedBox(width: 8),
              ProjectStatusChip(status: project.status),
              const SizedBox(width: 8),
              HealthScoreBadge(score: project.healthScore),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            project.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
