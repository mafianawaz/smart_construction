
import '../../../../widgets/pill_tab_group.dart';
import '../models/lumber_framing_models.dart';

/// Reference config for the Lumber & Framing calculator's three sub-modes.
class LumberFramingData {
  static List<PillTabItem<LumberCalculatorMode>> get modeTabs => const [
        PillTabItem(value: LumberCalculatorMode.joistRafter, label: 'Joist/Rafter'),
        PillTabItem(value: LumberCalculatorMode.studCalculator, label: 'Stud Calculator'),
        PillTabItem(value: LumberCalculatorMode.boardFeet, label: 'Board Feet'),
      ];

  static const spacingOptions = <SpacingOption>[
    SpacingOption(id: '12', label: '12" o.c.', inches: 12),
    SpacingOption(id: '16', label: '16" o.c.', inches: 16),
    SpacingOption(id: '19_2', label: '19.2" o.c.', inches: 19.2),
    SpacingOption(id: '24', label: '24" o.c.', inches: 24),
  ];

  /// Default matches the reference design (16" o.c.).
  static SpacingOption get defaultSpacing => spacingOptions[1];

  // Actual (dressed) dimensions for common nominal dimensional lumber sizes.
  static const lumberSizes = <LumberSizeOption>[
    LumberSizeOption(id: '2x4', label: '2x4', actualThicknessIn: 1.5, actualWidthIn: 3.5),
    LumberSizeOption(id: '2x6', label: '2x6', actualThicknessIn: 1.5, actualWidthIn: 5.5),
    LumberSizeOption(id: '2x8', label: '2x8', actualThicknessIn: 1.5, actualWidthIn: 7.25),
    LumberSizeOption(id: '2x10', label: '2x10', actualThicknessIn: 1.5, actualWidthIn: 9.25),
    LumberSizeOption(id: '2x12', label: '2x12', actualThicknessIn: 1.5, actualWidthIn: 11.25),
  ];

  /// Default matches the reference design (2x8).
  static LumberSizeOption get defaultSize => lumberSizes[2];
}
