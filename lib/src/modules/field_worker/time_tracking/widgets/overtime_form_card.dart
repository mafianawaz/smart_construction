import 'package:flutter/material.dart';
import 'package:smart_construction/src/modules/field_worker/my_work/project_details/widget/job_info_card.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import '../../../../utils/app_color.dart';
import '../../../../widgets/app_textfield.dart';
import '../../../../widgets/custom_dropdown_button.dart';
import '../models/time_tracking_models.dart';

/// Form body for Request Overtime: excess hours (read-only), approver
/// dropdown, and a notes field. Wrapped in the shared SectionCard so it
/// matches the visual language of the Project selector card.
class OvertimeFormCard extends StatelessWidget {
  final String excessHoursLabel;
  final List<ApproverOption> approvers;
  final ApproverOption? selectedApprover;
  final ValueChanged<ApproverOption?> onApproverChanged;
  final ValueChanged<String> onNotesChanged;
  final TextEditingController notesController;

  const OvertimeFormCard({
    super.key,
    required this.excessHoursLabel,
    required this.approvers,
    required this.onApproverChanged,
    required this.onNotesChanged,
    this.selectedApprover,
    required this.notesController,
  });

  Widget _label(String text) => Text(
        text,
        style: TextStyle(
          fontSize: 11,
          letterSpacing: 0.4,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            heading: 'Access Hours',
            leftIconPath: AppIcons.clock,
            hintText: excessHoursLabel,
            onChange: (value) {
              onNotesChanged(value ?? '');
            },
          ),
          const SizedBox(height: 16),
          CustomDropdown<ApproverOption>(
            heading: 'APPROVER',
            hintText: 'Select Approver',
            items: approvers,
            value: selectedApprover,
            onChanged: onApproverChanged,
            itemLabel: (approver) => approver.name,
          ),

          const SizedBox(height: 16),

          CustomTextField(
            heading: 'REASON / NOTES',
            hintText: 'Explain why overtime is needed...',
            controller: notesController,
            maxLines: 4,
            onChange: (value) {
              onNotesChanged(value ?? '');
            },
          ),
        ],
      ),
    );
  }
}
