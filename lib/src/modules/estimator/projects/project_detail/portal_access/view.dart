import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../widgets/scroll_segment_toggle.dart';
import '../../models/project_enums.dart';
import '../../widgets/project_badge.dart';
import '../../widgets/project_empty_card.dart';
import '../financials/widgets/panel_card.dart';
import '../widgets/icon_stat_tile.dart';
import '../widgets/project_action_button.dart';
import '../widgets/project_record_tile.dart';
import 'logic.dart';

/// Portal Access tab — Client Portal / Subcontractor Portal strip.
///
/// Client: three counters, "Client Portal" heading, Invite Client, and a
/// "Portal Access" panel. Subcontractor: Invite Subcontractor and a
/// "Subcontractor Portal Access" panel with the "N active" chip.
class PortalAccessView extends StatelessWidget {
  final String projectId;
  final String projectNumber;
  const PortalAccessView({super.key, required this.projectId, required this.projectNumber});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PortalAccessLogic>(
      init: PortalAccessLogic(projectId: projectId, projectNumber: projectNumber),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => ScrollSegmentToggle<PortalSubTab>(
                    values: PortalSubTab.values,
                    labelOf: (t) => t.label,
                    selected: logic.subTab.value,
                    onChanged: logic.onSubTabChange,
                  )),
              const SizedBox(height: 12),
              Obx(() => logic.subTab.value == PortalSubTab.client
                  ? _ClientBody(logic: logic)
                  : _SubcontractorBody(logic: logic)),
            ],
          ),
        );
      },
    );
  }
}

class _ClientBody extends StatelessWidget {
  final PortalAccessLogic logic;
  const _ClientBody({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final day = DateFormat('MMM d, y');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The reference cuts the strip off after two tiles, so it scrolls.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: 150,
                  child: IconStatTile(
                    icon: Icons.groups_outlined,
                    color: const Color(0xFF2563EB),
                    label: 'Total Access',
                    value: '${logic.totalAccess}',
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 150,
                  child: IconStatTile(
                    icon: Icons.show_chart,
                    color: const Color(0xFF16A34A),
                    label: 'Active Users',
                    value: '${logic.activeUsers}',
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 150,
                  child: IconStatTile(
                    icon: Icons.mail_outline,
                    color: const Color(0xFFD97706),
                    label: 'Pending Invites',
                    value: '${logic.pendingInvites}',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text('Client Portal',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text('Share project visibility with clients and stakeholders',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          const SizedBox(height: 10),
          ProjectActionButton(
            label: 'Invite Client',
            icon: Icons.add,
            onPressed: logic.openInviteClient,
          ),
          const SizedBox(height: 12),
          PanelCard(
            title: 'Portal Access',
            subtitle: 'Manage who can view your project through the client portal',
            child: logic.clients.isEmpty
                ? const ProjectEmptyCard(
                    bordered: false,
                    icon: Icons.group_outlined,
                    title: 'No Portal Access Yet',
                    message: 'Invite clients and stakeholders to view project updates.',
                  )
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        for (final c in logic.clients)
                          ProjectRecordTile(
                            title: c.name,
                            lines: [c.email, 'Invited ${day.format(c.invitedAt)}'],
                            badges: [
                              ProjectBadge(
                                  label: c.status.label,
                                  background: c.status.background,
                                  foreground: c.status.foreground),
                              ProjectBadge(
                                  label: c.accessType.label,
                                  background: Colors.grey.shade100,
                                  foreground: Colors.grey.shade700),
                              ProjectBadge(
                                  label: '${c.permissions.length} permissions',
                                  background: Colors.grey.shade100,
                                  foreground: Colors.grey.shade700),
                            ],
                            onTap: () => logic.revokeClient(c),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      );
    });
  }
}

class _SubcontractorBody extends StatelessWidget {
  final PortalAccessLogic logic;
  const _SubcontractorBody({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final day = DateFormat('MMM d, y');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProjectActionButton(
            label: 'Invite Subcontractor',
            icon: Icons.add,
            onPressed: logic.openInviteSubcontractor,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Subcontractor Portal Access',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(
                        'Manage subcontractor access tokens for project ${logic.projectNumber}',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('• ${logic.activeTokens} active',
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey.shade200),
                if (logic.tokens.isEmpty)
                  const ProjectEmptyCard(
                    bordered: false,
                    icon: Icons.vpn_key_outlined,
                    title: 'No portal access tokens',
                    message: 'Invite subcontractors to give them access to RFIs, '
                        'Submittals, and Transmittals.',
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        for (final t in logic.tokens)
                          ProjectRecordTile(
                            title: t.organisation,
                            lines: [
                              '${t.contactName} · ${t.contactEmail}',
                              'Expires ${day.format(t.expiresAt)}',
                            ],
                            badges: [
                              ProjectBadge(
                                label: t.isActive ? 'Active' : 'Expired',
                                background: (t.isActive
                                        ? const Color(0xFF16A34A)
                                        : const Color(0xFFDC2626))
                                    .withAlpha(28),
                                foreground: t.isActive
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFFDC2626),
                              ),
                              for (final p in t.permissions)
                                ProjectBadge(
                                    label: p.label,
                                    background: Colors.grey.shade100,
                                    foreground: Colors.grey.shade700),
                            ],
                            onTap: () => logic.revokeToken(t),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
