import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/pill_tab_group.dart';
import 'data/calculator_category_data.dart';
import 'data/unit_conversion_data.dart';
import 'logic.dart';
import 'models/calculator_models.dart';
import 'widgets/aggregates_form.dart';
import 'widgets/concrete_materials_form.dart';
import 'widgets/drywall_form.dart';
import 'widgets/geometry_form.dart';
import 'widgets/labor_cost_form.dart';
import 'widgets/lumber_framing_form.dart';
import 'widgets/markup_form.dart';
import 'widgets/masonry_form.dart';
import 'widgets/paint_coating_form.dart';
import 'widgets/profit_margin_form.dart';
import 'widgets/roofing_form.dart';
import 'widgets/tiling_flooring_form.dart';
import 'widgets/unit_converter_card.dart';


class CalculatorView extends StatelessWidget {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CalculatorLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Calculator',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calculate unit conversion, material estimation and cost',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 20),

                // --- Category selector (reusable PillTabGroup) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Select a calculator type',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                PillTabGroup<CalculatorCategory>(
                  items: CalculatorCategoryData.tabs,
                  selectedValue: logic.selectedCategory,
                  onChanged: logic.changeCategory,
                  style: PillTabStyle.filled,
                ),
                const SizedBox(height: 20),

                // --- Category-specific content ---
                _CategorySection(logic: logic),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Wraps whichever category's form is active in the same bordered card
/// treatment (title + description + form), so every category looks
/// consistent regardless of which one is selected.
class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.logic});

  final CalculatorLogic logic;

  static const _titles = {
    CalculatorCategory.unitConverter: 'Unit Converter',
    CalculatorCategory.concreteMaterials: 'Concrete & Materials',
    CalculatorCategory.masonry: 'Masonry Calculator',
    CalculatorCategory.lumberFraming: 'Lumber & Framing Calculator',
    CalculatorCategory.roofing: 'Roofing Calculator',
    CalculatorCategory.tilingFlooring: 'Tiling & Flooring Calculator',
    CalculatorCategory.drywall: 'Drywall Calculator',
    CalculatorCategory.paintCoating: 'Paint & Coating Calculator',
    CalculatorCategory.aggregates: 'Aggregates Calculator',
    CalculatorCategory.geometry: 'Geometry Calculator',
    CalculatorCategory.profitMargin: 'Profit Margin Calculator',
    CalculatorCategory.markup: 'Markup Calculator',
    CalculatorCategory.laborCost: 'Labor Cost Calculator',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.fieldBorder),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _titles[logic.selectedCategory] ?? '',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
          ),
          const SizedBox(height: 4),
          Text(
            CalculatorCategoryData.descriptionFor(logic.selectedCategory),
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    switch (logic.selectedCategory) {
      case CalculatorCategory.unitConverter:
        return _UnitConverterFields(logic: logic);
      case CalculatorCategory.concreteMaterials:
        return ConcreteMaterialsForm(logic: logic);
      case CalculatorCategory.masonry:
        return MasonryForm(logic: logic);
      case CalculatorCategory.lumberFraming:
        return LumberFramingForm(logic: logic);
      case CalculatorCategory.roofing:
        return RoofingForm(logic: logic);
      case CalculatorCategory.tilingFlooring:
        return TilingFlooringForm(logic: logic);
      case CalculatorCategory.drywall:
        return DrywallForm(logic: logic);
      case CalculatorCategory.paintCoating:
        return PaintCoatingForm(logic: logic);
      case CalculatorCategory.aggregates:
        return AggregatesForm(logic: logic);
      case CalculatorCategory.geometry:
        return GeometryForm(logic: logic);
      case CalculatorCategory.profitMargin:
        return ProfitMarginForm(logic: logic);
      case CalculatorCategory.markup:
        return MarkupForm(logic: logic);
      case CalculatorCategory.laborCost:
        return LaborCostForm(logic: logic);
    }
  }
}

class _UnitConverterFields extends StatelessWidget {
  const _UnitConverterFields({required this.logic});

  final CalculatorLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Subcategory selector (reusable PillTabGroup, segmented style) ---
        PillTabGroup<UnitConverterType>(
          items: UnitConversionData.typeTabs,
          selectedValue: logic.selectedUnitType,
          onChanged: logic.changeUnitType,
          style: PillTabStyle.segmented,
          scrollable: false,
          fillWidth: false,
        ),
        const SizedBox(height: 20),

        UnitConverterCard(logic: logic),
      ],
    );
  }
}
