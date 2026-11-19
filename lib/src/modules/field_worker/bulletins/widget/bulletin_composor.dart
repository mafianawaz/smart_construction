import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../../../utils/app_color.dart';
import '../../../../widgets/custom_dropdown_button.dart';
import '../model/bulletin_model.dart';

class ProjectDropdown extends StatelessWidget {
  final List<ProjectOption> options;
  final ProjectOption? value;
  final ValueChanged<ProjectOption?> onChanged;

  const ProjectDropdown({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<ProjectOption>(
      heading: 'Related Project (Optional)',
      items: options,
      value: value,
      hintText: 'No specific project',
      onChanged: onChanged,
      itemLabel: (project) => project.name,
    );
  }
}

class BulletinComposer extends StatelessWidget {
  final TextEditingController messageController;
  final List<ProjectOption> projectOptions;
  final ProjectOption? selectedProject;
  final ValueChanged<ProjectOption?> onProjectChanged;
  final Function(String?)? onMessageChanged;
  final VoidCallback onPost;
  final bool canPost;
  final bool isPosting;

  const BulletinComposer({
    super.key,
    required this.messageController,
    required this.projectOptions,
    required this.selectedProject,
    required this.onProjectChanged,
    required this.onMessageChanged,
    required this.onPost,
    required this.canPost,
    required this.isPosting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            heading: 'Message',
            controller: messageController,
            hintText: 'Share today\'s progress, updates, or important information with the team...',
            maxLines: 4,
            onChange: onMessageChanged,
          ),
          const SizedBox(height: 15),
          ProjectDropdown(
            options: projectOptions,
            value: selectedProject,
            onChanged: onProjectChanged,
          ),
          const SizedBox(height: 16),
          CustomButton(text: 'Post Update', onPressed: onPost),
        ],
      ),
    );
  }
}