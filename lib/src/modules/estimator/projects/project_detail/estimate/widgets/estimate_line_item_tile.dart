import 'package:flutter/material.dart';
import 'package:smart_construction/src/modules/estimator/projects/models/project_enums.dart';

import '../../../models/estimate_models.dart';
import '../../../widgets/project_badge.dart';
import '../../widgets/project_format.dart';

/// Populated-state row for "Estimate Line Items". The reference shows
/// only the empty state, so this layout is a guess — flagged in
/// NOTES_ESTIMATING_TABS.md.
class EstimateLineItemTile extends StatelessWidget {
  final EstimateLineItemModel item;
  final VoidCallback onRemove;

  const EstimateLineItemTile({super.key, required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final qty = item.quantity > 0
        ? '${projectNumber(item.quantity)}${item.unit.isEmpty ? '' : ' ${item.unit}'}'
        : null;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.description,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ProjectBadge(
                      label: item.category.label,
                      background: Colors.grey.shade200,
                      foreground: Colors.grey.shade700,
                    ),
                    if (qty != null) ...[
                      const SizedBox(width: 8),
                      Text(qty, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(projectMoney(item.directCost + item.allocations),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.delete_outline, size: 18, color: Colors.grey.shade500),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
