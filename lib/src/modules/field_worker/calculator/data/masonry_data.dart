
import '../models/masonry_models.dart';

/// Reference brick/block dimensions and mortar joint options.
///
/// Dimensions reflect common nominal industry sizes (incl. a standard
/// mortar joint) and `unitsPerBag` values are rough rule-of-thumb figures —
/// treat both as a reasonable default, not a certified spec. Structured as
/// static config today so it can become a fetched/regional catalog later
/// without touching the form or logic layers.
class MasonryData {
  static const unitTypes = <MasonryUnitType>[
    MasonryUnitType(
      id: 'standard_brick',
      label: 'Standard Brick (8"x2.25"x3.75")',
      lengthIn: 8,
      heightIn: 2.25,
      widthIn: 3.75,
      unitsPerBag: 30,
      pluralLabel: 'bricks',
    ),
    MasonryUnitType(
      id: 'queen_brick',
      label: 'Queen Brick (7.625"x2.75"x3")',
      lengthIn: 7.625,
      heightIn: 2.75,
      widthIn: 3,
      unitsPerBag: 33,
      pluralLabel: 'bricks',
    ),
    MasonryUnitType(
      id: 'king_brick',
      label: 'King Brick (9.625"x2.75"x3.625")',
      lengthIn: 9.625,
      heightIn: 2.75,
      widthIn: 3.625,
      unitsPerBag: 24,
      pluralLabel: 'bricks',
    ),
    MasonryUnitType(
      id: 'cmu_block',
      label: 'CMU Block (16"x8"x8")',
      lengthIn: 16,
      heightIn: 8,
      widthIn: 8,
      unitsPerBag: 13,
      pluralLabel: 'blocks',
    ),
  ];

  static const jointOptions = <MortarJointOption>[
    MortarJointOption(id: '1_4', label: '1/4"', thicknessIn: 0.25),
    MortarJointOption(id: '3_8', label: '3/8"', thicknessIn: 0.375),
    MortarJointOption(id: '1_2', label: '1/2"', thicknessIn: 0.5),
    MortarJointOption(id: '5_8', label: '5/8"', thicknessIn: 0.625),
  ];

  /// Default selected joint thickness, matching the reference design (3/8").
  static MortarJointOption get defaultJoint => jointOptions[1];
}
