/// A selectable paint coverage rate (sq ft covered per gallon).
class PaintCoverageOption {
  final String id;
  final String label;
  final double sqFtPerGallon;

  const PaintCoverageOption({
    required this.id,
    required this.label,
    required this.sqFtPerGallon,
  });
}
