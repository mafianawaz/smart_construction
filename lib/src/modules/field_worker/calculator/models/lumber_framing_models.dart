/// Lumber & Framing sub-tabs.
enum LumberCalculatorMode { joistRafter, studCalculator, boardFeet }

/// A selectable on-center framing spacing (studs, joists, or rafters).
class SpacingOption {
  final String id;
  final String label;
  final double inches;

  const SpacingOption({required this.id, required this.label, required this.inches});
}

/// A nominal lumber size with its actual (dressed) dimensions in inches,
/// used for board-feet and material calculations.
class LumberSizeOption {
  final String id;
  final String label;
  final double actualThicknessIn;
  final double actualWidthIn;

  const LumberSizeOption({
    required this.id,
    required this.label,
    required this.actualThicknessIn,
    required this.actualWidthIn,
  });
}
