import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/project_enums.dart';
import '../../widgets/project_empty_card.dart';
import '../widgets/project_action_button.dart';
import '../widgets/project_select_field.dart';
import 'logic.dart';
import 'widgets/punch_item_tile.dart';

/// Punch List tab — "Export PDF" + orange "+ Add Item" side by side, a
/// search field, the three filter pills (All Statuses / All Trades /
/// All Priority), then the item tiles or an empty card. Tapping a tile
/// opens the detail screen; the tile's menu edits or deletes.
class PunchListView extends StatelessWidget {
  final String projectId;
  const PunchListView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PunchListLogic>(
      init: PunchListLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ProjectActionButton(
                      label: 'Export PDF',
                      icon: Icons.file_upload_outlined,
                      filled: false,
                      onPressed: logic.exportPdf,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ProjectActionButton(
                      label: 'Add Item',
                      icon: Icons.add,
                      onPressed: logic.openAdd,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: 'Search title, number, location...',
                leftIconPath: AppIcons.search,
                onChange: logic.onSearch,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Obx(() => ProjectSelectField<PunchStatus>(
                          allLabel: 'All Statuses',
                          value: logic.statusFilter.value,
                          options: PunchStatus.values,
                          labelOf: (s) => s.label,
                          onChanged: (v) => logic.statusFilter.value = v,
                        )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Obx(() => ProjectSelectField<ProjectTrade>(
                          allLabel: 'All Trades',
                          value: logic.tradeFilter.value,
                          options: ProjectTrade.values,
                          labelOf: (t) => t.label,
                          onChanged: (v) => logic.tradeFilter.value = v,
                        )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Obx(() => ProjectSelectField<PunchPriority>(
                          allLabel: 'All Priority',
                          value: logic.priorityFilter.value,
                          options: PunchPriority.values,
                          labelOf: (p) => p.label,
                          onChanged: (v) => logic.priorityFilter.value = v,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                final list = logic.filteredItems;
                if (list.isEmpty) {
                  return ProjectEmptyCard(
                    icon: Icons.checklist_outlined,
                    message: logic.items.isEmpty
                        ? 'No punch list items yet'
                        : 'No punch list items match the filters',
                  );
                }
                return Column(
                  children: [
                    for (final item in list)
                      PunchItemTile(
                        item: item,
                        onTap: () => logic.openDetail(item),
                        onEdit: () => logic.openEdit(item),
                        onDelete: () => logic.delete(item),
                      ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
