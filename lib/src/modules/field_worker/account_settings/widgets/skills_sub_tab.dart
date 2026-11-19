import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../../../utils/app_color.dart';
import '../logic.dart';
import 'removable_chip.dart';


class SkillsSubTabView extends StatelessWidget {
  const SkillsSubTabView({super.key, required this.logic});

  final AccountSettingsLogic logic;

  @override
  Widget build(BuildContext context) {
    final suggestions = logic.filteredSkillSuggestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hintText: 'Search for skills or type to add custom ones...',
          controller: logic.skillSearchController,
          onSubmit: (value) => logic.addSkill(value),
        ),
        if (suggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final suggestion in suggestions)
                GestureDetector(
                  onTap: () => logic.addSkill(suggestion),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.fieldFill,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.fieldBorder),
                    ),
                    child: Text(
                      suggestion,
                      style: TextStyle(fontSize: 13, color: AppColors.textDark),
                    ),
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        if (logic.addedSkills.isEmpty)
          const AppEmptyState(
            showButton: false,
            title: 'No skills added yet',
            message: 'Use the search above to add skills.',
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final skill in logic.addedSkills)
                RemovableChip(label: skill, onRemove: () => logic.removeSkill(skill)),
            ],
          ),
      ],
    );
  }
}
