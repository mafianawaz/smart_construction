import '../models/paint_coating_models.dart';

/// Reference coats and coverage options for the Paint & Coating calculator.
class PaintCoatingData {
  static const coatsOptions = <int>[1, 2, 3, 4];

  /// Default matches the reference design (2 coats).
  static int get defaultCoats => 2;

  static const coverageOptions = <PaintCoverageOption>[
    PaintCoverageOption(id: '300', label: '300 sq ft/gal', sqFtPerGallon: 300),
    PaintCoverageOption(id: '350', label: '350 sq ft/gal', sqFtPerGallon: 350),
    PaintCoverageOption(id: '400', label: '400 sq ft/gal', sqFtPerGallon: 400),
  ];

  /// Default matches the reference design (400 sq ft/gal).
  static PaintCoverageOption get defaultCoverage => coverageOptions[2];

  // Reuses the same door/window opening assumptions as the Drywall
  // calculator (see drywall_data.dart) so the two stay consistent.
  static const double doorAreaSqFt = 21; // 3' x 7'
  static const double windowAreaSqFt = 16; // 4' x 4'
}
