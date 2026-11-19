import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import '../../widgets/project_empty_card.dart';
import '../widgets/project_action_button.dart';
import '../widgets/project_format.dart';
import 'import_takeoff_logic.dart';

/// "Import Takeoff Quantities" — pushed from the Estimate tab. The
/// category list is empty in the reference (button reads "Import 0
/// Categories"), so the populated rows are a guess — see
/// NOTES_ESTIMATING_TABS.md.
class ImportTakeoffView extends StatelessWidget {
  final String projectId;
  const ImportTakeoffView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImportTakeoffLogic>(
      init: ImportTakeoffLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Import Takeoff Quantities',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Quantity categories from takeoff to generate estimate line items',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => ProjectActionButton(
                        label: 'Import ${logic.selectedCount} '
                            '${logic.selectedCount == 1 ? 'Category' : 'Categories'}',
                        onPressed: logic.isImporting.value ? null : logic.importSelected,
                      )),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Obx(() {
                      final list = logic.categories.toList();
                      if (list.isEmpty) {
                        return const SingleChildScrollView(
                          child: ProjectEmptyCard(
                            icon: Icons.straighten,
                            message: 'No takeoff quantities available yet',
                          ),
                        );
                      }
                      return ListView.separated(
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final c = list[i];
                          final selected = logic.selectedIds.contains(c.id);
                          return InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => logic.toggle(c.id),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primaryOrange
                                      : Colors.grey.shade200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selected ? Icons.check_box : Icons.check_box_outline_blank,
                                    size: 20,
                                    color: selected
                                        ? AppColors.primaryOrange
                                        : Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(c.name,
                                        style: const TextStyle(
                                            fontSize: 12, fontWeight: FontWeight.w600)),
                                  ),
                                  Text('${projectNumber(c.quantity)} ${c.unit}',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
