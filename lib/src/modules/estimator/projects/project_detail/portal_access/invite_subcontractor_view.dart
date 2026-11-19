import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/portal_models.dart';
import '../../models/project_enums.dart';
import '../widgets/project_action_button.dart';
import '../widgets/project_dropdown.dart';
import '../widgets/project_form_card.dart';
import 'invite_subcontractor_logic.dart';

/// "Invite Subcontractor" — CRM Organisation / Contact Name / Contact
/// Email, four permission checkboxes, Expiration, pinned Send Invitation.
class InviteSubcontractorView extends StatelessWidget {
  final String projectId;
  const InviteSubcontractorView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InviteSubcontractorLogic>(
      init: InviteSubcontractorLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
              title: 'Invite Subcontractor', showBackButton: true, centerTitle: true),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
                    child: Column(
                      children: [
                        ProjectFormCard(
                          children: [
                            Obx(() {
                              final loading = logic.orgState.value == CardLoadState.loading;
                              return ProjectDropdown<CrmOrganisationModel>(
                                label: 'CRM Organisation *',
                                hint: loading ? 'Loading...' : 'Select organisation',
                                value: logic.organisation.value,
                                options: logic.organisations.toList(),
                                labelOf: (o) => o.name,
                                onChanged: (v) => logic.organisation.value = v,
                              );
                            }),
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Contact Name *',
                                hintText: 'e.g., John Smith',
                                controller: logic.contactNameCtrl),
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Contact Email *',
                                hintText: 'e.g., john@example.com',
                                controller: logic.contactEmailCtrl,
                                keyboardType: TextInputType.emailAddress),
                          ],
                        ),
                        ProjectFormCard(
                          title: 'Permissions',
                          children: [
                            Obx(() => Column(
                                  children: [
                                    for (final p in SubcontractorPermission.values)
                                      InkWell(
                                        onTap: () => logic.setPermission(
                                            p, !logic.permissions.contains(p)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: Checkbox(
                                                  value: logic.permissions.contains(p),
                                                  activeColor: AppColors.primaryOrange,
                                                  visualDensity: VisualDensity.compact,
                                                  onChanged: (v) =>
                                                      logic.setPermission(p, v ?? false),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(p.label,
                                                  style: const TextStyle(fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                )),
                          ],
                        ),
                        ProjectFormCard(
                          children: [
                            Obx(() => ProjectDropdown<PortalExpiry>(
                                  label: 'Expiration',
                                  hint: 'Select',
                                  value: logic.expiry.value,
                                  options: PortalExpiry.values,
                                  labelOf: (e) => e.label,
                                  onChanged: (v) {
                                    if (v != null) logic.expiry.value = v;
                                  },
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Obx(() => ProjectActionButton(
                        label: 'Send Invitation',
                        icon: Icons.send_outlined,
                        onPressed: logic.isSending.value ? null : logic.send,
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
