import '../models/tiling_models.dart';

/// Reference tile size, grout joint, and pattern options for the Tiling &
/// Flooring calculator.
class TilingData {
  static const tileSizeOptions = <TileSizeOption>[
    TileSizeOption(id: '12x12', label: '12"x12"', areaSqFt: 1.0),
    TileSizeOption(id: '12x24', label: '12"x24"', areaSqFt: 2.0),
    TileSizeOption(id: '18x18', label: '18"x18"', areaSqFt: 2.25),
    TileSizeOption(id: '24x24', label: '24"x24"', areaSqFt: 4.0),
    TileSizeOption(id: '6x6', label: '6"x6"', areaSqFt: 0.25),
  ];

  /// Default matches the reference design (12"x12").
  static TileSizeOption get defaultTileSize => tileSizeOptions.first;

  static const groutJointOptions = <GroutJointOption>[
    GroutJointOption(id: '1_16', label: '1/16"', thicknessIn: 0.0625),
    GroutJointOption(id: '1_8', label: '1/8"', thicknessIn: 0.125),
    GroutJointOption(id: '3_16', label: '3/16"', thicknessIn: 0.1875),
    GroutJointOption(id: '1_4', label: '1/4"', thicknessIn: 0.25),
  ];

  /// Default matches the reference design (1/8").
  static GroutJointOption get defaultGroutJoint => groutJointOptions[1];

  static const patternOptions = <TilePatternOption>[
    TilePatternOption(id: 'standard_grid', label: 'Standard Grid', extraWastePercent: 0),
    TilePatternOption(id: 'brick_offset', label: 'Brick / Offset', extraWastePercent: 5),
    TilePatternOption(id: 'diagonal', label: 'Diagonal', extraWastePercent: 15),
    TilePatternOption(id: 'herringbone', label: 'Herringbone', extraWastePercent: 15),
  ];

  /// Default matches the reference design (Standard Grid).
  static TilePatternOption get defaultPattern => patternOptions.first;

  /// Placeholder: baseline grout coverage at a 1/8" joint (sq ft per bag of
  /// standard grout). Scaled by joint width relative to this baseline in
  /// [CalculatorLogic] — verify against your grout supplier's spec.
  static const double baselineGroutSqFtPerBag = 50;
  static const double baselineJointIn = 0.125;
}
