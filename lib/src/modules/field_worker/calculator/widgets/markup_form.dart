import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../logic.dart';
import 'calculator_results_card.dart';
import 'percentage_slider_field.dart';


class MarkupForm extends StatelessWidget {
  const MarkupForm({super.key, required this.logic});

  final CalculatorLogic logic;

  static const _resultLabels = {
    'directCost': 'Direct Cost',
    'overheadAmount': 'Overhead Amount',
    'profitAmount': 'Profit Amount',
    'finalBidPrice': 'Final Bid Price',
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
                controller: logic.mkMaterialCostController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Labor Cost (\$)',
                hintText: 'e.g. 5',
                controller: logic.mkLaborCostController,
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
                controller: logic.mkEquipmentCostController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Subcontractor Cost (\$)',
                hintText: 'e.g. 5',
                controller: logic.mkSubcontractorCostController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          heading: 'Consumable Cost (\$)',
          hintText: 'e.g. 1',
          controller: logic.mkConsumableCostController,
        ),
        const SizedBox(height: 20),
        PercentageSliderField(
          label: 'Overhead Percentage',
          value: logic.mkOverheadPercent,
          onChanged: logic.mkSetOverheadPercent,
        ),
        const SizedBox(height: 20),
        PercentageSliderField(
          label: 'Profit Percentage',
          value: logic.mkProfitPercent,
          onChanged: logic.mkSetProfitPercent,
        ),
        const SizedBox(height: 16),
        if (logic.mkResults.isNotEmpty)
          CalculatorResultsCard(
            items: [
              for (final entry in logic.mkResults.entries)
                CalculatorResultItem(_resultLabels[entry.key] ?? entry.key, entry.value),
            ],
          ),
      ],
    );
  }
}
