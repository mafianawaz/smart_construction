import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../../../field_worker/my_task/widget/pill_chip.dart';
import '../models/analytics_models.dart';

/// One row in "Recent Pricing Submissions" on the Analytics dashboard.
class AnalyticsPricingTile extends StatelessWidget {
  final AnalyticsPricingSubmission submission;

  const AnalyticsPricingTile({super.key, required this.submission});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  submission.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      submission.category,
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                    const SizedBox(width: 6),
                    CircleAvatar(
                      radius: 2,
                      backgroundColor: AppColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      submission.formattedPrice,
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          PillChip(
            label: submission.status,
            color: AppColors.primaryOrange,
            filled: false,
          ),
        ],
      ),
    );
  }
}
