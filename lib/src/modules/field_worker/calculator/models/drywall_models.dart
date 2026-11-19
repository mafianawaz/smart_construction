/// A selectable drywall sheet size, e.g. "4' x 8'".
class DrywallSheetSizeOption {
  final String id;
  final String label;
  final double areaSqFt;

  const DrywallSheetSizeOption({
    required this.id,
    required this.label,
    required this.areaSqFt,
  });
}
