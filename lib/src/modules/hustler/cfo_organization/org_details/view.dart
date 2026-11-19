import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import '../models/cfo_org_models.dart';
import '../widgets/cfo_org_charts.dart';
import '../widgets/cfo_org_palette.dart';
import '../widgets/cfo_org_widgets.dart';
import 'logic.dart';
import 'tabs.dart';

/// CFO → Organization detail (third reference screen).
///
/// The controller is tagged by [orgId] so several organizations can be opened
/// without colliding. Deleting it on pop is the navigation layer's job.
class OrganizationDetailView extends StatelessWidget {
  const OrganizationDetailView({
    super.key,
    required this.orgId,
    required this.orgName,
  });

  final String orgId;
  final String orgName;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CfoOrgDetailLogic>(
      tag: orgId,
      init: CfoOrgDetailLogic(orgId),
      builder: (logic) {
        final d = logic.detail;
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Organization',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.name,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: CfoOrgPalette.text)),
                  const SizedBox(height: 2),
                  const Text(
                    'Manage and switch between your 1 organization',
                    style: TextStyle(fontSize: 10, color: CfoOrgPalette.muted),
                  ),
                  const SizedBox(height: 12),
                  CfoOrgTwoColumnGrid(
                    children: [
                      CfoOrgKpiTile(
                          value: '${d.activeProjects}',
                          title: 'Active Projects',
                          subtitle: '${d.planningProjects} in planning'),
                      CfoOrgKpiTile(
                          value: '${d.openBids}',
                          title: 'Open Bids',
                          subtitle: '${d.bidsWonThisPeriod} won this period'),
                      CfoOrgKpiTile(
                          value: '${d.pendingChangeOrders}',
                          title: 'Pending COs',
                          subtitle: 'Requiring review'),
                      CfoOrgKpiTile(
                          value: '${d.teamSize}',
                          title: 'Team Size',
                          subtitle: 'Active employees'),
                      CfoOrgKpiTile(
                          value: d.outstandingArLabel,
                          title: 'Outstanding AR',
                          subtitle: '${d.overdueInvoices} overdue'),
                      CfoOrgKpiTile(
                          value: d.collectedYtdLabel,
                          title: 'Collected YTD',
                          subtitle: '${d.collectionRatePercent}% collection rate'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Donut row scrolls horizontally; the third card is clipped
                  // at the edge in the reference, hinting at the scroll.
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CfoOrgDonutCard(
                              title: 'Projects by Status',
                              slices: d.projectsByStatus),
                          const SizedBox(width: 8),
                          cfoTeamActivityCard(
                              active: d.teamActive, inactive: d.teamInactive),
                          const SizedBox(width: 8),
                          CfoOrgDonutCard(
                              title: 'Bids by Status', slices: d.bidsByStatus),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: CfoOrgHorizontalBarsCard(
                              title: 'Change Orders by Status',
                              data: d.changeOrdersByStatus),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CfoOrgVerticalBarsCard(
                              title: 'AR Aging', data: d.arAging),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _DetailTabBar(logic: logic),
                  const SizedBox(height: 14),
                  _TabBody(logic: logic),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DetailTabBar extends StatelessWidget {
  const _DetailTabBar({required this.logic});

  final CfoOrgDetailLogic logic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: CfoOrgPalette.chipFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          for (final tab in CfoDetailTab.values)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => logic.selectTab(tab),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    color: logic.tab == tab ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tab.label,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight:
                          logic.tab == tab ? FontWeight.w600 : FontWeight.w400,
                      color: logic.tab == tab
                          ? CfoOrgPalette.text
                          : CfoOrgPalette.muted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TabBody extends StatelessWidget {
  const _TabBody({required this.logic});

  final CfoOrgDetailLogic logic;

  @override
  Widget build(BuildContext context) {
    switch (logic.tab) {
      case CfoDetailTab.projects:
        return _ProjectsTab(logic: logic);
      case CfoDetailTab.bids:
        return CfoBidsTab(logic: logic);
      case CfoDetailTab.changeOrder:
        return CfoChangeOrdersTab(logic: logic);
      case CfoDetailTab.team:
        return CfoTeamTab(logic: logic);
      case CfoDetailTab.cfo:
        return CfoReceivablesTab(logic: logic);
    }
  }
}

class _ProjectsTab extends StatelessWidget {
  const _ProjectsTab({required this.logic});

  final CfoOrgDetailLogic logic;

  @override
  Widget build(BuildContext context) {
    final projects = logic.detail.projects;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CfoOrgSectionTitle(
          'Projects',
          trailing: CfoOrgOutlineButton(
            label: 'Export CSV',
            icon: Icons.file_download_outlined,
            onPressed: logic.exportProjectsCsv,
          ),
        ),
        const SizedBox(height: 10),
        if (projects.isEmpty)
          const CfoOrgCard(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: CfoOrgEmptyState(
              icon: Icons.folder_open,
              message: 'No projects yet.',
            ),
          )
        else
          for (final p in projects)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ProjectTile(project: p),
            ),
      ],
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({required this.project});

  final CfoOrgProject project;

  (Color, Color) get _statusColors {
    switch (project.status) {
      case CfoProjectStatus.active:
        return (CfoOrgPalette.green, CfoOrgPalette.greenSoft);
      case CfoProjectStatus.closed:
        return (CfoOrgPalette.text, CfoOrgPalette.chipFill);
      case CfoProjectStatus.planning:
        return (CfoOrgPalette.purple, CfoOrgPalette.purpleSoft);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = _statusColors;
    return CfoOrgCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(project.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: CfoOrgPalette.text)),
              ),
              const SizedBox(width: 6),
              CfoOrgPill(
                label: project.code,
                foreground: CfoOrgPalette.muted,
                background: CfoOrgPalette.chipFill,
                fontSize: 7.5,
                letterSpacing: 0,
              ),
              const SizedBox(width: 6),
              CfoOrgPill(
                  label: project.status.label, foreground: fg, background: bg),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(project.client,
                    style: const TextStyle(
                        fontSize: 9, color: CfoOrgPalette.muted)),
              ),
              Text(DateFormat('MMM d, yyyy').format(project.date),
                  style: const TextStyle(
                      fontSize: 9, color: CfoOrgPalette.muted)),
            ],
          ),
        ],
      ),
    );
  }
}
