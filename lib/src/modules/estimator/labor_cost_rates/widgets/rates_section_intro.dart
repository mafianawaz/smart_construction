import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import 'labor_rates_palette.dart';

/// Bold section title with a muted description under it.
class RatesSectionIntro extends StatelessWidget {
  final String title;
  final String description;

  const RatesSectionIntro({
    super.key,
    required this.title,
    required this.description,
  });

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
            color: LaborRatesPalette.ink,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: TextStyle(fontSize: 11, height: 1.4, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

/// White bordered rounded container shared by every list card on the screen.
class RatesCardShell extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const RatesCardShell({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LaborRatesPalette.cardBorder),
      ),
      child: child,
    );
  }
}
