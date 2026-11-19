import 'package:get/get.dart';

import '../../data/projects_mock_data.dart';
import '../../models/project_enums.dart';
import '../../models/schedule_model.dart';
import 'email/schedule_email_view.dart';

/// Owns the Schedule tab (Gantt Chart / Forecast / Resources / Critical
/// Path) for one project. Put with `tag: projectId`.
class ScheduleLogic extends GetxController {
  final String projectId;

  /// Prefills the email screen's Subject.
  final String projectTitle;

  /// Project contacts on file, offered as recipients on the email screen.
  final List<String> contactEmails;

  ScheduleLogic({
    required this.projectId,
    this.projectTitle = '',
    this.contactEmails = const [],
  });

  final subTab = ScheduleSubTab.ganttChart.obs;
  onSubTabChange(ScheduleSubTab t) => subTab.value = t;

  final tasks = <GanttTaskModel>[].obs;
  final isGenerating = false.obs;

  final forecast = Rxn<ScheduleForecastModel>();
  final crewAssignments = <CrewAssignmentModel>[].obs;
  final recommendations = <OptimizationRecommendationModel>[].obs;
  final recentSends = <ScheduleSendRecord>[].obs;

  late final DateTime scheduleStart;

  /// Zero-float chain in start order. Reads [tasks], so call it inside an
  /// `Obx` to stay reactive.
  List<GanttTaskModel> get criticalPathTasks {
    final list = tasks.where((t) => t.isCriticalPath).toList();
    list.sort((a, b) => a.startOffsetDays.compareTo(b.startOffsetDays));
    return list;
  }

  @override
  void onInit() {
    super.onInit();
    // API: GET /projects/{id}/schedule
    scheduleStart = ProjectsMockData.scheduleStart(projectId);
    tasks.assignAll(ProjectsMockData.ganttTasks(projectId));
    forecast.value = ProjectsMockData.scheduleForecast(projectId);
    crewAssignments.assignAll(ProjectsMockData.crewAssignments(projectId));
    recommendations.assignAll(ProjectsMockData.optimizationRecommendations(projectId));
    recentSends.assignAll(ProjectsMockData.recentScheduleSends(projectId));
  }

  // API: POST /projects/{id}/schedule/generate
  Future<void> generateSchedule() async {
    if (isGenerating.value) return;
    isGenerating.value = true;
    try {
      final generated = await ProjectsMockData.generateSchedule(projectId);
      tasks.assignAll(generated);
    } finally {
      isGenerating.value = false;
    }
  }

  void dismissRecommendation(String id) => recommendations.removeWhere((r) => r.id == id);

  // API: GET /projects/{id}/schedule/export (PDF/CSV)
  void exportSchedule() {
    Get.snackbar('Export', 'Schedule export is not wired up yet.');
  }

  /// "Send To" — opens the email screen, which pops with the new
  /// [ScheduleSendRecord] once the email is sent.
  Future<void> sendSchedule() async {
    final sent = await Get.to<ScheduleSendRecord>(
      () => ScheduleEmailView(
        projectId: projectId,
        projectTitle: projectTitle,
        contactEmails: contactEmails,
      ),
      routeName: '/projects/$projectId/schedule/email',
    );
    if (sent != null) recentSends.insert(0, sent);
  }
}
