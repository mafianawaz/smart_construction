import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';

import '../../../../utils/app_color.dart';
import '../../../../widgets/pill_tab_group.dart';
import '../../../../widgets/toggle_field_row.dart';
import '../data/concrete_materials_data.dart';
import '../logic.dart';
import 'calculator_results_card.dart';


class ConcreteMaterialsForm extends StatelessWidget {
  const ConcreteMaterialsForm({super.key, required this.logic});

  final CalculatorLogic logic;

  // Single option today; modeled as a dropdown so additional input modes
  // (e.g. "Radius (circular slab)") can be added later without reshaping
  // the widget — see NOTES_CALCULATOR.md.
  static const _inputModes = ['Length x Width (ft)'];

  static const _resultLabels = {
    'area': 'Area',
    'concreteVolume': 'Concrete Volume',
    'stoneAggregate': 'Stone / Aggregate',
    'excavation': 'Excavation',
    'reinforcement': 'Reinforcement',
    'sealer': 'Sealer',
    'underlayment': 'Underlayment / Vapor Barrier',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown(
          heading: 'Input Mode',
          items: _inputModes,
          value: _inputModes.first,
          onChanged: (_) {},
          itemLabel: (mode) => mode,
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Length (ft)',
                hintText: 'e.g. 10.0',
                controller: logic.lengthController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Width (ft)',
                hintText: 'e.g. 8.0',
                controller: logic.widthController,
              ),
            ),
          ],
        ),
        ToggleFieldRow(
          label: 'Concrete',
          value: logic.concreteEnabled,
          onChanged: logic.toggleConcrete,
        ),
        if (logic.concreteEnabled) ...[
          const SizedBox(height: 4),
          PillTabGroup(
            items: ConcreteMaterialsData.typeTabs,
            selectedValue: logic.selectedConcreteType,
            onChanged: logic.changeConcreteType,
            style: PillTabStyle.segmented,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  heading: 'Depth (inches)',
                  hintText: 'e.g. 4',
                  controller: logic.depthController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  heading: 'Waste Factor (%)',
                  hintText: 'e.g. 10',
                  controller: logic.wasteFactorController,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        Divider(color: AppColors.fieldBorder, height: 24),
        for (final option in ConcreteMaterialsData.additionalOptions)
          ToggleFieldRow(
            label: option.label,
            value: logic.additionalToggles[option.key] ?? false,
            onChanged: (value) => logic.toggleAdditionalOption(option.key, value),
          ),
        if (logic.concreteResults.isNotEmpty) ...[
          const SizedBox(height: 16),
          CalculatorResultsCard(
            items: [
              for (final entry in logic.concreteResults.entries)
                CalculatorResultItem(_resultLabels[entry.key] ?? entry.key, entry.value),
            ],
          ),
        ],
      ],
    );
  }
}
