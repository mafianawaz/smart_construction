import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../../../field_worker/my_task/widget/pill_chip.dart';
import '../models/analytics_models.dart';

/// One row in "Enrolled Clients" on the Analytics dashboard — organization
/// + project, an auto-approve switch, and an Active/Inactive pill.
class AnalyticsClientTile extends StatelessWidget {
  final AnalyticsClientPreview client;
  final ValueChanged<bool> onAutoApproveChanged;

  const AnalyticsClientTile({
    super.key,
    required this.client,
    required this.onAutoApproveChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.apartment_outlined, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.organizationName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      client.projectName,
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),

                  ],
                ),
              ),

            ],
          ),
          const SizedBox(height: 6),
          Divider(color: AppColors.fieldBorder),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Auto-approve',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                  Transform.scale(
                    scale: 0.75,
                    child: Switch(
                      value: client.autoApprove,
                      activeColor: AppColors.primaryOrange,
                      onChanged: onAutoApproveChanged,
                    ),
                  ),
                ],
              ),
              PillChip(
                label: client.isActive ? 'Active' : 'Inactive',
                color: client.isActive ? AppColors.statusChip : AppColors.textMuted,filled: false,),
            ],
          ),

        ],
      ),
    );
  }
}
