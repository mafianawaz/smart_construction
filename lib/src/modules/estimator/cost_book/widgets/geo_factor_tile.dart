import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/cost_book_models.dart';
import 'cost_book_card.dart';
import 'cost_book_palette.dart';
import 'cost_figure.dart';

/// One region: "CODE — Name" title, edit/delete, city line and the three
/// multipliers.
class GeoFactorTile extends StatelessWidget {
  final GeoFactorModel factor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GeoFactorTile({
    super.key,
    required this.factor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return CostBookCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  factor.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: CostBookPalette.ink,
                  ),
                ),
              ),
              InkWell(
                onTap: onEdit,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 15,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: onDelete,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 15,
                    color: CostBookPalette.danger,
                  ),
                ),
              ),
            ],
          ),
          if (factor.locationLabel.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 13,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  factor.locationLabel,
                  style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CostFigure(
                  label: 'MAT MULT',
                  value: formatMult(factor.materialMult),
                ),
              ),
              Expanded(
                child: CostFigure(
                  label: 'LABOR MULT',
                  value: formatMult(factor.laborMult),
                ),
              ),
              Expanded(
                child: CostFigure(
                  label: 'EQUIP MULT',
                  value: formatMult(factor.equipmentMult),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
