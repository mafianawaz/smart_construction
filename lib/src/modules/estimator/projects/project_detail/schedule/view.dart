import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import '../../../../../widgets/scroll_segment_toggle.dart';
import '../../models/project_enums.dart';
import 'logic.dart';
import 'widgets/critical_path_section.dart';
import 'widgets/forecast_section.dart';
import 'widgets/gantt_chart_card.dart';
import 'widgets/optimization_recommendation_card.dart';
import 'widgets/recent_sends_card.dart';
import 'widgets/resources_section.dart';

/// Schedule tab — Gantt Chart / Forecast / Resources / Critical Path
/// toggle. Every section wraps its own `Obx`, because a child widget's
/// `build` runs outside the parent `Obx` and would otherwise not react
/// to the logic's lists changing (e.g. after Generate Schedule).
class ScheduleView extends StatelessWidget {
  final String projectId;
  final String projectTitle;
  final List<String> contactEmails;

  const ScheduleView({
    super.key,
    required this.projectId,
    this.projectTitle = '',
    this.contactEmails = const [],
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleLogic>(
      init: ScheduleLogic(
        projectId: projectId,
        projectTitle: projectTitle,
        contactEmails: contactEmails,
      ),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => ScrollSegmentToggle<ScheduleSubTab>(
                    values: ScheduleSubTab.values,
                    labelOf: (t) => t.label,
                    selected: logic.subTab.value,
                    onChanged: logic.onSubTabChange,
                  )),
              const SizedBox(height: 14),
              Obx(() {
                switch (logic.subTab.value) {
                  case ScheduleSubTab.ganttChart:
                    return _GanttChartSection(logic: logic);
                  case ScheduleSubTab.forecast:
                    return _ForecastTab(logic: logic);
                  case ScheduleSubTab.resources:
                    return _ResourcesTab(logic: logic);
                  case ScheduleSubTab.criticalPath:
                    return _CriticalPathTab(logic: logic);
                }
              }),
            ],
          ),
        );
      },
    );
  }
}

class _ForecastTab extends StatelessWidget {
  final ScheduleLogic logic;
  const _ForecastTab({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final forecast = logic.forecast.value;
      if (forecast == null) return const SizedBox.shrink();
      return ForecastSection(forecast: forecast);
    });
  }
}

class _ResourcesTab extends StatelessWidget {
  final ScheduleLogic logic;
  const _ResourcesTab({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ResourcesSection(assignments: logic.crewAssignments.toList()));
  }
}

class _CriticalPathTab extends StatelessWidget {
  final ScheduleLogic logic;
  const _CriticalPathTab({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() => CriticalPathSection(
          tasks: logic.criticalPathTasks,
          startDate: logic.scheduleStart,
        ));
  }
}

class _GanttChartSection extends StatelessWidget {
  final ScheduleLogic logic;
  const _GanttChartSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (logic.tasks.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('No schedule yet',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade100,
                    child: Icon(Icons.event_note_outlined, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 12),
                  const Text('No schedule events yet',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    "Generate an AI-Powered schedule based on your project's "
                    'typical workflow and production rates',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Generate Schedule',
                    onPressed: logic.isGenerating.value ? null : logic.generateSchedule,
                  ),
                ],
              ),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GanttChartCard(
            tasks: logic.tasks.toList(),
            startDate: logic.scheduleStart,
            onExport: logic.exportSchedule,
            onSend: logic.sendSchedule,
          ),
          const SizedBox(height: 16),
          if (logic.recommendations.isNotEmpty) ...[
            const Text('AI Optimization Recommendation',
                style: TextStyle(fontWeight: FontWeight.w700,)),
            const SizedBox(height: 10),
            for (final r in logic.recommendations.toList())
              OptimizationRecommendationCard(
                recommendation: r,
                onDismiss: () => logic.dismissRecommendation(r.id),
              ),
            const SizedBox(height: 6),
          ],
          RecentSendsCard(sends: logic.recentSends.toList()),
        ],
      );
    });
  }
}
