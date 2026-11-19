import 'package:flutter/material.dart';

import '../utils/app_color.dart';


/// Data for a single stat card. [value] is a String (not int) so callers
/// can pass counts ("0"), currency ("$12,500.00"), or any other formatted
/// display value — this is what makes the widget domain-agnostic.
class StatCardItem {
  final IconData icon;
  final String label;
  final String value;

  const StatCardItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

/// Row of small icon-badge stat cards.
///
/// Screen-agnostic: previously this widget (as `ClientStatsRow`) was named
/// and typed for the Enrolled Clients screen specifically (`int value`,
/// "Clients/Active/Pending" only). It now takes any list of [StatCardItem]
/// so it can be reused wherever a row of icon+label+value summary cards is
/// needed (e.g. Purchase Orders' Active / Value / Delivered row, Enrolled
/// Clients' Clients / Active / Pending row, etc). All variation is
/// data-driven — no screen-specific logic lives in this widget.
///
/// NOTE: Visually similar to `RoleSummaryCard` used on the home screen.
/// Reconcile with that widget if its column-config API can express this
/// layout, instead of keeping this as a separate widget. Not reconciled
/// here since `RoleSummaryCard`'s source wasn't available to compare.
class StatCardRow extends StatelessWidget {
  final List<StatCardItem> items;
  final double spacing;

  const StatCardRow({super.key, required this.items, this.spacing = 8});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            _StatCard(item: items[i]),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final StatCardItem item;

  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.fieldFill),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.label,
                style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                item.value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
