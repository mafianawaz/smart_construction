import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import '../../../../utils/app_color.dart';
import 'widget/job_info_card.dart';


/// Controller backing [ProjectDetailView]. Holds the selected tab plus
/// mock data for both the Overview and Daily Notes tabs — swap the mock
/// getters below for real repository calls once the API is wired up.
class ProjectDetailLogic extends GetxController {
  int selectedTab = 0;

  void changeTab(int index) {
    selectedTab = index;
    update();
  }

  // ---- Header ----
  final String jobId = '24030';
  final String status = 'Active';
  final String projectTitle = 'testing general contractor';

  // ---- Overview tab ----
  final List<JobInfoItem> jobInfo =  [
    JobInfoItem(label: 'Client', value: 'James Wilson'),
    JobInfoItem(label: 'Status', value: 'ACTIVE', valueColor: AppColors.statusChip),
    JobInfoItem(label: 'Health Score', value: '93/100'),
    JobInfoItem(label: 'Created', value: 'June 25, 2026'),
    JobInfoItem(label: 'Project Type', value: 'General Contractor'),
    JobInfoItem(label: 'Address', value: '123 Construction Avenue'),
  ];

  final List<ProjectStatItem> stats =  [
    ProjectStatItem(
      value: '12',
      label: 'Total Days',
      icon: AppIcons.total,
      color: AppColors.textDark,
    ),
    ProjectStatItem(
      value: '8',
      label: 'Completed',
      icon: AppIcons.complete,
      color: AppColors.statusChip,
    ),
    ProjectStatItem(
      value: '4',
      label: 'Pending',
      icon: AppIcons.progress,
      color: AppColors.primaryOrange,
    ),
  ];

  final double overallProgress = 0.67;

  final List<TeamMember> teamMembers =  [
    TeamMember(name: 'Test Admin', role: 'Manager'),
    TeamMember(name: 'Field Worker', role: 'Worker'),
    TeamMember(name: 'Sarah Mitchell', role: 'Coordinator'),
  ];

  final bool hasChangeOrder = false;

  final List<CloseoutItem> closeoutItems = const [
    CloseoutItem(label: 'Punch List'),
    CloseoutItem(label: 'Closeout Documents'),
    CloseoutItem(label: 'Uploaded Status'),
    CloseoutItem(label: 'Cost Data'),
  ];

  bool oneTimeEnforcementEnabled = false;

  void toggleEnforcement(bool value) {
    oneTimeEnforcementEnabled = value;
    update();
  }

  final bool autoChargeEnabled = false;

  // ---- Daily Notes tab ----
  final TextEditingController dailyReportController = TextEditingController();

  final List<DailyNoteEntry> dailyNotes = [
    const DailyNoteEntry(
      authorName: 'Test Admin',
      authorRole: 'Admin',
      timestamp: 'Jul 15, 2025 5:30 PM',
      note: 'Hi hello, I have completed the project today.',
      isVoiceTranscription: true,
    ),
  ];

  void addDailyReportEntry() {
    if (dailyReportController.text.trim().isEmpty) return;
    dailyNotes.insert(
      0,
      DailyNoteEntry(
        authorName: 'Test Admin',
        authorRole: 'Admin',
        timestamp: 'Just now',
        note: dailyReportController.text.trim(),
      ),
    );
    dailyReportController.clear();
    update();
  }

  @override
  void onClose() {
    dailyReportController.dispose();
    super.onClose();
  }
}