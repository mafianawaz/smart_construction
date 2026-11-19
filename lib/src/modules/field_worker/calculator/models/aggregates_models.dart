/// A selectable aggregate/fill material, carrying a typical density used as
/// an editable default for the Density field.
class AggregateMaterialOption {
  final String id;
  final String label;
  final double defaultDensityTonsPerCuYd;

  const AggregateMaterialOption({
    required this.id,
    required this.label,
    required this.defaultDensityTonsPerCuYd,
  });
}
