/// A selectable tile size, e.g. "12"x12"".
class TileSizeOption {
  final String id;
  final String label;
  final double areaSqFt;

  const TileSizeOption({required this.id, required this.label, required this.areaSqFt});
}

/// A selectable grout joint width, e.g. "1/8"".
class GroutJointOption {
  final String id;
  final String label;
  final double thicknessIn;

  const GroutJointOption({required this.id, required this.label, required this.thicknessIn});
}

/// A selectable layout pattern. `extraWastePercent` is added on top of the
/// user's own waste factor since cuts for diagonal/offset patterns produce
/// more scrap than a plain grid.
class TilePatternOption {
  final String id;
  final String label;
  final double extraWastePercent;

  const TilePatternOption({
    required this.id,
    required this.label,
    required this.extraWastePercent,
  });
}
