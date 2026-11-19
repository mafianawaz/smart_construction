import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';

import '../../../../utils/app_color.dart';
import '../data/masonry_data.dart';
import '../logic.dart';
import '../models/masonry_models.dart';
import 'calculator_results_card.dart';


class MasonryForm extends StatelessWidget {
  const MasonryForm({super.key, required this.logic});

  final CalculatorLogic logic;

  static const _resultLabels = {
    'netArea': 'Net Wall Area',
    'units': 'Units Needed',
    'mortarBags': 'Mortar Bags',
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
                heading: 'Wall Length (ft)',
                hintText: 'e.g. 50',
                controller: logic.masonryWallLengthController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Wall Height (ft)',
                hintText: 'e.g. 50',
                controller: logic.masonryWallHeightController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomDropdown<MasonryUnitType>(
          heading: 'Block / Brick Type',
          items: MasonryData.unitTypes,
          value: logic.masonrySelectedUnitType,
          itemLabel: (type) => type.label,
          onChanged: logic.masonrySetUnitType,
        ),
        const SizedBox(height: 16),
        Divider(color: AppColors.textMuted, height: 1),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Openings (Doors / Windows)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
            _AddButton(onTap: logic.masonryAddOpening),
          ],
        ),
        for (final opening in logic.masonryOpenings) _OpeningRow(logic: logic, opening: opening),
        const SizedBox(height: 8),
        CustomDropdown<MortarJointOption>(
          heading: 'Mortar Joint Thickness',
          items: MasonryData.jointOptions,
          value: logic.masonrySelectedJoint,
          itemLabel: (joint) => joint.label,
          onChanged: logic.masonrySetJoint,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Unit Price (\$/each)',
                hintText: 'optional',
                controller: logic.masonryUnitPriceController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Mortar Price (\$/bag)',
                hintText: 'optional',
                controller: logic.masonryMortarPriceController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                'Price per brick or block',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Price per 80lb bag of mortar',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (logic.masonryResults.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Enter wall dimensions above to see calculated results',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          )
        else
          CalculatorResultsCard(
            items: [
              for (final entry in logic.masonryResults.entries)
                CalculatorResultItem(_resultLabels[entry.key] ?? entry.key, entry.value),
            ],
          ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: AppColors.primaryOrange, shape: BoxShape.circle),
        child: const Icon(Icons.add, color: Colors.white, size: 18),
      ),
    );
  }
}

class _OpeningRow extends StatelessWidget {
  const _OpeningRow({required this.logic, required this.opening});

  final CalculatorLogic logic;
  final MasonryOpening opening;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: CustomTextField(
              heading: 'Wall Length (ft)',
              hintText: 'e.g. 50',
              controller: opening.widthController,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomTextField(
              heading: 'Wall Height (ft)',
              hintText: 'e.g. 50',
              controller: opening.heightController,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => logic.masonryRemoveOpening(opening),
            icon: Icon(Icons.delete_outline, color: AppColors.textMuted),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}
