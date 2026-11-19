import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/project_action_button.dart';
import 'logic.dart';
import 'widgets/report_list.dart';

/// Reports tab (app bar "Progress Reports") — description, Settings +
/// Generate Report side by side, then the report list or the "No Reports
/// Yet" card.
class ReportsView extends StatelessWidget {
  final String projectId;
  const ReportsView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportsLogic>(
      init: ReportsLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Generate and view weekly and monthly progress reports.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ProjectActionButton(
                      label: 'Settings',
                      icon: Icons.settings_outlined,
                      filled: false,
                      onPressed: logic.openSettings,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ProjectActionButton(
                      label: 'Generate Report',
                      icon: Icons.add,
                      onPressed: logic.openGenerate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ReportList(reports: logic.reports, onTap: logic.download),
            ],
          ),
        );
      },
    );
  }
}
