import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/project_enums.dart';
import '../widgets/project_action_button.dart';
import '../widgets/project_form_card.dart';
import 'invite_client_logic.dart';

/// "Invite to Client Portal" — Name/Email card, 2 x 2 Access Type tiles,
/// seven permission switches and a pinned Send Invitation button.
class InviteClientView extends StatelessWidget {
  final String projectId;
  const InviteClientView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InviteClientLogic>(
      init: InviteClientLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
              title: 'Invite to Client Portal', showBackButton: true, centerTitle: true),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15, 8, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Send a portal invitation to a client or stakeholder',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        const SizedBox(height: 12),
                        ProjectFormCard(
                          children: [
                            CustomTextField(
                                heading: 'Name',
                                hintText: 'John Smith',
                                controller: logic.nameCtrl),
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Email',
                                hintText: 'john@company.com',
                                controller: logic.emailCtrl,
                                keyboardType: TextInputType.emailAddress),
                          ],
                        ),
                        ProjectFormCard(
                          title: 'Access Type',
                          children: [
                            Obx(() => GridView.count(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 3.1,
                                  children: [
                                    for (final t in PortalAccessType.values)
                                      _AccessTypeTile(
                                        type: t,
                                        selected: logic.accessType.value == t,
                                        onTap: () => logic.setAccessType(t),
                                      ),
                                  ],
                                )),
                          ],
                        ),
                        ProjectFormCard(
                          title: 'Permissions',
                          children: [
                            Obx(() => Column(
                                  children: [
                                    for (final p in ClientPortalPermission.values)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(p.label,
                                                  style: const TextStyle(fontSize: 12)),
                                            ),
                                            Switch(
                                              value: logic.permissions.contains(p),
                                              activeColor: AppColors.primaryOrange,
                                              onChanged: (v) => logic.setPermission(p, v),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
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

class _AccessTypeTile extends StatelessWidget {
  final PortalAccessType type;
  final bool selected;
  final VoidCallback onTap;
  const _AccessTypeTile({required this.type, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primaryOrange : Colors.grey.shade700;
    return Material(
      color: selected ? AppColors.primaryOrange.withAlpha(14) : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: selected ? AppColors.primaryOrange : Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(type.icon, size: 15, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(type.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600, color: color)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
