import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/project_enums.dart';
import '../job_info/widgets/job_info_fields.dart';
import '../widgets/project_dropdown.dart';
import '../widgets/project_form_card.dart';
import 'create_transmittal_logic.dart';

/// "Create Transmittal" — card 1: Subject*, Description, Document Type,
/// Revision Number, Recipients (grey box, "No subcontractors available"
/// when empty), Notes. Card 2: "Additionally notify extra emails
/// (optional)" checkbox with an email field and Add button. Create
/// Transmittal is pinned below the scroll area.
class CreateTransmittalView extends StatelessWidget {
  final String projectId;
  const CreateTransmittalView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateTransmittalLogic>(
      init: CreateTransmittalLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
              title: 'Create Transmittal', showBackButton: true, centerTitle: true),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Create a new document transmittal for distribution.',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        const SizedBox(height: 12),
                        ProjectFormCard(
                          children: [
                            CustomTextField(
                                heading: 'Subject *',
                                hintText: 'e.g., Revised Floor Plans - Building A',
                                controller: logic.subjectCtrl),
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Description',
                                hintText: 'Additional details about this transmittal...',
                                controller: logic.descriptionCtrl,
                                maxLines: 3),
                            projectFieldGap,
                            Obx(() => ProjectDropdown<TransmittalDocType>(
                                  label: 'Document Type',
                                  hint: 'Select document type...',
                                  value: logic.documentType.value,
                                  options: TransmittalDocType.values,
                                  labelOf: (t) => t.label,
                                  onChanged: (v) => logic.documentType.value = v,
                                )),
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Revision Number',
                                hintText: 'e.g., Rev 3, R1.0',
                                controller: logic.revisionCtrl),
                            projectFieldGap,
                            const Text('Recipients',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            _RecipientsBox(logic: logic),
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Notes',
                                hintText: 'Additional notes...',
                                controller: logic.notesCtrl,
                                maxLines: 3),
                          ],
                        ),
                        ProjectFormCard(
                          children: [
                            Obx(() => JobInfoCheckboxRow(
                                  label: 'Additionally notify extra emails (optional)',
                                  value: logic.notifyExtra.value,
                                  onChanged: (v) => logic.notifyExtra.value = v,
                                )),
                            const SizedBox(height: 4),
                            Text(
                              'Send this transmittal to people outside the project team, '
                              'such as vendors or consultants.',
                              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                            ),
                            Obx(() => logic.notifyExtra.value
                                ? _ExtraEmails(logic: logic)
                                : const SizedBox.shrink()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Obx(() => CustomButton(
                        text: 'Create Transmittal',
                        onPressed: logic.isCreating.value ? null : logic.create,
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RecipientsBox extends StatelessWidget {
  final CreateTransmittalLogic logic;
  const _RecipientsBox({required this.logic});

  @override
  Widget build(BuildContext context) {
    final options = logic.availableRecipients;
    if (options.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text('No subcontractors available',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      );
    }
    return Obx(() => Column(
          children: [
            for (final name in options)
              JobInfoCheckboxRow(
                label: name,
                value: logic.selectedRecipients.contains(name),
                onChanged: (_) => logic.toggleRecipient(name),
              ),
          ],
        ));
  }
}

class _ExtraEmails extends StatelessWidget {
  final CreateTransmittalLogic logic;
  const _ExtraEmails({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Extra emails',
                hintText: 'email@example.com',
                controller: logic.emailCtrl,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: logic.addEmail,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(56, 46),
                side: BorderSide(color: AppColors.fieldBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Add',
                  style: TextStyle(fontSize: 12, color: AppColors.textDark)),
            ),
          ],
        ),
        Obx(() => Wrap(
              spacing: 6,
              children: [
                for (final e in logic.extraEmails)
                  Chip(
                    label: Text(e, style: const TextStyle(fontSize: 11)),
                    onDeleted: () => logic.removeEmail(e),
                  ),
              ],
            )),
      ],
    );
  }
}
