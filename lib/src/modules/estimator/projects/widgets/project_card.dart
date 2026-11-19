import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../../../../utils/app_icons.dart';
import '../models/project_model.dart';
import 'health_badge.dart';
import 'project_status_chip.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  Widget _infoRow(String icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, height: 14, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ],
          ),

          Text(value,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                ProjectStatusChip(status: project.status),
              ],
            ),
            const SizedBox(height: 10),
            Text(project.title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Completion Progress',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                HealthIndicator(score: project.healthScore),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: project.completionProgress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(AppColors.primaryOrange),
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: AppColors.fieldBorder, height: 1),
            const SizedBox(height: 8),
            _infoRow(AppIcons.briefcase, 'Client', project.clientName),
            _infoRow(AppIcons.personal, 'Superintendent', project.superintendent),
            _infoRow(AppIcons.docs, 'Estimator', project.estimator),
          ],
        ),
      ),
    );
  }
}
