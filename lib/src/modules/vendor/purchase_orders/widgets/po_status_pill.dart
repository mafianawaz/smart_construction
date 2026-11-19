import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/purchase_order_model.dart';

/// Local status pill, following the same pattern as `_StatusDotPill` in
/// the Enrolled Clients module — confirmed `PillChip` has no dot/icon
/// slot, so status badges with a leading dot are built as a small local
/// widget per module rather than forced into `PillChip`.
class PoStatusPill extends StatelessWidget {
  final PurchaseOrderStatus status;

  const PoStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(status.icon, height: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
