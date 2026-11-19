import 'package:flutter/material.dart';

import '../widgets/safety_common_widgets.dart';

/// Placeholder: the reference only shows the "Training" pill, not its screen.
class SafetyTrainingTab extends StatelessWidget {
  const SafetyTrainingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SafetyEmptyBox(
          icon: Icons.school_outlined,
          message: 'Training is coming soon.\nUse Modules → Training & Certifications for now.',
        ),
      ],
    );
  }
}
