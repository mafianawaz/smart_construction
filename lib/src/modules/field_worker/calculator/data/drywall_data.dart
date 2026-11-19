import '../models/drywall_models.dart';

/// Reference sheet size options and opening-deduction assumptions for the
/// Drywall calculator.
class DrywallData {
  static const sheetSizeOptions = <DrywallSheetSizeOption>[
    DrywallSheetSizeOption(id: '4x8', label: "4' x 8'", areaSqFt: 32),
    DrywallSheetSizeOption(id: '4x10', label: "4' x 10'", areaSqFt: 40),
    DrywallSheetSizeOption(id: '4x12', label: "4' x 12'", areaSqFt: 48),
  ];

  /// Default matches the reference design (4' x 8').
  static DrywallSheetSizeOption get defaultSheetSize => sheetSizeOptions.first;

  /// Placeholder: standard interior door opening (3' x 7').
  static const double doorAreaSqFt = 3 * 7;

  /// Placeholder: average window opening (4' x 4') — swap in real per-window
  /// dimensions if you'd rather ask the user for width/height directly.
  static const double windowAreaSqFt = 4 * 4;
}
