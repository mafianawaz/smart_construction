import 'package:flutter/material.dart';

/// A selectable brick/block type with nominal dimensions (inches) used to
/// compute face area per unit, plus a rough mortar-coverage ratio.
///
/// `unitsPerBag` is a rule-of-thumb placeholder (bricks/blocks one 80lb bag
/// of mortar mix can typically lay) — verify against local supplier specs
/// before relying on it for real orders. See NOTES_CALCULATOR.md.
class MasonryUnitType {
  final String id;
  final String label;
  final double lengthIn;
  final double heightIn;
  final double widthIn;
  final int unitsPerBag;
  final String pluralLabel;

  const MasonryUnitType({
    required this.id,
    required this.label,
    required this.lengthIn,
    required this.heightIn,
    required this.widthIn,
    required this.unitsPerBag,
    required this.pluralLabel,
  });
}

/// A selectable mortar joint thickness.
class MortarJointOption {
  final String id;
  final String label;
  final double thicknessIn;

  const MortarJointOption({required this.id, required this.label, required this.thicknessIn});
}

/// A single repeatable "opening" (door/window) row in the Masonry
/// calculator. Owns its own controllers since the list of openings grows
/// and shrinks at runtime; callers must call [dispose] when a row is removed
/// and the controller's `onClose()` must dispose any still-open rows.
class MasonryOpening {
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  double get widthFt => double.tryParse(widthController.text) ?? 0;
  double get heightFt => double.tryParse(heightController.text) ?? 0;
  double get areaSqFt => widthFt * heightFt;

  void dispose() {
    widthController.dispose();
    heightController.dispose();
  }
}
