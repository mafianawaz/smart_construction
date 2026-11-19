import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../../../models/materials_models.dart';
import '../../widgets/project_format.dart';

/// One "Material Budget vs Actual" row. Populated layout is a guess (the
/// reference shows only the empty state) — flagged in
/// NOTES_ESTIMATING_TABS.md. The bar turns red once actual passes budget.
class MaterialBudgetTile extends StatelessWidget {
  final MaterialBudgetRow row;
  const MaterialBudgetTile({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    final barColor = row.isOver ? AppColors.redColor : AppColors.primaryOrange;
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
          Text(row.scopeItemName,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: row.fraction,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(barColor),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${projectMoney(row.actual)} of ${projectMoney(row.budget)}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              Text(
                row.isOver
                    ? '${projectMoney(row.actual - row.budget)} over'
                    : '${projectMoney(row.remaining)} left',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: row.isOver ? AppColors.redColor : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
