import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../../../../../../utils/app_icons.dart';
import '../../../models/schedule_model.dart';

class OptimizationRecommendationCard extends StatelessWidget {
  final OptimizationRecommendationModel recommendation;
  final VoidCallback onDismiss;

  const OptimizationRecommendationCard({
    super.key,
    required this.recommendation,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 15,
                    decoration: BoxDecoration(
                      color: AppColors.redColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(width: 5),
                  SvgPicture.asset(AppIcons.danger, width: 18, height: 18, color: AppColors.primaryOrangeDark),
                  SizedBox(width: 5),
                  Text(recommendation.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                ],
              ),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey.shade50,
                child: InkWell(
                  onTap: onDismiss,
                  child: Icon(Icons.close, size: 16, color: Colors.grey.shade500),
                ),
              ),

            ],
          ),
          const SizedBox(height: 5),
          Text(recommendation.description, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          const SizedBox(height: 6),
          Text('~${recommendation.daysSaved} days saved', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryOrangeDark)),
        ],
      ),
    );
  }
}
