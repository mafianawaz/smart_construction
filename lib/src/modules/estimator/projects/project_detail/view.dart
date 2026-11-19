import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import '../data/project_work_store.dart';
import '../models/project_enums.dart';
import '../models/project_model.dart';
import '../models/scheduled_log_model.dart';
import 'ai_analysis/view.dart';
import 'brief/view.dart';
import 'daily_notes/view.dart';
import 'delays/view.dart';
import 'equipment/view.dart';
import 'estimate/view.dart';
import 'field_takeoff/view.dart';
import 'financials/view.dart';
import 'inspections/view.dart';
import 'job_info/view.dart';
import 'labor_hours/view.dart';
import 'lidar_scan/view.dart';
import 'location/view.dart';
import 'materials/view.dart';
import 'mobilization/view.dart';
import 'photos_videos/view.dart';
import 'plans_takeoff/view.dart';
import 'procurement/view.dart';
import 'punch_list/view.dart';
import 'risks/view.dart';
import 'schedule/view.dart';
import 'scope_progress/view.dart';
import 'subcontractors/view.dart';
import 'tm_tracking/view.dart';
import 'warranty/view.dart';
import 'transmittals/view.dart';
import 'submittals/view.dart';
import 'rfis/view.dart';
import 'maintenance/view.dart';
import 'closeout/view.dart';
import 'portal_access/view.dart';
import 'project_vault/view.dart';
import 'reports/view.dart';
import 'logic.dart';
import 'widgets/auto_change_orders_card.dart';
import 'widgets/certified_payroll_card.dart';
import 'widgets/change_order_card.dart';
import 'widgets/closeout_readiness_card.dart';
import 'widgets/data_quality_card.dart';
import 'widgets/description_card.dart';
import 'widgets/detail_card.dart';
import 'widgets/financial_info_card.dart';
import 'widgets/geofence_compliance_card.dart';
import 'widgets/geofence_enforcement_card.dart';
import 'widgets/geofence_zones_card.dart';
import 'widgets/health_score_card.dart';
import 'widgets/project_detail_header.dart';
import 'widgets/project_detail_tab_bar.dart';
import 'widgets/project_info_card.dart';
import 'widgets/scheduled_log_card.dart';

