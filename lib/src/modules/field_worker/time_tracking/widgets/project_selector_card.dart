import 'package:flutter/material.dart';
import '../../../../widgets/custom_dropdown_button.dart';
import '../models/time_tracking_models.dart';


class ProjectSelectorCard extends StatelessWidget {
  final List<ProjectOption> projects;
  final List<CostCodeOption> costCodes;
  final ProjectOption? selectedProject;
  final CostCodeOption? selectedCostCode;
  final ValueChanged<ProjectOption?> onProjectChanged;
  final ValueChanged<CostCodeOption?> onCostCodeChanged;

  /// Locks both fields once the shift is already clocked in.
  final bool locked;

  const ProjectSelectorCard({
    super.key,
    required this.projects,
    required this.costCodes,
    required this.onProjectChanged,
    required this.onCostCodeChanged,
    this.selectedProject,
    this.selectedCostCode,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown<ProjectOption>(
          heading: 'PROJECT',
          hintText: 'Select a project',
          items: projects,
          value: selectedProject,
          enabled: !locked,
          onChanged: onProjectChanged,
          itemLabel: (project) => project.name,
        ),

        const SizedBox(height: 16),

        CustomDropdown<CostCodeOption>(
          heading: 'COST CODE (OPTIONAL)',
          hintText: 'Select cost code',
          items: costCodes,
          value: selectedCostCode,
          enabled: !locked && selectedProject != null,
          onChanged: onCostCodeChanged,
          itemLabel: (costCode) => costCode.code,
        ),
      ],
    );
  }
}
