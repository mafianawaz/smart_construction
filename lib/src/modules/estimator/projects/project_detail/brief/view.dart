import 'package:flutter/material.dart';

import '../financials/widgets/panel_card.dart';

/// Brief tab (app bar reads "Project Detail") — one panel with a title,
/// a muted line and an empty state. The reference text for this panel is
/// too small to read, so the copy is a placeholder — flagged in
/// NOTES_PUNCH_FIELD_OPS.md.
class BriefView extends StatelessWidget {
  final String projectId;
  const BriefView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: const PanelCard(
        title: 'Project Brief',
        subtitle: 'Summary of scope, key contacts and site notes',
        child: PanelEmptyBody(
          icon: Icons.article_outlined,
          message: 'No project brief yet',
          hint: 'A brief generated or uploaded for this project will appear here.',
        ),
      ),
    );
  }
}