/// Project Detail — header (number/status/health) on Overview, a plain
/// title (plus a subtitle on Job Info/Risks) on every other tab, matching
/// each tab's own reference screen, and the shared scrolling pill bar
/// underneath. Every tab now has a real body.
class ProjectDetailView extends StatelessWidget {
  final ProjectModel project;
  const ProjectDetailView({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectDetailLogic>(
      init: ProjectDetailLogic(project),
      tag: project.id,
      builder: (logic) {
        return Obx(() {
          final currentTab = logic.tab.value;
          return Scaffold(
            appBar: AppPrimaryBar(
              // Portal Access is titled by its Client / Subcontractor strip.
              title: currentTab == ProjectDetailTab.portalAccess
                  ? ProjectWorkStore.to.portalSubTab(project.id).value.detailTitle
                  : currentTab.detailTitle,
              showBackButton: true,
              centerTitle: true,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  if (currentTab == ProjectDetailTab.overview)
                    ProjectDetailHeader(project: project)
                  else if (currentTab.detailSubtitle != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          currentTab.detailSubtitle!,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  ProjectDetailTabBar(selected: currentTab, onChanged: logic.onTabChange),
                  const SizedBox(height: 8),
                  Expanded(child: _buildTabBody(currentTab, logic)),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildTabBody(ProjectDetailTab tab, ProjectDetailLogic logic) {
    switch (tab) {
      case ProjectDetailTab.overview:
        return _OverviewTab(logic: logic);
      case ProjectDetailTab.jobInfo:
        return JobInfoView(projectId: project.id);
      case ProjectDetailTab.risks:
        return RiskRegisterView(projectId: project.id);
      case ProjectDetailTab.schedule:
        return ScheduleView(
          projectId: project.id,
          projectTitle: project.title,
          contactEmails: [if (project.contactEmail != null) project.contactEmail!],
        );
      case ProjectDetailTab.delays:
        return DelaysView(projectId: project.id);
      case ProjectDetailTab.mobilization:
        return MobilizationView(projectId: project.id);
      case ProjectDetailTab.plansTakeoff:
        return PlansTakeoffView(projectId: project.id);
      case ProjectDetailTab.fieldTakeoff:
        return FieldTakeoffView(projectId: project.id);
      case ProjectDetailTab.scopeProgress:
        return ScopeProgressView(projectId: project.id);
      case ProjectDetailTab.materials:
        return MaterialsView(projectId: project.id);
      case ProjectDetailTab.estimate:
        return EstimateView(projectId: project.id);
      case ProjectDetailTab.location:
        return LocationView(projectId: project.id);
      case ProjectDetailTab.procurement:
        return ProcurementView(projectId: project.id);
      case ProjectDetailTab.financials:
        return FinancialsView(
          projectId: project.id,
          projectNumber: project.number,
          projectLabel: '${project.number} · ${project.title}',
        );
      case ProjectDetailTab.dailyNotes:
        return DailyNotesView(projectId: project.id);
      case ProjectDetailTab.inspections:
        return InspectionsView(projectId: project.id);
      case ProjectDetailTab.punchList:
        return PunchListView(projectId: project.id);
      case ProjectDetailTab.photosVideos:
        return PhotosVideosView(projectId: project.id);
      case ProjectDetailTab.lidarScan:
        return LidarScanView(projectId: project.id);
      case ProjectDetailTab.tmTracking:
        return TmTrackingView(projectId: project.id);
      case ProjectDetailTab.laborHours:
        return LaborHoursView(projectId: project.id);
      case ProjectDetailTab.subcontractors:
        return SubcontractorsView(projectId: project.id);
      case ProjectDetailTab.equipment:
        return EquipmentView(projectId: project.id);
      case ProjectDetailTab.brief:
        return BriefView(projectId: project.id);
      case ProjectDetailTab.aiAnalysis:
        return AiAnalysisView(projectId: project.id);
      case ProjectDetailTab.rfis:
        return RfisView(projectId: project.id);
      case ProjectDetailTab.transmittals:
        return TransmittalsView(projectId: project.id);
      case ProjectDetailTab.submittals:
        return SubmittalsView(projectId: project.id);
      case ProjectDetailTab.closeoutPackage:
        return CloseoutView(projectId: project.id);
      case ProjectDetailTab.warranty:
        return WarrantyView(projectId: project.id);
      case ProjectDetailTab.maintenance:
        return MaintenanceView(projectId: project.id);
      case ProjectDetailTab.reports:
        return ReportsView(projectId: project.id);
      case ProjectDetailTab.projectVault:
        return ProjectVaultView(projectId: project.id);
      case ProjectDetailTab.portalAccess:
        return PortalAccessView(projectId: project.id, projectNumber: project.number);
    }
  }
}

class _OverviewTab extends StatelessWidget {
  final ProjectDetailLogic logic;
  const _OverviewTab({required this.logic});

  ScheduledLogSettings _logFor(List<ScheduledLogSettings> logs, ScheduledLogType type) =>
      logs.firstWhere((l) => l.type == type, orElse: () => ScheduledLogSettings(type: type));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProjectInfoCard(project: logic.project),
          Obx(() => HealthScoreCard(
                project: logic.project,
                isRefreshing: logic.isRefreshingHealth.value,
                onRefresh: logic.refreshHealthScore,
              )),
          FinancialInfoCard(project: logic.project),
          DescriptionCard(description: logic.project.description),
          DataQualityCard(score: logic.project.dataQualityScore),
          ChangeOrderCard(
                changeOrders: logic.changeOrders,
                onView: logic.viewChangeOrders,
              ),
          Obx(() => CloseoutReadinessCard(readiness: logic.closeoutReadiness.value)),
          Obx(() => GeofenceEnforcementCard(
                settings: logic.geofence.value,
                onModeChanged: logic.setEnforcementMode,
                onSetSiteCoordinates: logic.setSiteCoordinates,
                onPickOnMap: logic.pickOnMap,
              )),
          Obx(() => GeofenceZonesCard(
                zones: logic.geofence.value.zones,
                onAdd: logic.addGeofenceZone,
              )),
          Obx(() => AutoChangeOrdersCard(
                enabled: logic.autoChangeOrdersEnabled.value,
                onToggle: logic.toggleAutoGeneration,
                thresholdController: logic.autoChangeOrderThresholdCtrl,
                onSave: logic.saveCostThreshold,
              )),
          Obx(() => CertifiedPayrollCard(
                variant: logic.payrollFormVariant.value,
                onChanged: (v) => v == null ? null : logic.setPayrollFormVariant(v),
              )),
          Obx(() {
            final logs = logic.scheduledLogs;
            return DetailCard(
              title: 'Scheduled Log Emails',
              subtitle: "Email a PDF of the RFI or Submittal log to the "
                  "project's distribution recipients on a regular cadence. "
                  "Default is Off.",
              children: [
                ScheduledLogSection(
                  settings: _logFor(logs, ScheduledLogType.rfi),
                  onCadenceChanged: (c) => logic.setLogCadence(ScheduledLogType.rfi, c),
                  onSendTest: () => logic.sendTestNow(ScheduledLogType.rfi),
                  onSave: () => logic.saveLogSettings(ScheduledLogType.rfi),
                ),
                ScheduledLogSection(
                  settings: _logFor(logs, ScheduledLogType.submittal),
                  onCadenceChanged: (c) => logic.setLogCadence(ScheduledLogType.submittal, c),
                  onSendTest: () => logic.sendTestNow(ScheduledLogType.submittal),
                  onSave: () => logic.saveLogSettings(ScheduledLogType.submittal),
                ),
              ],
            );
          }),
          Obx(() => GeofenceComplianceCard(
                start: logic.complianceStart.value,
                end: logic.complianceEnd.value,
                shifts: logic.complianceShifts,
                isLoading: logic.isLoadingCompliance.value,
                onRangeChanged: logic.setComplianceRange,
              )),
        ],
      ),
    );
  }
}
