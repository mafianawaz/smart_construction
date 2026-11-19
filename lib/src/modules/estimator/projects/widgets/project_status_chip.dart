import 'package:flutter/material.dart';
import '../models/project_enums.dart';

/// Uppercase-free status pill (the reference uses title-case, e.g.
/// "Planning", "Active" — unlike Bids' all-caps chip).
class ProjectStatusChip extends StatelessWidget {
  final ProjectStatus status;
  const ProjectStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
