import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import 'cost_colors.dart';

enum CostTagStyle { grey, orange }

/// Compact rounded tag ("MASONRY", "Concrete", "Code 34").
class CostTag extends StatelessWidget {
  final String label;
  final CostTagStyle style;

  const CostTag({super.key, required this.label, this.style = CostTagStyle.grey});

  @override
  Widget build(BuildContext context) {
    final isOrange = style == CostTagStyle.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isOrange ? CostColors.orangeSoft : CostColors.tagGrey,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isOrange ? AppColors.primaryOrange : CostColors.tagGreyText,
        ),
      ),
    );
  }
}
