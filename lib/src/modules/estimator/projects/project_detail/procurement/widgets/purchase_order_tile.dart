import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/modules/estimator/projects/models/project_enums.dart';

import '../../../models/procurement_models.dart';
import '../../../widgets/project_badge.dart';
import '../../widgets/project_format.dart';

/// Populated-state row for Purchase Orders. The reference shows only the
/// empty state, so this layout is a guess (it mirrors `PurchaseRequestTile`)
/// — flagged in NOTES_PROCUREMENT_FINANCIALS.md.
class PurchaseOrderTile extends StatelessWidget {
  final PurchaseOrderModel order;
  const PurchaseOrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final count = order.lineItems.length;
    final parts = <String>[
      order.number,
      if (order.neededBy != null) 'Needed ${DateFormat('MMM d').format(order.neededBy!)}',
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
                Text(order.vendor,
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
                label: order.status.label,
                background: order.status.background,
                foreground: order.status.foreground,
              ),
              const SizedBox(height: 4),
              Text(projectMoney(order.total),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}
