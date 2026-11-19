import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import 'cost_book_palette.dart';

/// Bold section title + muted description, with an optional trailing widget
/// (the "+ Add Region" button on Geo Factors).
class CostBookSectionHeading extends StatelessWidget {
  final String title;
  final String description;
  final Widget? trailing;

  const CostBookSectionHeading({
    super.key,
    required this.title,
    required this.description,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: CostBookPalette.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.4,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}
