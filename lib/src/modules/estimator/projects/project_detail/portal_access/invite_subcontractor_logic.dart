import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/portal_mock_data.dart';
import '../../data/project_work_store.dart';
import '../../models/portal_models.dart';
import '../../models/project_enums.dart';

/// Owns "Invite Subcontractor": the CRM organisation list loads on open
/// (the dropdown reads "Loading..." until it arrives). Short-lived.
class InviteSubcontractorLogic extends GetxController {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final String projectId;
  InviteSubcontractorLogic(this.projectId);

  final contactNameCtrl = TextEditingController();
  final contactEmailCtrl = TextEditingController();

  final Rx<CardLoadState> orgState = CardLoadState.loading.obs;
  final RxList<CrmOrganisationModel> organisations = <CrmOrganisationModel>[].obs;
  final Rxn<CrmOrganisationModel> organisation = Rxn<CrmOrganisationModel>();

  final RxSet<SubcontractorPermission> permissions =
      <SubcontractorPermission>{...SubcontractorPermission.values}.obs;
  final Rx<PortalExpiry> expiry = PortalExpiry.days90.obs;
  final isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrganisations();
  }

  // API: GET /crm/organisations?type=subcontractor
  Future<void> loadOrganisations() async {
    orgState.value = CardLoadState.loading;
    try {
      organisations.assignAll(await PortalMockData.crmOrganisations());
      orgState.value = CardLoadState.loaded;
    } catch (_) {
      orgState.value = CardLoadState.error;
    }
  }

  void setPermission(SubcontractorPermission p, bool on) =>
      on ? permissions.add(p) : permissions.remove(p);

  // API: POST /projects/{id}/portal/subcontractor-tokens
  Future<void> send() async {
    final org = organisation.value;
    final name = contactNameCtrl.text.trim();
    final email = contactEmailCtrl.text.trim();
    if (org == null) {
      Get.snackbar('Missing organisation', 'Choose a CRM organisation first.');
      return;
    }
    if (name.isEmpty) {
      Get.snackbar('Missing contact name', 'Enter the contact\'s name.');
      return;
    }
    if (!_emailPattern.hasMatch(email)) {
      Get.snackbar('Check email address', 'Enter a valid email address.');
      return;
    }
    if (permissions.isEmpty) {
      Get.snackbar('No permissions', 'Tick at least one permission.');
      return;
    }
    isSending.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final now = DateTime.now();
      ProjectWorkStore.to.subcontractorTokens(projectId).insert(
            0,
            SubcontractorAccessTokenModel(
              id: 'sat_${now.microsecondsSinceEpoch}',
              organisation: org.name,
              contactName: name,
              contactEmail: email,
              permissions: Set.of(permissions),
              createdAt: now,
              expiresAt: now.add(Duration(days: expiry.value.days)),
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
    contactNameCtrl.dispose();
    contactEmailCtrl.dispose();
    super.onClose();
  }
}
