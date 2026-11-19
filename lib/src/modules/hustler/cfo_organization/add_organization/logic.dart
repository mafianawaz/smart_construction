import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/cfo_org_mock_data.dart';
import '../models/cfo_org_models.dart';

/// Add an Organization: invites another organization's admin by email.
class CfoAddOrgLogic extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  String? emailError;
  bool sending = false;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  void onEmailChanged(String _) {
    if (emailError != null) {
      emailError = null;
      update();
    }
  }

  bool _validate() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError = 'Admin email is required';
    } else if (!_emailPattern.hasMatch(email)) {
      emailError = 'Enter a valid email address';
    } else {
      emailError = null;
    }
    update();
    return emailError == null;
  }

  /// Sends the invite and pops with the created [CfoOrgInvite].
  Future<void> sendInvite() async {
    if (sending || !_validate()) return;
    sending = true;
    update();
    try {
      final message = messageController.text.trim();
      final invite = await CfoOrgMockData.inviteOrganizationAdmin(
        adminEmail: emailController.text.trim(),
        message: message.isEmpty ? null : message,
      );
      Get.back<CfoOrgInvite>(result: invite);
    } finally {
      sending = false;
      if (!isClosed) update();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
