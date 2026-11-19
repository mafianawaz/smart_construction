import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/pill_tab_group.dart';
import '../../models/project_enums.dart';

class ProjectDetailTabBar extends StatelessWidget {
  final ProjectDetailTab selected;
  final ValueChanged<ProjectDetailTab> onChanged;

  const ProjectDetailTabBar({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: PillTabGroup<ProjectDetailTab>(
          items: [
            for (final t in ProjectDetailTab.values)
              PillTabItem(value: t, label: t.label),
          ],
          selectedValue: selected,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
