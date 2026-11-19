import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/project_enums.dart';
import '../../models/scheduled_log_model.dart';
import '../financials/widgets/panel_card.dart';
import '../widgets/icon_stat_tile.dart';
import '../widgets/project_action_button.dart';
import '../widgets/scheduled_log_card.dart';
import 'reports_settings_logic.dart';
import 'widgets/report_list.dart';

/// "Reports Settings" — description, Weekly / Monthly counters, Generate
/// Report, Report Automation Settings (two switches), Email Recipients,
/// "Scheduled log emails" (loading / error / loaded) and the report list.
class ReportsSettingsView extends StatelessWidget {
  final String projectId;
  const ReportsSettingsView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportsSettingsLogic>(
      init: ReportsSettingsLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
              title: 'Reports Settings', showBackButton: true, centerTitle: true),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Generate and view weekly and monthly progress reports for this project.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  const SizedBox(height: 12),
                  Obx(() {
                    // Reading the list length subscribes this Obx.
                    final _ = logic.reports.length;
                    return Row(
                      children: [
                        Expanded(
                          child: IconStatTile(
                            icon: Icons.calendar_today_outlined,
                            color: const Color(0xFF2563EB),
                            label: 'Weekly Reports',
                            value: '${logic.countOf(ReportType.weekly)}',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: IconStatTile(
                            icon: Icons.calendar_month_outlined,
                            color: const Color(0xFFEA580C),
                            label: 'Monthly Reports',
                            value: '${logic.countOf(ReportType.monthly)}',
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 12),
                  ProjectActionButton(
                    label: 'Generate Report',
                    icon: Icons.add,
                    onPressed: logic.openGenerate,
                  ),
                  const SizedBox(height: 12),
                  Obx(() => PanelCard(
                        title: 'Report Automation Settings',
                        subtitle: 'Configure automatic report generation and email delivery',
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            children: [
                              _SwitchRow(
                                title: 'Auto-generate Weekly Reports',
                                subtitle:
                                    'Automatically generate a weekly report every Monday at 7:00 AM',
                                value: logic.automation.value.autoWeekly,
                                onChanged: logic.setAutoWeekly,
                              ),
                              Divider(height: 20, color: Colors.grey.shade200),
                              _SwitchRow(
                                title: 'Auto-generate Monthly Reports',
                                subtitle:
                                    'Automatically generate monthly reports on the 1st of each month',
                                value: logic.automation.value.autoMonthly,
                                onChanged: logic.setAutoMonthly,
                              ),
                            ],
                          ),
                        ),
                      )),
                  PanelCard(
                    title: 'Email Recipients',
                    subtitle: 'Add email addresses to receive auto-generated reports',
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  hintText: 'email@example.com',
                                  controller: logic.recipientCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              const SizedBox(width: 10),
                              ProjectActionButton(
                                label: 'Add',
                                expand: false,
                                height: 40,
                                onPressed: logic.addRecipient,
                              ),
                            ],
                          ),
                          Obx(() {
                            final list = logic.automation.value.recipients;
                            if (list.isEmpty) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  for (final e in list)
                                    InputChip(
                                      label: Text(e, style: const TextStyle(fontSize: 11)),
                                      backgroundColor: Colors.white,
                                      onDeleted: () => logic.removeRecipient(e),
                                    ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  PanelCard(
                        title: 'Scheduled log emails',
                        child: _ScheduledLogsBody(logic: logic),
                      ),
                  ReportList(reports: logic.reports, onTap: logic.download),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Switch(value: value, activeColor: AppColors.primaryOrange, onChanged: onChanged),
      ],
    );
  }
}

class _ScheduledLogsBody extends StatelessWidget {
  final ReportsSettingsLogic logic;
  const _ScheduledLogsBody({required this.logic});

  @override
  Widget build(BuildContext context) => Obx(_body);

  // Own Obx: a child's build runs outside the parent's Obx, so reads of
  // logsState / scheduledLogs must be tracked here.
  Widget _body() {
    switch (logic.logsState.value) {
      case CardLoadState.loading:
        return const Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        );
      case CardLoadState.error:
        return Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Couldn't load the scheduled log email settings. Try refreshing the page.",
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              TextButton(
                onPressed: logic.loadScheduledLogs,
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, minimumSize: const Size(0, 30)),
                child: const Text('Retry',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryOrange)),
              ),
            ],
          ),
        );
      case CardLoadState.loaded:
        return Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
          child: Column(
            children: [
              for (final type in ScheduledLogType.values)
                ScheduledLogSection(
                  settings: logic.scheduledLogs.firstWhere((l) => l.type == type,
                      orElse: () => ScheduledLogSettings(type: type)),
                  onCadenceChanged: (c) => logic.setLogCadence(type, c),
                  onSendTest: () => logic.sendTestNow(type),
                  onSave: () => logic.saveLog(type),
                ),
            ],
          ),
        );
    }
  }
}
