import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'add_organization/view.dart';
import 'invite_executive/view.dart';
import 'logic.dart';
import 'models/cfo_org_models.dart';
import 'org_details/view.dart';
import 'widgets/cfo_org_palette.dart';
import 'widgets/cfo_org_widgets.dart';


class CfoMyOrganizationView extends StatelessWidget {
  const CfoMyOrganizationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CfoOrgLogic>(
      init: CfoOrgLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'CFO',
            showBackButton: true,
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            children: [
              const Text('My Organization',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: CfoOrgPalette.text)),
              const SizedBox(height: 2),
              Text(
                'Manage and switch between your '
                '${logic.organizations.length} '
                '${logic.organizations.length == 1 ? 'organization' : 'organizations'}.',
                style: const TextStyle(
                    fontSize: 10.5, color: CfoOrgPalette.muted),
              ),
              const SizedBox(height: 10),
              CustomIconButton(
                text: 'Add Organization',
                icon: AppIcons.add,
                onPressed: _addOrganization,
              ),
              const SizedBox(height: 18),
              _PortfolioSummary(summary: logic.summary),
              const SizedBox(height: 16),
              _AccessSummary(access: logic.access),
              const SizedBox(height: 16),
              _AiInsights(insights: logic.insights),
              const SizedBox(height: 14),
              _OrgStrip(logic: logic),
              const SizedBox(height: 16),
              _ExecutiveTeam(logic: logic),
            ],
          ),
        );
      },
    );
  }
}

/// Opens the Add an Organization form and confirms once the invite is sent.
/// The invited organization only joins the strip after its admin accepts, so
/// nothing is added to [CfoOrgLogic.organizations] here.
Future<void> _addOrganization() async {
  final invite = await Get.to<CfoOrgInvite>(() => const AddOrganizationView());
  if (invite == null) return;
  Get.snackbar(
    'Invite sent',
    'We emailed ${invite.adminEmail}. The organization appears here once '
        'its admin accepts.',
    snackPosition: SnackPosition.BOTTOM,
  );
}

class _PortfolioSummary extends StatelessWidget {
  const _PortfolioSummary({required this.summary});

