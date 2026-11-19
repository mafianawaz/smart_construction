import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';

import '../data/aggregates_data.dart';
import '../logic.dart';
import '../models/aggregates_models.dart';
import 'calculator_results_card.dart';


class AggregatesForm extends StatelessWidget {
  const AggregatesForm({super.key, required this.logic});

  final CalculatorLogic logic;

  static const _resultLabels = {
    'volume': 'Volume',
    'weight': 'Weight',
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
                heading: 'Length (ft)',
                hintText: 'e.g. 20',
                controller: logic.aggregatesLengthController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Width (ft)',
                hintText: 'e.g. 10',
                controller: logic.aggregatesWidthController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Depth (inches)',
                hintText: 'e.g. 4',
                controller: logic.aggregatesDepthController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Waste Factor (%)',
                hintText: 'e.g. 10',
                controller: logic.aggregatesWasteFactorController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomDropdown<AggregateMaterialOption>(
          heading: 'Material Type',
          items: AggregatesData.materialOptions,
          value: logic.aggregatesSelectedMaterial,
          itemLabel: (m) => m.label,
          onChanged: logic.aggregatesSetMaterial,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          heading: 'Density (tons/cu yd)',
          hintText: 'e.g. 1.4',
          controller: logic.aggregatesDensityController,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Price per Ton (\$)',
                hintText: 'optional',
                controller: logic.aggregatesPricePerTonController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Price per Cubic Yard (\$)',
                hintText: 'optional',
                controller: logic.aggregatesPricePerCubicYardController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (logic.aggregatesResults.isNotEmpty)
          CalculatorResultsCard(
            items: [
              for (final entry in logic.aggregatesResults.entries)
                CalculatorResultItem(_resultLabels[entry.key] ?? entry.key, entry.value),
            ],
          ),
      ],
    );
  }
}
