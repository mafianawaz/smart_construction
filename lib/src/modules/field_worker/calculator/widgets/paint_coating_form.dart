import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';

import '../../../../utils/app_color.dart';
import '../data/paint_coating_data.dart';
import '../logic.dart';
import '../models/paint_coating_models.dart';
import 'calculator_results_card.dart';


class PaintCoatingForm extends StatelessWidget {
  const PaintCoatingForm({super.key, required this.logic});

  final CalculatorLogic logic;

  static const _includeCeilingOptions = ['Yes', 'No'];

  static const _resultLabels = {
    'paintableArea': 'Paintable Area',
    'gallonsNeeded': 'Gallons Needed',
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
                heading: 'Room Length (ft)',
                hintText: 'e.g. 12',
                controller: logic.paintRoomLengthController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Room Width (ft)',
                hintText: 'e.g. 10',
                controller: logic.paintRoomWidthController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          heading: 'Wall Height (ft)',
          hintText: 'e.g. 8',
          controller: logic.paintWallHeightController,
        ),
        const SizedBox(height: 16),
        CustomDropdown<String>(
          heading: 'Include Ceiling',
          items: _includeCeilingOptions,
          value: logic.paintIncludeCeiling ? 'Yes' : 'No',
          itemLabel: (v) => v,
          onChanged: (v) => logic.paintSetIncludeCeiling(v == 'Yes'),
        ),
        const SizedBox(height: 16),
        CustomDropdown<int>(
          heading: 'No of Coats',
          items: PaintCoatingData.coatsOptions,
          value: logic.paintSelectedCoats,
          itemLabel: (v) => '$v',
          onChanged: logic.paintSetCoats,
        ),
        const SizedBox(height: 16),
        CustomDropdown<PaintCoverageOption>(
          heading: 'Coverage (sq ft/gal)',
          items: PaintCoatingData.coverageOptions,
          value: logic.paintSelectedCoverage,
          itemLabel: (v) => v.label,
          onChanged: logic.paintSetCoverage,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'No of Doors',
                hintText: 'e.g. 1',
                controller: logic.paintDoorsCountController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'No of windows',
                hintText: 'e.g. 1',
                controller: logic.paintWindowsCountController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                '21 sq ft each',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '16 sq ft each',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          heading: 'Price per Gallon (\$)',
          hintText: 'optional',
          controller: logic.paintPricePerGallonController,
        ),
        const SizedBox(height: 16),
        if (logic.paintResults.isNotEmpty)
          CalculatorResultsCard(
            items: [
              for (final entry in logic.paintResults.entries)
                CalculatorResultItem(_resultLabels[entry.key] ?? entry.key, entry.value),
            ],
          ),
      ],
    );
  }
}
