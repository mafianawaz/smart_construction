import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../../../../../widgets/scroll_segment_toggle.dart';
import '../../models/project_enums.dart';
import '../../widgets/project_empty_card.dart';
import '../../widgets/project_list_tile.dart';
import 'logic.dart';

/// Site Mobilization tab — Checklist / Method Statements toggle over two
/// empty-or-list sections. The reference's Checklist screen repeats the
/// Delays copy ("No delays reported…"), which is clearly a design
/// copy-paste, so the checklist empty message is new text — flagged in
/// NOTES_PROJECT_TABS.md.
class MobilizationView extends StatelessWidget {
  final String projectId;
  const MobilizationView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MobilizationLogic>(
      init: MobilizationLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => ScrollSegmentToggle<MobilizationSubTab>(
                    values: MobilizationSubTab.values,
                    labelOf: (t) => t.label,
                    selected: logic.subTab.value,
                    onChanged: logic.onSubTabChange,
                  )),
              const SizedBox(height: 14),
              Obx(() => logic.subTab.value == MobilizationSubTab.checklist
                  ? _ChecklistSection(logic: logic)
                  : _MethodStatementsSection(logic: logic)),
            ],
          ),
        );
      },
    );
  }
}

class _ChecklistSection extends StatelessWidget {
  final MobilizationLogic logic;
  const _ChecklistSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = logic.checklist.toList();
      if (items.isEmpty) {
        return const ProjectEmptyCard(
          icon: Icons.assignment_outlined,
          message: 'No checklist items yet.',
        );
      }
      return Column(
        children: [
          for (final item in items)
            ProjectListTile(
              icon: Icons.assignment_outlined,
              title: item.title,
              onTap: () => logic.toggleChecklistItem(item.id),
              trailing: Checkbox(
                value: item.isDone,
                activeColor: AppColors.primaryOrange,
                visualDensity: VisualDensity.compact,
                onChanged: (_) => logic.toggleChecklistItem(item.id),
              ),
            ),
        ],
      );
    });
  }
}

class _MethodStatementsSection extends StatelessWidget {
  final MobilizationLogic logic;
  const _MethodStatementsSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = logic.methodStatements.toList();
      if (items.isEmpty) {
        return const ProjectEmptyCard(
          icon: Icons.assignment_outlined,
          message: 'No Method statement yet.',
        );
      }
      final fmt = DateFormat('MMM d, y');
      return Column(
        children: [
          for (final m in items)
            ProjectListTile(
              icon: Icons.description_outlined,
              title: m.title,
              subtitle: 'Updated ${fmt.format(m.updatedAt)}',
            ),
        ],
      );
    });
  }
}
