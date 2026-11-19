import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/modules/estimator/projects/models/project_enums.dart';

import '../../../models/procurement_models.dart';
import '../../../widgets/project_badge.dart';
import '../../widgets/project_format.dart';

/// Populated-state row for Purchase Requests. The reference shows only the
/// empty state, so this layout is a guess — flagged in
/// NOTES_ESTIMATING_TABS.md.
class PurchaseRequestTile extends StatelessWidget {
  final PurchaseRequestModel request;
  const PurchaseRequestTile({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final count = request.lineItems.length;
    final parts = <String>[
      request.number,
      if (request.neededBy != null) 'Needed ${DateFormat('MMM d').format(request.neededBy!)}',
      '$count ${count == 1 ? 'item' : 'items'}',
    ];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
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
                Text(request.title,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(parts.join(' · '),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ProjectBadge(
                label: request.status.label,
                background: request.status.background,
                foreground: request.status.foreground,
              ),
              const SizedBox(height: 4),
              Text(projectMoney(request.total),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}
