/// A selectable roof pitch, expressed as rise per 12" of run (e.g. "6/12").
/// `riseIn` is the rise value used to compute the slope multiplier:
/// `sqrt(1 + (riseIn / 12)^2)`.
class RoofPitchOption {
  final String id;
  final String label;
  final double riseIn;

  const RoofPitchOption({required this.id, required this.label, required this.riseIn});
}

/// A selectable roofing material, carrying the rule-of-thumb bundle/unit
/// coverage used to convert roofing squares into purchasable units.
class RoofMaterialOption {
  final String id;
  final String label;
  final double unitsPerSquare;
  final String pluralLabel;

  const RoofMaterialOption({
    required this.id,
    required this.label,
    required this.unitsPerSquare,
    required this.pluralLabel,
  });
}
