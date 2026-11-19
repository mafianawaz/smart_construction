import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../../../../widgets/scroll_segment_toggle.dart';
import '../../models/project_enums.dart';
import '../../widgets/project_empty_card.dart';
import '../../widgets/project_list_tile.dart';
import 'logic.dart';
import 'widgets/document_folder_tile.dart';
import 'widgets/open_takeoff_web_card.dart';
import 'widgets/report_select_field.dart';

/// Plans & Takeoff tab — Plans / Addenda / Drawing Sets / Reports. Each
/// section wraps its own `Obx` (a child's `build` runs outside the
/// parent's tracking).
class PlansTakeoffView extends StatelessWidget {
  final String projectId;
  const PlansTakeoffView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlansTakeoffLogic>(
      init: PlansTakeoffLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => ScrollSegmentToggle<PlansSubTab>(
                    values: PlansSubTab.values,
                    labelOf: (t) => t.label,
                    selected: logic.subTab.value,
                    onChanged: logic.onSubTabChange,
                  )),
              const SizedBox(height: 14),
              Obx(() {
                switch (logic.subTab.value) {
                  case PlansSubTab.plans:
                    return _PlansSection(logic: logic);
                  case PlansSubTab.addenda:
                    return _AddendaSection(logic: logic);
                  case PlansSubTab.drawingSets:
                    return _DrawingSetsSection(logic: logic);
                  case PlansSubTab.reports:
                    return _ReportsSection(logic: logic);
                }
              }),
            ],
          ),
        );
      },
    );
  }
}

class _PlansSection extends StatelessWidget {
  final PlansTakeoffLogic logic;
  const _PlansSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CustomTextField(
                hintText: 'Search ...',
                leftIconPath: AppIcons.search,
                onChange: logic.onSearch,
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: logic.uploadDocument,
                child: const SizedBox(
                  width: 46,
                  height: 46,
                  child: Icon(Icons.file_upload_outlined, color: Colors.white, size: 22),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Obx(() {
          final folders = logic.visibleFolders;
          final expanded = logic.expandedFolderIds.toSet();
          final searching = logic.searchQuery.value.isNotEmpty;
          if (folders.isEmpty) {
            return const ProjectEmptyCard(
              icon: Icons.search_off_outlined,
              message: 'No documents match your search.',
            );
          }
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'DOCUMENTS (${logic.totalDocuments})',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                        color: Colors.grey.shade600),
                  ),
                )),
                const SizedBox(height: 6),
                for (final f in folders)
                  DocumentFolderTile(
                    folder: f,
                    // While searching, matching folders open so hits are visible.
                    expanded: searching || expanded.contains(f.id),
                    onToggle: () => logic.toggleFolder(f.id),
                  ),
              ],
            ),
          );
        }),
        const SizedBox(height: 14),
        OpenTakeoffWebCard(onTap: logic.openTakeoffWebView),
      ],
    );
  }
}

class _AddendaSection extends StatelessWidget {
  final PlansTakeoffLogic logic;
  const _AddendaSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = logic.addenda.toList();
      if (items.isEmpty) {
        return const ProjectEmptyCard(
          icon: Icons.description_outlined,
          message: 'No addenda have been created for this project yet.',
        );
      }
      final fmt = DateFormat('MMM d, y');
      return Column(
        children: [
          for (final a in items)
            ProjectListTile(
              icon: Icons.description_outlined,
              title: a.title,
              subtitle: 'Issued ${fmt.format(a.issuedAt)}',
            ),
        ],
      );
    });
  }
}

class _DrawingSetsSection extends StatelessWidget {
  final PlansTakeoffLogic logic;
  const _DrawingSetsSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = logic.drawingSets.toList();
      if (items.isEmpty) {
        return const ProjectEmptyCard(
          icon: Icons.description_outlined,
          message: 'No drawing sets created yet.',
        );
      }
      return Column(
        children: [
          for (final d in items)
            ProjectListTile(
              icon: Icons.layers_outlined,
              title: d.name,
              subtitle: '${d.sheetCount} ${d.sheetCount == 1 ? 'sheet' : 'sheets'}',
            ),
        ],
      );
    });
  }
}

class _ReportsSection extends StatelessWidget {
  final PlansTakeoffLogic logic;
  const _ReportsSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => ScrollSegmentToggle<ReportKind>(
              values: ReportKind.values,
              labelOf: (k) => k.label,
              selected: logic.reportKind.value,
              onChanged: logic.setReportKind,
              colored: true,
            )),
        const SizedBox(height: 14),
        Obx(() => Text(logic.reportKind.value.label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
        const SizedBox(height: 8),
        Obx(() => ReportSelectField(
              hint: logic.reportKind.value.label,
              value: logic.selectedQuantity.value,
              options: logic.quantityOptions.toList(),
              onChanged: logic.setQuantity,
            )),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: logic.exportReport,
            icon: const Icon(Icons.file_download_outlined, size: 16),
            label: const Text('Export', style: TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final items = logic.reportItems.toList();
          if (items.isEmpty) {
            return const ProjectEmptyCard(
              icon: Icons.description_outlined,
              message: 'No data available for this report',
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
        }),
      ],
    );
  }
}
