import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/project_enums.dart';
import '../../widgets/project_badge.dart';
import '../../widgets/project_empty_card.dart';
import '../financials/widgets/panel_card.dart';
import '../widgets/project_action_button.dart';
import '../widgets/project_date_field.dart';
import '../widgets/project_form_card.dart';
import '../widgets/project_record_tile.dart';
import '../widgets/project_select_field.dart';
import 'logic.dart';

/// Project Vault tab — orange "Export PDF/ZIP", search, a card with the
/// "All Categories" select and Start/End Date, then the "Vault Status"
/// panel (document list or "No documents found").
class ProjectVaultView extends StatelessWidget {
  final String projectId;
  const ProjectVaultView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectVaultLogic>(
      init: ProjectVaultLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            children: [
              ProjectActionButton(
                label: 'Export PDF/ZIP',
                icon: Icons.description_outlined,
                onPressed: logic.export,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: 'Search documents...',
                leftIconPath: AppIcons.search,
                onChange: logic.onSearch,
              ),
              const SizedBox(height: 12),
              ProjectFormCard(
                children: [
                  Obx(() => ProjectSelectField<String>(
                        allLabel: 'All Categories',
                        value: logic.category.value,
                        options: vaultCategories,
                        labelOf: (c) => c,
                        muted: true,
                        onChanged: (v) => logic.category.value = v,
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
              PanelCard(
                title: 'Vault Status',
                subtitle: 'Real-time active repository documents',
                child: Obx(() {
                  final list = logic.filtered;
                  if (list.isEmpty) {
                    return ProjectEmptyCard(
                      bordered: false,
                      icon: Icons.inventory_2_outlined,
                      title: 'No documents found',
                      message: logic.documents.isEmpty
                          ? 'Uploaded documents will appear here.'
                          : 'No documents match the filters.',
                    );
                  }
                  final day = DateFormat('MMM d, y');
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        for (final d in list)
                          ProjectRecordTile(
                            title: d.name,
                            lines: [
                              'Uploaded ${day.format(d.uploadedAt)}'
                                  '${d.uploadedBy == null ? '' : ' by ${d.uploadedBy}'}',
                            ],
                            badges: [
                              ProjectBadge(
                                  label: d.category,
                                  background: Colors.grey.shade100,
                                  foreground: Colors.grey.shade700),
                            ],
                            onTap: () => logic.open(d),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
