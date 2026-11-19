import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../widgets/project_empty_card.dart';
import '../../widgets/project_list_tile.dart';
import '../widgets/project_format.dart';

/// Subcontractors tab (app bar reads "Subcontractors & Contracts") — an
/// empty card ("No subcontractor assignments") or one row per assignment.
/// Read-only: the reference shows no way to add an assignment, so there is
/// no controller; the list comes straight from `ProjectWorkStore`.
class SubcontractorsView extends StatelessWidget {
  final String projectId;
  const SubcontractorsView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final store = ProjectWorkStore.to.subcontractors(projectId);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Obx(() {
        if (store.isEmpty) {
          return const ProjectEmptyCard(
            icon: Icons.engineering_outlined,
            message: 'No subcontractor assignments',
          );
        }
        return Column(
          children: [
            for (final s in store)
              ProjectListTile(
                icon: Icons.engineering_outlined,
                title: s.company,
                subtitle: s.scope,
                trailing: Text(projectMoney(s.contractAmount),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
          ],
        );
      }),
    );
  }
}
