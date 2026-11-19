/// Geometry calculator sub-tabs.
enum GeometryShape { rectangle, triangle, circle, slope }

/// How the Triangle sub-tab's inputs should be interpreted.
enum TriangleMode { rightTwoSides, baseHeight, threeSides }

class TriangleModeOption {
  final TriangleMode mode;
  final String label;

  const TriangleModeOption({required this.mode, required this.label});
}