  final CfoPortfolioSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CfoOrgSectionTitle('Portfolio Summary'),
        const SizedBox(height: 10),
        CfoOrgTwoColumnGrid(
          children: [
            CfoOrgSummaryTile(
                label: 'Organizations', value: '${summary.organizations}'),
            CfoOrgSummaryTile(
                label: 'Active Projects', value: '${summary.activeProjects}'),
            CfoOrgSummaryTile(
                label: 'Open Bills', value: '${summary.openBills}'),
            CfoOrgSummaryTile(
                label: 'Pending COs', value: '${summary.pendingChangeOrders}'),
            CfoOrgSummaryTile(
                label: 'Pending Tasks', value: '${summary.pendingTasks}'),
            CfoOrgSummaryTile(
                label: 'Bid Pipeline', value: summary.bidPipelineLabel),
          ],
        ),
        const SizedBox(height: 8),
        CfoOrgCard(
          fill: CfoOrgPalette.orangeSoft,
          borderColor: CfoOrgPalette.orangeBorder,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bid Win Rate',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: CfoOrgPalette.orange)),
                    const SizedBox(height: 2),
                    Text(
                      'CW / % (${summary.bidWins}W / ${summary.bidLosses}L)',
                      style: const TextStyle(
                          fontSize: 8.5, color: CfoOrgPalette.muted),
                    ),
                  ],
                ),
              ),
              Text(
                '${summary.winRatePercent}%',
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: CfoOrgPalette.orange),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccessSummary extends StatelessWidget {
  const _AccessSummary({required this.access});

  final CfoAccessSummary access;

  Widget _row(String label, Widget value, {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: CfoOrgPalette.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 10.5, color: CfoOrgPalette.muted)),
          value,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CfoOrgSectionTitle('Access Summary'),
        const SizedBox(height: 8),
        CfoOrgCard(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              _row(
                'Organization',
                Text(access.organizationName,
                    style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: CfoOrgPalette.text)),
              ),
              _row(
                'Effective Role',
                Text(access.effectiveRole,
                    style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: CfoOrgPalette.orange)),
              ),
              _row(
                'Permissions',
                CfoOrgPill(
                  label: '${access.permissionCount} permissions',
                  foreground: CfoOrgPalette.orange,
                  background: CfoOrgPalette.orangeSoft,
                  fontSize: 9,
                  letterSpacing: 0,
                ),
                last: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AiInsights extends StatelessWidget {
  const _AiInsights({required this.insights});

  final CfoInsights insights;

  Widget _stat(String label, int value) {
    return Expanded(
      child: Column(
        children: [
          Text('$value',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: CfoOrgPalette.text)),
          const SizedBox(height: 2),
          Text(label,
              style:
                  const TextStyle(fontSize: 8.5, color: CfoOrgPalette.muted)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CfoOrgSectionTitle('AI Executive Insights'),
        const SizedBox(height: 8),
        CfoOrgCard(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          child: Column(
            children: [
              Text(insights.message,
                  style: const TextStyle(
                      fontSize: 10,
                      height: 1.45,
                      color: CfoOrgPalette.muted)),
              const SizedBox(height: 10),
              const Divider(height: 1, color: CfoOrgPalette.border),
              const SizedBox(height: 10),
              Row(
                children: [
                  _stat('Sorted Orgs', insights.sortedOrgs),
                  _stat('Flagged', insights.flagged),
                  _stat('Trending', insights.trending),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrgStrip extends StatelessWidget {
  const _OrgStrip({required this.logic});

  final CfoOrgLogic logic;

  @override
  Widget build(BuildContext context) {
    // Cards are wider than the viewport on purpose: the reference shows the
    // next card clipped at the right edge, signalling horizontal scroll.
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: logic.organizations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final org = logic.organizations[i];
          final switching = logic.switchingOrgId == org.id;
          return SizedBox(
            width: 250,
            child: CfoOrgCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => Get.to(
                            () => OrganizationDetailView(
                                orgId: org.id, orgName: org.name),
                          ),
                          child: Text(org.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: CfoOrgPalette.text)),
                        ),
                      ),
                      if (org.isActive)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.check,
                                size: 11, color: CfoOrgPalette.orange),
                            SizedBox(width: 2),
                            Text('Active',
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: CfoOrgPalette.orange)),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  CfoOrgPill(
                    label: org.type,
                    foreground: CfoOrgPalette.text,
                    background: CfoOrgPalette.chipFill,
                    fontSize: 7.5,
                  ),
                  const Spacer(),
                  if (!org.isActive)
                    CfoOrgPrimaryButton(
                      label: 'Switch to This Org',
                      icon: Icons.sync,
                      height: 32,
                      loading: switching,
                      onPressed: () => logic.switchOrganization(org),
                    )
                  else
                    CfoOrgPrimaryButton(
                      label: 'Switch to This Org',
                      icon: Icons.sync,
                      height: 32,
                      // Already the active org: button stays visible (as in
                      // the reference) but does nothing.
                      onPressed: () => logic.switchOrganization(org),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ExecutiveTeam extends StatelessWidget {
  const _ExecutiveTeam({required this.logic});

  final CfoOrgLogic logic;

  Future<void> _invite() async {
    final result = await Get.to<CfoExecutive>(() => const InviteExecutiveView());
    if (result != null) logic.addExecutive(result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CfoOrgSectionTitle(
          'Executive Team',
          trailing: InkWell(
            onTap: _invite,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: CfoOrgPalette.chipFill,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text('Invite Executive',
                  style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                      color: CfoOrgPalette.text)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        CfoOrgCard(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: logic.hasExecutives
              ? Column(
                  children: [
                    for (final e in logic.executives)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline,
                                size: 18, color: CfoOrgPalette.muted),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(e.email,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: CfoOrgPalette.text)),
                            ),
                            CfoOrgPill(
                              label: e.role.name.toUpperCase(),
                              foreground: CfoOrgPalette.orange,
                              background: CfoOrgPalette.orangeSoft,
                            ),
                          ],
                        ),
                      ),
                  ],
                )
              : const CfoOrgEmptyState(
                  icon: Icons.group_outlined,
                  message: 'No Executive invited yet. Invite a COO or CFO '
                      'to help manage your companies',
                ),
        ),
      ],
    );
  }
}
