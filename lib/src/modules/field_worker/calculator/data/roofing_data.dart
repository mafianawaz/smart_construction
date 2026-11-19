import '../models/roofing_models.dart';

/// Reference pitch and material options for the Roofing calculator.
///
/// `unitsPerSquare` and roll/linear-ft coverage figures used alongside this
/// data (see [CalculatorLogic]) are rule-of-thumb placeholders — verify
/// against manufacturer spec sheets before using for real orders.
class RoofingData {
  static const pitchOptions = <RoofPitchOption>[
    RoofPitchOption(id: '3_12', label: '3/12', riseIn: 3),
    RoofPitchOption(id: '4_12', label: '4/12', riseIn: 4),
    RoofPitchOption(id: '6_12', label: '6/12', riseIn: 6),
    RoofPitchOption(id: '8_12', label: '8/12', riseIn: 8),
    RoofPitchOption(id: '10_12', label: '10/12', riseIn: 10),
    RoofPitchOption(id: '12_12', label: '12/12', riseIn: 12),
  ];

  /// Default matches the reference design (6/12).
  static RoofPitchOption get defaultPitch => pitchOptions[2];

  static const materialOptions = <RoofMaterialOption>[
    RoofMaterialOption(
      id: 'architectural_shingles',
      label: 'Architectural Shingles',
      unitsPerSquare: 3,
      pluralLabel: 'bundles',
    ),
    RoofMaterialOption(
      id: '3tab_shingles',
      label: '3-Tab Shingles',
      unitsPerSquare: 3,
      pluralLabel: 'bundles',
    ),
    RoofMaterialOption(
      id: 'metal_panels',
      label: 'Metal Panels',
      unitsPerSquare: 1,
      pluralLabel: 'panels',
    ),
    RoofMaterialOption(
      id: 'clay_tile',
      label: 'Clay Tile',
      unitsPerSquare: 9,
      pluralLabel: 'tiles',
    ),
  ];

  /// Default matches the reference design (Architectural Shingles).
  static RoofMaterialOption get defaultMaterial => materialOptions.first;

  /// Placeholder: synthetic underlayment roll coverage (sq ft/roll).
  static const double underlaymentSqFtPerRoll = 400;
}
