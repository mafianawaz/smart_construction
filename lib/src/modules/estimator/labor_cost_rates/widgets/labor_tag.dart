import 'package:flutter/material.dart';

/// Small uppercase tag used for role (SUPERINTENDENT), classification code
/// (FORE), status (ACTIVE) and the prevailing-wage classification chip.
/// Deliberately not built on `PillChip` (no outline/size control there).
class LaborTag extends StatelessWidget {
  final String label;
  final Color foreground;
  final Color background;
  final bool outlined;
  final double fontSize;

  const LaborTag({
    super.key,
    required this.label,
    required this.foreground,
    required this.background,
    this.outlined = false,
    this.fontSize = 9,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : background,
        borderRadius: BorderRadius.circular(4),
        border: outlined ? Border.all(color: foreground, width: 0.8) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: foreground,
        ),
      ),
    );
  }
}
