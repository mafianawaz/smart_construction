import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';

import '../../../../utils/app_color.dart';
import '../data/drywall_data.dart';
import '../logic.dart';
import '../models/drywall_models.dart';
import 'calculator_results_card.dart';


class DrywallForm extends StatelessWidget {
  const DrywallForm({super.key, required this.logic});

  final CalculatorLogic logic;

  static const _includeCeilingOptions = ['Yes', 'No'];

  static const _resultLabels = {
    'wallArea': 'Wall Area',
    'ceilingArea': 'Ceiling Area',
    'totalArea': 'Total Area',
    'sheetsNeeded': 'Sheets Needed',
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
                controller: logic.drywallRoomLengthController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Room Width (ft)',
                hintText: 'e.g. 10',
                controller: logic.drywallRoomWidthController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Wall Height (ft)',
                hintText: 'e.g. 8',
                controller: logic.drywallWallHeightController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Waste Factor (%)',
                hintText: 'optional',
                controller: logic.drywallWasteFactorController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomDropdown<String>(
          heading: 'Include Ceiling',
          items: _includeCeilingOptions,
          value: logic.drywallIncludeCeiling ? 'Yes' : 'No',
          itemLabel: (v) => v,
          onChanged: (v) => logic.drywallSetIncludeCeiling(v == 'Yes'),
        ),
        const SizedBox(height: 16),
        CustomDropdown<DrywallSheetSizeOption>(
          heading: 'Sheet Size',
          items: DrywallData.sheetSizeOptions,
          value: logic.drywallSelectedSheetSize,
          itemLabel: (s) => s.label,
          onChanged: logic.drywallSetSheetSize,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'No of Doors',
                hintText: 'e.g. 1',
                controller: logic.drywallDoorsCountController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'No of windows',
                hintText: 'e.g. 1',
                controller: logic.drywallWindowsCountController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                "3'x7' or subtract sq ft each",
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "4'x4' or subtract sq ft each",
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          heading: 'Price per Sheet (\$)',
          hintText: 'optional',
          controller: logic.drywallPricePerSheetController,
        ),
        const SizedBox(height: 16),
        if (logic.drywallResults.isNotEmpty)
          CalculatorResultsCard(
            items: [
              for (final entry in logic.drywallResults.entries)
                CalculatorResultItem(_resultLabels[entry.key] ?? entry.key, entry.value),
            ],
          ),
      ],
    );
  }
}
