import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';

import '../../../../utils/app_color.dart';
import '../data/roofing_data.dart';
import '../logic.dart';
import '../models/roofing_models.dart';
import 'calculator_results_card.dart';


class RoofingForm extends StatelessWidget {
  const RoofingForm({super.key, required this.logic});

  final CalculatorLogic logic;

  static const _resultLabels = {
    'roofArea': 'Roofing Area',
    'roofingSquares': 'Roofing Squares',
    'materialUnits': 'Material Needed',
    'underlaymentRolls': 'Underlayment Rolls',
    'ridgeCapLinearFt': 'Ridge Cap (linear ft)',
    'dripEdgeLinearFt': 'Drip Edge (linear ft)',
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
                heading: 'Building Length (ft)',
                hintText: 'e.g. 50',
                controller: logic.roofingBuildingLengthController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Building Width (ft)',
                hintText: 'e.g. 30',
                controller: logic.roofingBuildingWidthController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          heading: 'Overhang (inches)',
          hintText: 'e.g. 12',
          controller: logic.roofingOverhangController,
        ),
        const SizedBox(height: 16),
        CustomDropdown<RoofPitchOption>(
          heading: 'Roof Pitch',
          items: RoofingData.pitchOptions,
          value: logic.roofingSelectedPitch,
          itemLabel: (p) => p.label,
          onChanged: logic.roofingSetPitch,
        ),
        const SizedBox(height: 16),
        CustomDropdown<RoofMaterialOption>(
          heading: 'Material Type',
          items: RoofingData.materialOptions,
          value: logic.roofingSelectedMaterial,
          itemLabel: (m) => m.label,
          onChanged: logic.roofingSetMaterial,
        ),
        const SizedBox(height: 16),
        if (logic.roofingResults.isNotEmpty) ...[
          CalculatorResultsCard(
            items: [
              for (final entry in logic.roofingResults.entries)
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
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Waste Factor (%)',
                hintText: 'e.g. 10',
                controller: logic.roofingWasteFactorController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Unit Price per Square',
                hintText: 'optional',
                controller: logic.roofingUnitPriceController,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
