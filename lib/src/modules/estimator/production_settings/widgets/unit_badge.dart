import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import 'production_palette.dart';

/// Small unit tag in a card's top-right corner (SF, EA, LF). Orange for
/// area units, blue for the rest, as the two frames show.
class UnitBadge extends StatelessWidget {
  final String unit;

  const UnitBadge({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final area = unit == 'SF' || unit == 'SY';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: area ? ProductionPalette.orangeTint : ProductionPalette.blueBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        unit,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: area ? AppColors.primaryOrange : ProductionPalette.blueFg,
        ),
      ),
    );
  }
}
