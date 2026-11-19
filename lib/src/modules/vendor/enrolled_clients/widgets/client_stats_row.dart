import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';


class ClientStatItem {
  final IconData icon;
  final String label;
  final int value;

  const ClientStatItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

/// Row of small icon-badge stat cards (e.g. Clients / Active / Pending).
///
/// NOTE: Visually similar to `RoleSummaryCard` used on the home screen.
/// Reconcile with that widget if its column-config API can express this
/// layout, instead of keeping this as a separate widget.
class ClientStatsRow extends StatelessWidget {
  final List<ClientStatItem> items;

  const ClientStatsRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: _StatCard(item: items[i])),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final ClientStatItem item;

  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.fieldFill),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 5),
            ),
          ]
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            // padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.label,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${item.value}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
