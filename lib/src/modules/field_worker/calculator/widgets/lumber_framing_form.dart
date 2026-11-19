import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../../../../widgets/app_textfield.dart';
import '../../../../widgets/custom_dropdown_button.dart';
import '../../../../widgets/pill_tab_group.dart';
import '../data/lumber_framing_data.dart';
import '../logic.dart';
import '../models/lumber_framing_models.dart';
import 'calculator_results_card.dart';


class LumberFramingForm extends StatelessWidget {
  const LumberFramingForm({super.key, required this.logic});

  final CalculatorLogic logic;

  static const _resultLabels = {
    'pieceCount': 'No. of Joists/Rafters',
    'rimBandLinearFt': 'Rim/Band Board (linear ft)',
    'boardFeet': 'Total Board Feet',
    'totalStuds': 'Total Studs',
    'plateLinearFt': 'Plate Linear Ft',
    'boardFeetPerPiece': 'Board Feet / Piece',
    'totalBoardFeet': 'Total Board Feet',
    'estimatedCost': 'Estimated Cost',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PillTabGroup<LumberCalculatorMode>(
          items: LumberFramingData.modeTabs,
          selectedValue: logic.lumberSelectedMode,
          onChanged: logic.lumberChangeMode,
          style: PillTabStyle.segmented,
          scrollable: false,
          fillWidth: true,
        ),
        const SizedBox(height: 20),
        _buildModeFields(logic),
        const SizedBox(height: 8),
        if (logic.lumberResults.isNotEmpty) ...[
          CalculatorResultsCard(
            items: [
              for (final entry in logic.lumberResults.entries)
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
                hintText: 'e.g. 4',
                controller: logic.lumberWasteFactorController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Unit Price per Piece',
                hintText: 'optional',
                controller: logic.lumberUnitPriceController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeFields(CalculatorLogic logic) {
    switch (logic.lumberSelectedMode) {
      case LumberCalculatorMode.joistRafter:
        return _JoistRafterFields(logic: logic);
      case LumberCalculatorMode.studCalculator:
        return _StudCalculatorFields(logic: logic);
      case LumberCalculatorMode.boardFeet:
        return _BoardFeetFields(logic: logic);
    }
  }
}

class _JoistRafterFields extends StatelessWidget {
  const _JoistRafterFields({required this.logic});

  final CalculatorLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          heading: 'Span Length (ft)',
          hintText: 'e.g. 50',
          controller: logic.lumberSpanLengthController,
        ),
        const SizedBox(height: 16),
        CustomDropdown<SpacingOption>(
          heading: 'Joist Spacing',
          items: LumberFramingData.spacingOptions,
          value: logic.lumberJoistSpacing,
          itemLabel: (s) => s.label,
          onChanged: logic.lumberSetJoistSpacing,
        ),
        const SizedBox(height: 16),
        CustomDropdown<LumberSizeOption>(
          heading: 'Joist Size',
          items: LumberFramingData.lumberSizes,
          value: logic.lumberJoistSize,
          itemLabel: (s) => s.label,
          onChanged: logic.lumberSetJoistSize,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _StudCalculatorFields extends StatelessWidget {
  const _StudCalculatorFields({required this.logic});

  final CalculatorLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Wall Length (ft)',
                hintText: 'e.g. 50',
                controller: logic.lumberWallLengthController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Wall Height (ft)',
                hintText: 'e.g. 50',
                controller: logic.lumberWallHeightController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Corner count',
                hintText: 'e.g. 5',
                controller: logic.lumberCornerCountController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Number of openings',
                hintText: 'e.g. 0',
                controller: logic.lumberOpeningCountController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomDropdown<SpacingOption>(
          heading: 'Stud spacing',
          items: LumberFramingData.spacingOptions,
          value: logic.lumberStudSpacing,
          itemLabel: (s) => s.label,
          onChanged: logic.lumberSetStudSpacing,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _BoardFeetFields extends StatelessWidget {
  const _BoardFeetFields({required this.logic});

  final CalculatorLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Thickness (inches)',
                hintText: 'e.g. 1',
                controller: logic.lumberThicknessController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Width (inches)',
                hintText: 'e.g. 5',
                controller: logic.lumberWidthController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Length (ft)',
                hintText: 'e.g. 5',
                controller: logic.lumberLengthController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Quantity',
                hintText: 'e.g. 0',
                controller: logic.lumberQuantityController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
