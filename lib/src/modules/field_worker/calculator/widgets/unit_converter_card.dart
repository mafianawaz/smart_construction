import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';

import '../../../../utils/app_color.dart';
import '../../../../widgets/app_textfield.dart';
import '../data/unit_conversion_data.dart';
import '../logic.dart';
import '../models/calculator_models.dart';


class UnitConverterCard extends StatelessWidget {
  const UnitConverterCard({super.key, required this.logic});

  final CalculatorLogic logic;

  @override
  Widget build(BuildContext context) {
    final units = UnitConversionData.unitsFor(logic.selectedUnitType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          heading: 'Value',
          hintText: 'Enter value',
          controller: logic.valueController,
        ),
        const SizedBox(height: 15),
        CustomDropdown<UnitDefinition>(
          heading: 'From',
          items: units,
          value: logic.fromUnit,
          onChanged: logic.setFromUnit,
          itemLabel: (unit) => unit.label,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _SwapButton(onTap: logic.swapUnits),
          ),
        ),
        CustomDropdown<UnitDefinition>(
          heading: 'To',
          items: units,
          value: logic.toUnit,
          onChanged: logic.setToUnit,
          itemLabel: (unit) => unit.label,
        ),
        const SizedBox(height: 15),
        _ResultBox(
          hasResult: logic.convertedResult.isNotEmpty,
          text: logic.convertedResult.isEmpty
              ? 'Enter a value to see the conversion result'
              : '${logic.valueController.text} ${logic.fromUnit?.label} = '
                  '${logic.convertedResult} ${logic.toUnit?.label}',
        ),
      ],
    );
  }
}

class _SwapButton extends StatelessWidget {
  const _SwapButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: AppColors.primaryOrange, shape: BoxShape.circle),
        child: const Icon(Icons.swap_vert, color: Colors.white, size: 20),
      ),
    );
  }
}

class _ResultBox extends StatelessWidget {
  const _ResultBox({required this.hasResult, required this.text});

  final bool hasResult;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: hasResult ? AppColors.textDark : AppColors.textMuted,
          fontWeight: hasResult ? FontWeight.w600 : FontWeight.w400,
          fontSize: 14,
        ),
      ),
    );
  }
}
