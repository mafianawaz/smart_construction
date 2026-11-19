import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/portal_models.dart';
import '../../models/project_enums.dart';
import 'invite_client_view.dart';
import 'invite_subcontractor_view.dart';

/// Owns the Portal Access tab: the Client Portal / Subcontractor Portal
/// strip, the counters and both lists. The strip's value lives in
/// `ProjectWorkStore` so the Project Detail app bar can follow it. Put
/// with `tag: projectId`.
class PortalAccessLogic extends GetxController {
  final String projectId;
  final String projectNumber;
  PortalAccessLogic({required this.projectId, required this.projectNumber});

  Rx<PortalSubTab> get subTab => ProjectWorkStore.to.portalSubTab(projectId);
  void onSubTabChange(PortalSubTab t) => subTab.value = t;

  RxList<ClientPortalAccessModel> get clients => ProjectWorkStore.to.clientAccess(projectId);
  RxList<SubcontractorAccessTokenModel> get tokens =>
      ProjectWorkStore.to.subcontractorTokens(projectId);

  // Counters — call inside an Obx.
  int get totalAccess => clients.length;
  int get activeUsers => clients.where((c) => c.status == PortalInviteStatus.active).length;
  int get pendingInvites =>
      clients.where((c) => c.status == PortalInviteStatus.pending).length;
  int get activeTokens => tokens.where((t) => t.isActive).length;

  void openInviteClient() => Get.to(
        () => InviteClientView(projectId: projectId),
        routeName: '/portal/invite-client',
      );

  void openInviteSubcontractor() => Get.to(
        () => InviteSubcontractorView(projectId: projectId),
        routeName: '/portal/invite-subcontractor',
      );

  Future<bool> _confirmRevoke(String who) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Revoke access?', style: TextStyle(fontSize: 16)),
        content: Text('$who will no longer be able to open the portal.',
            style: const TextStyle(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(onPressed: () => Get.back(result: true), child: const Text('Revoke')),
        ],
      ),
    );
    return ok ?? false;
  }

  // API: DELETE /projects/{id}/portal/clients/{id}
  Future<void> revokeClient(ClientPortalAccessModel c) async {
    if (await _confirmRevoke(c.name)) clients.removeWhere((x) => x.id == c.id);
  }

  // API: DELETE /projects/{id}/portal/subcontractor-tokens/{id}
  Future<void> revokeToken(SubcontractorAccessTokenModel t) async {
    if (await _confirmRevoke(t.organisation)) tokens.removeWhere((x) => x.id == t.id);
  }
}
