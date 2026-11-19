import 'package:flutter/material.dart';

/// Small solid label badge ("Not Started", "7d", "Open"). Deliberately
/// local to the project tabs rather than built on `PillChip`, which has
/// no way to set a separate background and text color.
class ProjectBadge extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const ProjectBadge({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(6)),
      child: Text(
        label,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: foreground),
      ),
    );
  }
}
