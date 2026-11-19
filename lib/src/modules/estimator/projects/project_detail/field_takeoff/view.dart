import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../widgets/scroll_segment_toggle.dart';
import '../../models/project_enums.dart';
import '../../widgets/project_empty_card.dart';
import '../../widgets/project_list_tile.dart';
import 'logic.dart';

/// Field Takeoff tab — Field View lists takeoff items; Location
/// Breakdown groups them by location. The reference shows only Field
/// View's empty state, so the Location Breakdown copy/layout is a guess —
/// flagged in NOTES_PROJECT_TABS.md.
class FieldTakeoffView extends StatelessWidget {
  final String projectId;
  const FieldTakeoffView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FieldTakeoffLogic>(
      init: FieldTakeoffLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => ScrollSegmentToggle<FieldTakeoffSubTab>(
                    values: FieldTakeoffSubTab.values,
                    labelOf: (t) => t.label,
                    selected: logic.subTab.value,
                    onChanged: logic.onSubTabChange,
                  )),
              const SizedBox(height: 14),
              Obx(() => logic.subTab.value == FieldTakeoffSubTab.fieldView
                  ? _FieldViewSection(logic: logic)
                  : _LocationBreakdownSection(logic: logic)),
            ],
          ),
        );
      },
    );
  }
}

class _FieldViewSection extends StatelessWidget {
  final FieldTakeoffLogic logic;
  const _FieldViewSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = logic.items.toList();
      if (items.isEmpty) {
        return const ProjectEmptyCard(
          icon: Icons.description_outlined,
          message: 'No Takeoff items',
        );
      }
      return Column(
        children: [
          for (final i in items)
            ProjectListTile(
              icon: Icons.straighten_outlined,
              title: i.name,
              subtitle: i.location,
              trailing: Text(i.quantityLabel,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ),
        ],
      );
    });
  }
}

class _LocationBreakdownSection extends StatelessWidget {
  final FieldTakeoffLogic logic;
  const _LocationBreakdownSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final grouped = logic.itemsByLocation;
      if (grouped.isEmpty) {
        return const ProjectEmptyCard(
          icon: Icons.place_outlined,
          message: 'No Takeoff items',
        );
      }
      return Column(
        children: [
          for (final entry in grouped.entries)
            ProjectListTile(
              icon: Icons.place_outlined,
              title: entry.key,
              subtitle: '${entry.value.length} ${entry.value.length == 1 ? 'item' : 'items'}',
            ),
        ],
      );
    });
  }
}
