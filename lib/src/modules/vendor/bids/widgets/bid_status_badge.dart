import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/bid_status.dart';

class BidStatusBadge extends StatelessWidget {
  final BidStatus status;
  final bool isBorder;

  const BidStatusBadge({super.key, required this.status, this.isBorder = false});

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: isBorder ? Border.all(color: color.withOpacity(0.4)) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(status.icon, height: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.label.toUpperCase(),
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
