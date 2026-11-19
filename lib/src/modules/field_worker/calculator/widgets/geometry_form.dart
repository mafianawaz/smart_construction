import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';

import '../../../../utils/app_color.dart';
import '../../../../widgets/pill_tab_group.dart';
import '../data/geometry_data.dart';
import '../logic.dart';
import '../models/geometry_models.dart';
import 'calculator_results_card.dart';


class GeometryForm extends StatelessWidget {
  const GeometryForm({super.key, required this.logic});

  final CalculatorLogic logic;

  static const _resultLabels = {
    'area': 'Area',
    'perimeter': 'Perimeter',
    'hypotenuse': 'Hypotenuse',
    'diameter': 'Diameter',
    'circumference': 'Circumference',
    'slopePercent': 'Slope',
    'angle': 'Angle',
    'pitch': 'Roof Pitch Equivalent',
    'error': 'Error',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PillTabGroup<GeometryShape>(
          items: GeometryData.shapeTabs,
          selectedValue: logic.geometrySelectedShape,
          onChanged: logic.geometryChangeShape,
          style: PillTabStyle.segmented,
          scrollable: false,
          fillWidth: true,
        ),
        const SizedBox(height: 20),
        _buildShapeFields(),
        const SizedBox(height: 8),
        if (logic.geometryResults.isNotEmpty)
          CalculatorResultsCard(
            items: [
              for (final entry in logic.geometryResults.entries)
                CalculatorResultItem(_resultLabels[entry.key] ?? entry.key, entry.value),
            ],
          ),
      ],
    );
  }

  Widget _buildShapeFields() {
    switch (logic.geometrySelectedShape) {
      case GeometryShape.rectangle:
        return _RectangleFields(logic: logic);
      case GeometryShape.triangle:
        return _TriangleFields(logic: logic);
      case GeometryShape.circle:
        return _CircleFields(logic: logic);
      case GeometryShape.slope:
        return _SlopeFields(logic: logic);
    }
  }
}

class _RectangleFields extends StatelessWidget {
  const _RectangleFields({required this.logic});

  final CalculatorLogic logic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            heading: 'Length (ft)',
            hintText: 'e.g. 1',
            controller: logic.geoRectLengthController,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomTextField(
            heading: 'Width (ft)',
            hintText: 'e.g. 5',
            controller: logic.geoRectWidthController,
          ),
        ),
      ],
    );
  }
}

class _TriangleFields extends StatelessWidget {
  const _TriangleFields({required this.logic});

  final CalculatorLogic logic;

  @override
  Widget build(BuildContext context) {
    final isThreeSides = logic.geoTriangleMode.mode == TriangleMode.threeSides;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown<TriangleModeOption>(
          heading: 'Triangle Mode',
          items: GeometryData.triangleModes,
          value: logic.geoTriangleMode,
          itemLabel: (m) => m.label,
          onChanged: logic.geometrySetTriangleMode,
        ),
        const SizedBox(height: 16),
        if (isThreeSides)
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  heading: 'Side A (ft)',
                  hintText: 'e.g. 3',
                  controller: logic.geoTriSideAController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  heading: 'Side B (ft)',
                  hintText: 'e.g. 4',
                  controller: logic.geoTriSideBController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  heading: 'Side C (ft)',
                  hintText: 'e.g. 5',
                  controller: logic.geoTriSideCController,
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  heading: 'Base (ft)',
                  hintText: 'e.g. 1',
                  controller: logic.geoTriBaseController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  heading: 'Height (ft)',
                  hintText: 'e.g. 5',
                  controller: logic.geoTriHeightController,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _CircleFields extends StatelessWidget {
  const _CircleFields({required this.logic});

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
                heading: 'Radius (ft)',
                hintText: 'e.g. 1',
                controller: logic.geoCircleRadiusController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Diameter (ft)',
                hintText: 'e.g. 1',
                controller: logic.geoCircleDiameterController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Fill in either field — the other is calculated automatically.',
          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _SlopeFields extends StatelessWidget {
  const _SlopeFields({required this.logic});

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
                heading: 'Rise (ft)',
                hintText: 'e.g. 1',
                controller: logic.geoSlopeRiseController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                heading: 'Run (ft)',
                hintText: 'e.g. 5',
                controller: logic.geoSlopeRunController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Auto-calculates from standard rise/run tables',
          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
