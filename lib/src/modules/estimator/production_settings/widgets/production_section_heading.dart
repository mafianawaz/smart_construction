import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import 'production_palette.dart';

/// Bold title with an optional muted description.
class ProductionSectionHeading extends StatelessWidget {
  final String title;
  final String? description;

  const ProductionSectionHeading({super.key, required this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: ProductionPalette.ink,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 6),
          Text(
            description!,
            style: TextStyle(fontSize: 11, height: 1.4, color: AppColors.textMuted),
          ),
        ],
      ],
    );
  }
}
