import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/project_empty_card.dart';
import '../widgets/project_action_button.dart';
import 'logic.dart';
import 'widgets/material_budget_tile.dart';

/// Materials tab — "Add Usage" and the "Material Budget vs Actual" list
/// (empty state: "No Material Budgets").
class MaterialsView extends StatelessWidget {
  final String projectId;
  const MaterialsView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MaterialsLogic>(
      init: MaterialsLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProjectActionButton(
                label: 'Add Usage',
                icon: Icons.add,
                onPressed: logic.openRecordUsage,
              ),
              const SizedBox(height: 14),
              const Text('Material Budget vs Actual',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Obx(() {
                final rows = logic.budgetRows;
                if (rows.isEmpty) {
                  return const ProjectEmptyCard(
                    icon: Icons.inventory_2_outlined,
                    message: 'No Material Budgets',
                  );
                }
                return Column(children: [for (final r in rows) MaterialBudgetTile(row: r)]);
              }),
            ],
          ),
        );
      },
    );
  }
}
