import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/projects_mock_data.dart';
import '../../../models/schedule_model.dart';

/// Owns the "Email to project contacts" screen. Put with
/// `tag: projectId`. Pops with the new [ScheduleSendRecord] on success so
/// the Schedule tab can add it to Recent Sends.
class ScheduleEmailLogic extends GetxController {
  static const String defaultNotes =
      'Sharing the latest project schedule for your review. Please let us '
      'know if you have any questions before our next progress meeting.';

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final String projectId;
  final String projectTitle;
  final List<String> contactEmails;

  ScheduleEmailLogic({
    required this.projectId,
    required this.projectTitle,
    required this.contactEmails,
  });

  final contactInputCtrl = TextEditingController();
  final additionalCtrl = TextEditingController();
  late final TextEditingController subjectCtrl;
  final notesCtrl = TextEditingController();

  /// On-file contacts currently ticked as recipients (all by default).
  final selectedContacts = <String>{}.obs;

  /// Valid recipients right now — drives the Save as list button.
  final recipientCount = 0.obs;
  final isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    subjectCtrl = TextEditingController(text: projectTitle);
    selectedContacts.addAll(contactEmails);
    contactInputCtrl.addListener(_refreshRecipientCount);
    additionalCtrl.addListener(_refreshRecipientCount);
    _refreshRecipientCount();
  }

  void toggleContact(String email) {
    if (!selectedContacts.remove(email)) selectedContacts.add(email);
    _refreshRecipientCount();
  }

  List<String> _split(String raw) =>
      raw.split(RegExp(r'[,;\s]+')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  List<String> get _typedEntries =>
      [..._split(contactInputCtrl.text), ..._split(additionalCtrl.text)];

  List<String> get invalidEntries =>
      _typedEntries.where((e) => !_emailPattern.hasMatch(e)).toList();

  /// De-duplicated, valid recipients: ticked contacts + typed addresses.
  List<String> get recipients {
    final all = <String>{
      ...selectedContacts,
      ..._typedEntries.where(_emailPattern.hasMatch),
    };
    return all.toList();
  }

  void _refreshRecipientCount() => recipientCount.value = recipients.length;

  String _summary(List<String> list) {
    if (list.length <= 2) return list.join(', ');
    return '${list.take(2).join(', ')} +${list.length - 2} more';
  }

  // API: POST /projects/{id}/distribution-lists
  void saveAsList() {
    if (recipients.isEmpty) return;
    Get.snackbar('Saved', 'Recipient list saved.');
  }

  // API: POST /projects/{id}/schedule/send
  Future<void> send() async {
    if (isSending.value) return;
    final bad = invalidEntries;
    if (bad.isNotEmpty) {
      Get.snackbar('Check email addresses', bad.join(', '));
      return;
    }
    final to = recipients;
    if (to.isEmpty) {
      Get.snackbar('No recipients', 'Add at least one email address.');
      return;
    }

    isSending.value = true;
    try {
      await ProjectsMockData.sendScheduleEmail(
        projectId,
        recipients: to,
        subject: subjectCtrl.text.trim(),
        notes: notesCtrl.text.trim().isEmpty ? defaultNotes : notesCtrl.text.trim(),
      );
      final record = ScheduleSendRecord(
        id: 'send_${DateTime.now().millisecondsSinceEpoch}',
        sentAt: DateTime.now(),
        recipientSummary: _summary(to),
      );
      Get.back(result: record);
      Get.snackbar('Sent', 'Schedule emailed to ${to.length} recipient(s).');
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    contactInputCtrl.dispose();
    additionalCtrl.dispose();
    subjectCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }
}
