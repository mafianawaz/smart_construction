import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';
import '../data/profit_margin_data.dart';
import '../logic.dart';
import 'calculator_results_card.dart';
import 'percentage_slider_field.dart';


class ProfitMarginForm extends StatelessWidget {
  const ProfitMarginForm({super.key, required this.logic});

  final CalculatorLogic logic;

  static const _resultLabels = {
    'totalCost': 'Total Cost',
    'profitAmount': 'Profit Amount',
    'bidPrice': 'Total Bid Price',
    'pricePerUnit': 'Price per Unit',
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
                heading: 'Material Cost (\$)',
                hintText: 'e.g. 1',
                controller: logic.pmMaterialCostController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Labor Cost (\$)',
                hintText: 'e.g. 5',
                controller: logic.pmLaborCostController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Equipment Cost (\$)',
                hintText: 'e.g. 1',
                controller: logic.pmEquipmentCostController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Subcontractor Cost (\$)',
                hintText: 'e.g. 5',
                controller: logic.pmSubcontractorCostController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          heading: 'Overhead Cost (\$) (optional)',
          hintText: 'e.g. 1',
          controller: logic.pmOverheadCostController,
        ),
        const SizedBox(height: 20),
        PercentageSliderField(
          label: 'Desired Profit Margin',
          value: logic.pmDesiredMargin,
          onChanged: logic.pmSetMargin,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          heading: 'Quantity (optional)',
          hintText: 'e.g. 1',
          controller: logic.pmQuantityController,
        ),
        const SizedBox(height: 16),
        CustomDropdown<String>(
          heading: 'Unit',
          items: ProfitMarginData.unitOptions,
          value: logic.pmSelectedUnit,
          itemLabel: (v) => v,
          onChanged: logic.pmSetUnit,
        ),
        const SizedBox(height: 16),
        if (logic.pmResults.isNotEmpty)
          CalculatorResultsCard(
            items: [
              for (final entry in logic.pmResults.entries)
                CalculatorResultItem(_resultLabels[entry.key] ?? entry.key, entry.value),
            ],
          ),
      ],
    );
  }
}
