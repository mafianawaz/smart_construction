import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import 'schedule_email_logic.dart';

/// "Email to project contacts" — the screen behind the Gantt card's
/// Send To button. The current Gantt is emailed as a PDF to the chosen
/// recipients (rendering the PDF is the backend's job).
class ScheduleEmailView extends StatelessWidget {
  final String projectId;
  final String projectTitle;
  final List<String> contactEmails;

  const ScheduleEmailView({
    super.key,
    required this.projectId,
    required this.projectTitle,
    required this.contactEmails,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleEmailLogic>(
      init: ScheduleEmailLogic(
        projectId: projectId,
        projectTitle: projectTitle,
        contactEmails: contactEmails,
      ),
      tag: projectId,
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Email to project contacts',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The current Gantt view will be rendered as a PDF and '
                    'emailed to the recipients you select.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          heading: 'Project Contacts',
                          hintText: contactEmails.isEmpty
                              ? 'No project contacts on file. Add an email...'
                              : 'Add an email...',
                          controller: logic.contactInputCtrl,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        if (contactEmails.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Obx(() => Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  for (final email in contactEmails)
                                    FilterChip(
                                      label: Text(email, style: const TextStyle(fontSize: 11)),
                                      selected: logic.selectedContacts.contains(email),
                                      showCheckmark: true,
                                      checkmarkColor: AppColors.primaryOrange,
                                      selectedColor: const Color(0xFFFFE9D6),
                                      backgroundColor: Colors.white,
                                      onSelected: (_) => logic.toggleContact(email),
                                    ),
                                ],
                              )),
                        ],
                        const SizedBox(height: 14),
                        CustomTextField(
                          heading: 'Additional emails',
                          hintText: 'name@example.com',
                          controller: logic.additionalCtrl,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 4),
                        Text('Separate multiple addresses with commas.',
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                        const SizedBox(height: 14),
                        CustomTextField(
                          heading: 'Subject',
                          hintText: 'Subject',
                          controller: logic.subjectCtrl,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          heading: 'Notes',
                          hintText: ScheduleEmailLogic.defaultNotes,
                          controller: logic.notesCtrl,
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final hasRecipients = logic.recipientCount.value > 0;
                    final sending = logic.isSending.value;
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: hasRecipients && !sending ? logic.saveAsList : null,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              minimumSize: const Size.fromHeight(48),
                              backgroundColor: const Color(0xFFEDEEF0),
                              foregroundColor: Colors.grey.shade700,
                              disabledBackgroundColor: const Color(0xFFEDEEF0),
                              disabledForegroundColor: Colors.grey.shade500,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Save as list'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: sending ? null : logic.send,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              minimumSize: const Size.fromHeight(48),
                              backgroundColor: AppColors.primaryOrange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: sending
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Send'),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
