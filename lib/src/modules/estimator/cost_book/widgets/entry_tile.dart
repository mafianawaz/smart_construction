import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/cost_book_models.dart';
import 'cost_book_card.dart';
import 'cost_book_palette.dart';
import 'cost_figure.dart';

/// One published line item: code + unit tag, description, then
/// MAT / LABOR / EQUIP / TOTAL figures.
class EntryTile extends StatelessWidget {
  final CostBookEntryModel entry;

  const EntryTile({super.key, required this.entry});

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
                  entry.code,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: CostBookPalette.ink,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: CostBookPalette.unitBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  entry.unit,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            entry.description,
            style: const TextStyle(
              fontSize: 11,
              height: 1.4,
              color: CostBookPalette.ink,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CostFigure(label: 'MAT', value: formatCost(entry.material)),
              ),
              Expanded(
                child: CostFigure(label: 'LABOR', value: formatCost(entry.labor)),
              ),
              Expanded(
                child: CostFigure(
                  label: 'EQUIP',
                  value: formatCost(entry.equipment),
                ),
              ),
              Expanded(
                child: CostFigure(
                  label: 'TOTAL',
                  value: formatCost(entry.total),
                  accent: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
