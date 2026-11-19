import '../../../../widgets/pill_tab_group.dart';
import '../models/calculator_models.dart';

/// Static config for now; structured so a future
/// `CalculatorCategoryData.fetch()` API call can replace [tabs] without any
/// changes to [CalculatorView] or [CalculatorLogic].
class CalculatorCategoryData {
  static List<PillTabItem<CalculatorCategory>> get tabs => const [
        PillTabItem(value: CalculatorCategory.unitConverter, label: 'Unit Converter'),
        PillTabItem(value: CalculatorCategory.concreteMaterials, label: 'Concrete & Materials'),
        PillTabItem(value: CalculatorCategory.masonry, label: 'Masonry'),
        PillTabItem(value: CalculatorCategory.lumberFraming, label: 'Lumber & Framing'),
        PillTabItem(value: CalculatorCategory.roofing, label: 'Roofing'),
        PillTabItem(value: CalculatorCategory.tilingFlooring, label: 'Tiling & Flooring'),
        PillTabItem(value: CalculatorCategory.drywall, label: 'Drywall'),
        PillTabItem(value: CalculatorCategory.paintCoating, label: 'Paint & Coating'),
        PillTabItem(value: CalculatorCategory.aggregates, label: 'Aggregates'),
        PillTabItem(value: CalculatorCategory.geometry, label: 'Geometry'),
        PillTabItem(value: CalculatorCategory.profitMargin, label: 'Profit Margin'),
        PillTabItem(value: CalculatorCategory.markup, label: 'Markup'),
        PillTabItem(value: CalculatorCategory.laborCost, label: 'Labor Cost'),
      ];

  static String descriptionFor(CalculatorCategory category) {
    switch (category) {
      case CalculatorCategory.unitConverter:
        return 'Convert between construction units of length, area, and volume.';
      case CalculatorCategory.concreteMaterials:
        return 'Calculate concrete volume, material estimator, and cost.';
      case CalculatorCategory.masonry:
        return 'Estimate brick, block, and mortar requirements for masonry walls.';
      case CalculatorCategory.lumberFraming:
        return 'Calculate board feet, stud count, and framing material.';
      case CalculatorCategory.roofing:
        return 'Estimate roofing area, squares, and material quantities.';
      case CalculatorCategory.tilingFlooring:
        return 'Estimate tile, grout, and flooring coverage.';
      case CalculatorCategory.drywall:
        return 'Calculate drywall sheets, joint compound, and coverage requirements.';
      case CalculatorCategory.paintCoating:
        return 'Calculate paint coverage, gallons needed, and coating costs.';
      case CalculatorCategory.aggregates:
        return 'Estimate gravel, sand, and fill material volume and tonnage.';
      case CalculatorCategory.geometry:
        return 'Calculate area, volume, angles, and geometric conversions.';
      case CalculatorCategory.profitMargin:
        return 'Calculate profit amount and total bid price based on project costs and desired margin.';
      case CalculatorCategory.markup:
        return 'Calculate overhead, profit, and final bid price from direct costs with separate markup percentages.';
      case CalculatorCategory.laborCost:
        return 'Calculate total labor costs including regular time, overtime, and burden/benefits.';
    }
  }
}
