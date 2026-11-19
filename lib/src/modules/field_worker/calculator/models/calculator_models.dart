/// Top-level calculator categories, mapped to the orange "Unit Converter /
/// Concrete & Materials / Masonry" pill bar.
enum CalculatorCategory {
  unitConverter,
  concreteMaterials,
  masonry,
  lumberFraming,
  roofing,
  tilingFlooring,
  drywall,
  paintCoating,
  aggregates,
  geometry,
  profitMargin,
  markup,
  laborCost,
}

/// Unit Converter sub-tabs ("Length / Area / Volume").
enum UnitConverterType { length, area, volume }

/// Concrete & Materials sub-tabs.
enum ConcreteMaterialType { singleArea, slabPart, footingWall, columnPier }

/// A single convertible unit. All units within a [UnitConverterType] share
/// a common base (meters for length, sq meters for area, cubic meters for
/// volume) so any-to-any conversion is just `value * from.factorToBase /
/// to.factorToBase`.
class UnitDefinition {
  final String id;
  final String label;
  final double factorToBase;

  const UnitDefinition({
    required this.id,
    required this.label,
    required this.factorToBase,
  });
}

/// A togglable "additional material" line item shown under Concrete &
/// Materials (Stone/Aggregate, Excavation, Reinforcement, Sealer,
/// Underlayment/Vapor Barrier).
class ConcreteAdditionalOption {
  final String key;
  final String label;

  const ConcreteAdditionalOption({required this.key, required this.label});
}
