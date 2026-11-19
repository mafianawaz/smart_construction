import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/project_enums.dart';
import '../../widgets/project_empty_card.dart';
import '../risks/widgets/risk_filter_pill.dart';
import '../widgets/project_action_button.dart';
import 'logic.dart';
import 'widgets/scope_item_card.dart';

/// Scope & Progress tab — "New scope item", search, the "All Statuses"
/// (filled) / "All Units" (outlined) pills, then the scope list or its
/// empty state. Reuses the generic `RiskFilterPill`.
class ScopeProgressView extends StatelessWidget {
  final String projectId;
  const ScopeProgressView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScopeProgressLogic>(
      init: ScopeProgressLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomIconButton(
                text: 'New scope item',
                icon: AppIcons.add,
                onPressed: logic.openCreate,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: 'Search scope of work...',
                leftIconPath: AppIcons.search,
                onChange: logic.onSearch,
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => RiskFilterPill<ScopeItemStatus>(
                          allLabel: 'All Statuses',
                          value: logic.statusFilter.value,
                          options: ScopeItemStatus.values,
                          labelOf: (s) => s.label,
                          onChanged: logic.setStatusFilter,
                          filled: true,
                        )),
                    const SizedBox(width: 8),
                    Obx(() => RiskFilterPill<String>(
                          allLabel: 'All Units',
                          value: logic.unitFilter.value,
                          options: projectUnitOptions,
                          labelOf: (u) => u,
                          onChanged: logic.setUnitFilter,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Obx(() {
                final all = logic.items.length;
                final list = logic.filteredItems;
                if (list.isEmpty) {
                  return ProjectEmptyCard(
                    icon: Icons.description_outlined,
                    message: all == 0
                        ? 'No scope items yet'
                        : 'No scope items match the search or filters.',
                  );
                }
                return Column(
                  children: [for (final item in list) ScopeItemCard(item: item)],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
