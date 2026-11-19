import 'package:flutter/material.dart';
import 'package:smart_construction/src/modules/estimator/projects/models/project_enums.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../../../models/scope_models.dart';
import '../../../widgets/project_badge.dart';
import '../../widgets/project_format.dart';

/// Populated-state row for Scope & Progress. The reference shows only the
/// empty state, so this layout (name + status badge, progress bar,
/// completed/total and unit price) is a guess — flagged in
/// NOTES_ESTIMATING_TABS.md.
class ScopeItemCard extends StatelessWidget {
  final ScopeItemModel item;
  const ScopeItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final status = item.status;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(item.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              ProjectBadge(
                label: status.label,
                background: status.background,
                foreground: status.foreground,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: item.progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryOrange),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${projectNumber(item.completedQuantity)} / ${projectNumber(item.totalQuantity)} ${item.unit}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              if (item.unitPrice != null)
                Text(
                  '${projectMoney(item.unitPrice!)} / ${item.unit}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
