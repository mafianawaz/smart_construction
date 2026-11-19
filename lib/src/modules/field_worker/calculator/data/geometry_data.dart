import '../../../../widgets/pill_tab_group.dart';
import '../models/geometry_models.dart';

/// Reference config for the Geometry calculator's shape sub-tabs and
/// Triangle input modes.
class GeometryData {
  static List<PillTabItem<GeometryShape>> get shapeTabs => const [
        PillTabItem(value: GeometryShape.rectangle, label: 'Rectangle'),
        PillTabItem(value: GeometryShape.triangle, label: 'Triangle'),
        PillTabItem(value: GeometryShape.circle, label: 'Circle'),
        PillTabItem(value: GeometryShape.slope, label: 'Slope'),
      ];

  static const triangleModes = <TriangleModeOption>[
    TriangleModeOption(mode: TriangleMode.rightTwoSides, label: 'Right Triangle (two sides)'),
    TriangleModeOption(mode: TriangleMode.baseHeight, label: 'Base & Height'),
    TriangleModeOption(mode: TriangleMode.threeSides, label: "Three Sides (Heron's Formula)"),
  ];

  /// Default matches the reference design (Right Triangle, two sides).
  static TriangleModeOption get defaultTriangleMode => triangleModes.first;
}
