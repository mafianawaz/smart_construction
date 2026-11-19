import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/cfo_org_mock_data.dart';
import '../models/cfo_org_models.dart';

class CfoInviteLogic extends GetxController {
  final TextEditingController emailController = TextEditingController();

  CfoExecRole role = CfoExecRole.coo;
  String? emailError;
  bool sending = false;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  void selectRole(CfoExecRole? value) {
    if (value == null) return;
    role = value;
    update();
  }

  void onEmailChanged(String _) {
    if (emailError != null) {
      emailError = null;
      update();
    }
  }

  bool _validate() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError = 'Email address is required';
    } else if (!_emailPattern.hasMatch(email)) {
      emailError = 'Enter a valid email address';
    } else {
      emailError = null;
    }
    update();
    return emailError == null;
  }

  /// Sends the invite and pops with the created [CfoExecutive].
  Future<void> sendInvite() async {
    if (sending || !_validate()) return;
    sending = true;
    update();
    try {
      final executive = await CfoOrgMockData.inviteExecutive(
        email: emailController.text.trim(),
        role: role,
      );
      Get.back<CfoExecutive>(result: executive);
    } finally {
      sending = false;
      update();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
