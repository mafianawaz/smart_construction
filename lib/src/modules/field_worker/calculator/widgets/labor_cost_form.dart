import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../logic.dart';
import 'calculator_results_card.dart';
import 'percentage_slider_field.dart';


class LaborCostForm extends StatelessWidget {
  const LaborCostForm({super.key, required this.logic});

  final CalculatorLogic logic;

  static const _resultLabels = {
    'regularCost': 'Regular Cost',
    'overtimeCost': 'Overtime Cost',
    'burdenAmount': 'Benefits / Burden',
    'totalLaborCost': 'Total Labor Cost',
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
                heading: 'Hourly rate (\$)',
                hintText: 'e.g. 1',
                controller: logic.lcHourlyRateController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'No of Workers',
                hintText: 'e.g. 5',
                controller: logic.lcWorkersController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Hours per Day',
                hintText: 'e.g. 1',
                controller: logic.lcHoursPerDayController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'No of Days',
                hintText: 'e.g. 5',
                controller: logic.lcDaysController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          heading: 'Overtime Hours per Day (optional, 1.5x rate)',
          hintText: 'e.g. 1',
          controller: logic.lcOvertimeHoursController,
        ),
        const SizedBox(height: 20),
        PercentageSliderField(
          label: 'Benefits/ Burden Rate',
          value: logic.lcBenefitsBurdenRate,
          onChanged: logic.lcSetBurdenRate,
        ),
        const SizedBox(height: 16),
        if (logic.lcResults.isNotEmpty)
          CalculatorResultsCard(
            items: [
              for (final entry in logic.lcResults.entries)
                CalculatorResultItem(_resultLabels[entry.key] ?? entry.key, entry.value),
            ],
          ),
      ],
    );
  }
}
