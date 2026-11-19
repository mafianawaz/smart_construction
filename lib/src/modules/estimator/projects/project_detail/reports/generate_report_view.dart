import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';

import '../../models/project_enums.dart';
import '../widgets/project_date_field.dart';
import '../widgets/project_dropdown.dart';
import '../widgets/project_form_card.dart';
import 'generate_report_logic.dart';

/// "Generate Report" — description, a card with Report Type + Start/End
/// Date, the grey "Report will include:" card, and a pinned Generate
/// button.
class GenerateReportView extends StatelessWidget {
  final String projectId;
  const GenerateReportView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GenerateReportLogic>(
      init: GenerateReportLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
              title: 'Generate Report', showBackButton: true, centerTitle: true),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create and compile a comprehensive construction progress '
                          'report for your selected time range.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 12),
                        ProjectFormCard(
                          children: [
                            Obx(() => ProjectDropdown<ReportType>(
                                  label: 'Report Type',
                                  hint: 'Select',
                                  value: logic.type.value,
                                  options: ReportType.values,
                                  labelOf: (t) => t.label,
                                  onChanged: (v) {
                                    if (v != null) logic.type.value = v;
                                  },
                                )),
                            projectFieldGap,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Obx(() => ProjectDateField(
                                        label: 'Start Date',
                                        hint: 'dd/mm/yyyy',
                                        format: 'dd/MM/yyyy',
                                        value: logic.startDate.value,
                                        onChanged: (d) => logic.startDate.value = d,
                                      )),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Obx(() => ProjectDateField(
                                        label: 'End Date',
                                        hint: 'dd/mm/yyyy',
                                        format: 'dd/MM/yyyy',
                                        value: logic.endDate.value,
                                        onChanged: (d) => logic.endDate.value = d,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Report will include:',
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              for (final line in reportIncludes)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5, right: 8),
                                        child: Container(
                                          width: 4,
                                          height: 4,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade700,
                                              shape: BoxShape.circle),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(line,
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade700)),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Obx(() => CustomButton(
                        text: 'Generate',
                        onPressed: logic.isGenerating.value ? null : logic.generate,
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
