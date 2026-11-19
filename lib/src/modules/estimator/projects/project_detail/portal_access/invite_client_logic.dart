import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/portal_models.dart';
import '../../models/project_enums.dart';

/// Owns "Invite to Client Portal". Short-lived, no `tag`.
class InviteClientLogic extends GetxController {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final String projectId;
  InviteClientLogic(this.projectId);

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  final Rx<PortalAccessType> accessType = PortalAccessType.ownerRep.obs;
  final RxSet<ClientPortalPermission> permissions = <ClientPortalPermission>{
    for (final p in ClientPortalPermission.values)
      if (p.onByDefault) p,
  }.obs;
  final isSending = false.obs;

  void setAccessType(PortalAccessType t) => accessType.value = t;

  void setPermission(ClientPortalPermission p, bool on) =>
      on ? permissions.add(p) : permissions.remove(p);

  // API: POST /projects/{id}/portal/clients { name, email, accessType, permissions }
  Future<void> send() async {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Missing name', 'Enter the client\'s name first.');
      return;
    }
    if (!_emailPattern.hasMatch(email)) {
      Get.snackbar('Check email address', 'Enter a valid email address.');
      return;
    }
    isSending.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      ProjectWorkStore.to.clientAccess(projectId).insert(
            0,
            ClientPortalAccessModel(
              id: 'cp_${DateTime.now().microsecondsSinceEpoch}',
              name: name,
              email: email,
              accessType: accessType.value,
              permissions: Set.of(permissions),
              invitedAt: DateTime.now(),
            ),
          );
      Get.back();
      Get.snackbar('Invitation sent', 'Portal invitation sent to $email.');
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    super.onClose();
  }
}
