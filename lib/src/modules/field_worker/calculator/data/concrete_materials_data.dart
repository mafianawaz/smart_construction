import '../../../../widgets/pill_tab_group.dart';
import '../models/calculator_models.dart';

/// Config + estimation math for the Concrete & Materials category.
///
/// IMPORTANT: the coefficients in [estimate] are reasonable placeholders
/// (documented per-item below) so the flow is fully working end-to-end,
/// but they have NOT been validated against real estimation standards.
/// See NOTES_CALCULATOR.md before shipping this to production.
class ConcreteMaterialsData {
  static List<PillTabItem<ConcreteMaterialType>> get typeTabs => const [
        PillTabItem(value: ConcreteMaterialType.singleArea, label: 'Single Area'),
        PillTabItem(value: ConcreteMaterialType.slabPart, label: 'Slab/Part'),
        PillTabItem(value: ConcreteMaterialType.footingWall, label: 'Footing/Wall'),
        PillTabItem(value: ConcreteMaterialType.columnPier, label: 'Column/Pier'),
      ];

  static const additionalOptions = <ConcreteAdditionalOption>[
    ConcreteAdditionalOption(key: 'stoneAggregate', label: 'Stone / Aggregate'),
    ConcreteAdditionalOption(key: 'excavation', label: 'Excavation'),
    ConcreteAdditionalOption(key: 'reinforcement', label: 'Reinforcement'),
    ConcreteAdditionalOption(key: 'sealer', label: 'Sealer'),
    ConcreteAdditionalOption(key: 'underlayment', label: 'Underlayment / Vapor Barrier'),
  ];

  /// Returns a human-readable estimate line for a given additional option.
  /// `areaSqFt` = length * width. `depthInches` = concrete pour depth.
  static String estimate(String key, double areaSqFt, double depthInches) {
    switch (key) {
      case 'stoneAggregate':
        // Placeholder: assumes a 4" compacted base layer under the slab.
        final cuFt = areaSqFt * (4 / 12);
        return '${cuFt.toStringAsFixed(2)} cu ft base material';
      case 'excavation':
        // Placeholder: pour depth + 4" for base/formwork clearance.
        final cuFt = areaSqFt * ((depthInches + 4) / 12);
        return '${cuFt.toStringAsFixed(2)} cu ft to excavate';
      case 'reinforcement':
        // Placeholder: standard 4x8 ft welded wire mesh sheets.
        final sheets = (areaSqFt / 32).ceil();
        return '$sheets mesh sheet(s) (4x8 ft)';
      case 'sealer':
        // Placeholder: ~250 sq ft coverage per gallon of sealer.
        final gallons = areaSqFt / 250;
        return '${gallons.toStringAsFixed(2)} gal sealer';
      case 'underlayment':
        // Placeholder: ~400 sq ft coverage per roll of vapor barrier.
        final rolls = (areaSqFt / 400).ceil();
        return '$rolls roll(s) vapor barrier';
      default:
        return '';
    }
  }
}
