import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';

import '../../../../utils/app_color.dart';
import '../data/tiling_data.dart';
import '../logic.dart';
import '../models/tiling_models.dart';
import 'calculator_results_card.dart';


class TilingFlooringForm extends StatelessWidget {
  const TilingFlooringForm({super.key, required this.logic});

  final CalculatorLogic logic;

  static const _resultLabels = {
    'area': 'Area',
    'tilesNeeded': 'Tiles Needed',
    'boxesNeeded': 'Boxes Needed',
    'groutBags': 'Grout Bags',
    'estimatedCost': 'Estimated Cost',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Area Length (ft)',
                hintText: 'e.g. 12',
                controller: logic.tilingAreaLengthController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Area Width (ft)',
                hintText: 'e.g. 10',
                controller: logic.tilingAreaWidthController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomDropdown<TileSizeOption>(
          heading: 'Tile Size',
          items: TilingData.tileSizeOptions,
          value: logic.tilingSelectedTileSize,
          itemLabel: (t) => t.label,
          onChanged: logic.tilingSetTileSize,
        ),
        const SizedBox(height: 16),
        CustomDropdown<GroutJointOption>(
          heading: 'Grout Joint Width',
          items: TilingData.groutJointOptions,
          value: logic.tilingSelectedGroutJoint,
          itemLabel: (g) => g.label,
          onChanged: logic.tilingSetGroutJoint,
        ),
        const SizedBox(height: 16),
        CustomDropdown<TilePatternOption>(
          heading: 'Pattern',
          items: TilingData.patternOptions,
          value: logic.tilingSelectedPattern,
          itemLabel: (p) => p.label,
          onChanged: logic.tilingSetPattern,
        ),
        const SizedBox(height: 16),
        if (logic.tilingResults.isNotEmpty) ...[
          CalculatorResultsCard(
            items: [
              for (final entry in logic.tilingResults.entries)
                CalculatorResultItem(_resultLabels[entry.key] ?? entry.key, entry.value),
            ],
          ),
          const SizedBox(height: 16),
        ],
        Divider(color: AppColors.fieldBorder, height: 1),
        const SizedBox(height: 16),
        Text(
          'Common Settings',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          heading: 'Waste Factor (%)',
          hintText: 'e.g. 10',
          controller: logic.tilingWasteFactorController,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Price per Tile (\$)',
                hintText: 'optional',
                controller: logic.tilingPricePerTileController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Price per Box (\$)',
                hintText: 'optional',
                controller: logic.tilingPricePerBoxController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          heading: 'Tiles per box',
          hintText: 'optional',
          controller: logic.tilingTilesPerBoxController,
        ),
      ],
    );
  }
}
