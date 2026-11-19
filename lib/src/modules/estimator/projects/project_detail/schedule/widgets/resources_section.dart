import 'package:flutter/material.dart';

import '../../../models/schedule_model.dart';
import '../../../widgets/project_empty_card.dart';
import '../../../widgets/project_list_tile.dart';

/// Schedule -> Resources: "Crew Assignments". Populated rows are a
/// guess (reference is empty-only), flagged in NOTES_PROJECT_TABS.md.
class ResourcesSection extends StatelessWidget {
  final List<CrewAssignmentModel> assignments;
  const ResourcesSection({super.key, required this.assignments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Crew Assignments',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 10),
        if (assignments.isEmpty)
          const ProjectEmptyCard(
              icon: Icons.groups_outlined, message: 'No crew assigned to schedule tasks')
        else
          for (final a in assignments)
            ProjectListTile(
              icon: Icons.groups_outlined,
              title: a.crewName,
              subtitle: '${a.taskName} · ${a.headcount} on crew',
            ),
      ],
    );
  }
}
