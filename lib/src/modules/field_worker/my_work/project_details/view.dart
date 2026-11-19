import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/app_appbar.dart';
import '../../../../widgets/custom_tabbar.dart';
import 'logic.dart';
import 'widget/job_info_card.dart';

class ProjectDetailView extends StatelessWidget {
  const ProjectDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectDetailLogic>(
      init: ProjectDetailLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: const AppPrimaryBar(
            title: 'Project Detail',
            centerTitle: true,
            showBackButton: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProjectHeaderInfo(
                    jobId: logic.jobId,
                    status: logic.status,
                    projectTitle: logic.projectTitle,
                  ),
                  const SizedBox(height: 12),
                  CustomTabBar(
                    tabs:  [
                      CustomTabItem(label: 'Overview'),
                      CustomTabItem(label: 'Daily Notes'),
                    ],
                    selectedIndex: logic.selectedTab,
                    onChanged: logic.changeTab,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: logic.selectedTab == 0
                          ? _buildOverviewTab(logic)
                          : _buildDailyNotesTab(logic),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab(ProjectDetailLogic logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JobInfoCard(items: logic.jobInfo),
        ProjectStatisticsCard(items: logic.stats),
        OverallProgressCard(progress: logic.overallProgress),
        TeamMembersCard(members: logic.teamMembers),
        ChangeOrderCard(
          hasChangeOrder: logic.hasChangeOrder,
          onViewTap: () {
            // TODO: navigate to full change order list
          },
        ),
        CloseoutReadinessCard(items: logic.closeoutItems),
        EnforcementCard(
          enabled: logic.oneTimeEnforcementEnabled,
          onChanged: logic.toggleEnforcement,
        ),
        AutoChargeOrderCard(
          isEnabled: logic.autoChargeEnabled,
          onEnableTap: () {},
        ),
        CertifiedPayrollCard(
          description: "The default form used when generating certified payroll for this project. Choose the federal WH- 347 or the appropriate state DOT varient.",
          buttonLabel: "Follow WH-347",
          onFollowTap: () {},
        ),
      ],
    );
  }

  Widget _buildDailyNotesTab(ProjectDetailLogic logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DailyFieldReportCard(
          controller: logic.dailyReportController,
          onAddEntry: logic.addDailyReportEntry,
        ),
        DailyNotesCard(
          notes: logic.dailyNotes,
          onViewTap: () {},
        ),
      ],
    );
  }
}