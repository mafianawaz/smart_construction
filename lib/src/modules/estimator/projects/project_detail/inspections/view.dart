import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../../models/project_enums.dart';
import '../../widgets/project_badge.dart';
import '../risks/widgets/risk_filter_pill.dart';
import '../financials/widgets/panel_card.dart';
import 'logic.dart';

/// Inspections tab — two cards. Inspections: subtitle, Pending / Passed /
/// Failed outlined count tiles, "All Statuses" + "All Types" pills, then the
/// list or "No inspections found.". Material Testing: subtitle, four filled
/// count tiles (yellow / blue / green / red), the same pills, then the list
/// or the "No material tests" empty state.
class InspectionsView extends StatelessWidget {
  final String projectId;
  const InspectionsView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InspectionsLogic>(
      init: InspectionsLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            children: [
              _InspectionsCard(logic: logic),
              _MaterialTestingCard(logic: logic),
            ],
          ),
        );
      },
    );
  }
}

class _CardShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  const _CardShell({required this.title, required this.subtitle, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _CountTile extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  final Color? fill;

  const _CountTile({required this.count, required this.label, required this.color, this.fill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: fill ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: fill == null ? Border.all(color: Colors.grey.shade200) : null,
      ),
      child: Column(
        children: [
          Text('$count',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}

class _InspectionsCard extends StatelessWidget {
  final InspectionsLogic logic;
  const _InspectionsCard({required this.logic});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      title: 'Inspections',
      subtitle: 'Schedule and track inspections for this project',
      children: [
        Obx(() => Row(
              children: [
                for (final s in InspectionStatus.values) ...[
                  Expanded(
                    child: _CountTile(
                        count: logic.inspectionCount(s), label: s.label, color: s.color),
                  ),
                  if (s != InspectionStatus.values.last) const SizedBox(width: 8),
                ],
              ],
            )),
        const SizedBox(height: 12),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                RiskFilterPill<InspectionStatus>(
                  allLabel: 'All Statuses',
                  value: logic.inspectionStatus.value,
                  options: InspectionStatus.values,
                  labelOf: (s) => s.label,
                  onChanged: (s) => logic.inspectionStatus.value = s,
                ),
                RiskFilterPill<InspectionType>(
                  allLabel: 'All Types',
                  value: logic.inspectionType.value,
                  options: InspectionType.values,
                  labelOf: (t) => t.label,
                  onChanged: (t) => logic.inspectionType.value = t,
                ),
              ],
            )),
        const SizedBox(height: 10),
        Divider(height: 1, color: Colors.grey.shade200),
        Obx(() {
          final list = logic.filteredInspections;
          if (list.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 26),
              child: Center(
                child: Text(
                  logic.inspections.isEmpty
                      ? 'No inspections found.'
                      : 'No inspections match the filters.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            );
          }
          return Column(
            children: [
              const SizedBox(height: 10),
              for (final i in list)
                _RowTile(
                  title: i.title,
                  subtitle: '${i.type.label} · ${DateFormat('MMM d, y').format(i.scheduledFor)}',
                  badge: ProjectBadge(
                    label: i.status.label,
                    background: i.status.color.withAlpha(30),
                    foreground: i.status.color,
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}

class _MaterialTestingCard extends StatelessWidget {
  final InspectionsLogic logic;
  const _MaterialTestingCard({required this.logic});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      title: 'Material Testing',
      subtitle: 'Log and track material test records for QC compliance',
      children: [
        Obx(() => Row(
              children: [
                for (final s in MaterialTestStatus.values) ...[
                  Expanded(
                    child: _CountTile(
                      count: logic.testCount(s),
                      label: s.label,
                      color: s.foreground,
                      fill: s.background,
                    ),
                  ),
                  if (s != MaterialTestStatus.values.last) const SizedBox(width: 8),
                ],
              ],
            )),
        const SizedBox(height: 12),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                RiskFilterPill<MaterialTestStatus>(
                  allLabel: 'All Statuses',
                  value: logic.testStatus.value,
                  options: MaterialTestStatus.values,
                  labelOf: (s) => s.label,
                  onChanged: (s) => logic.testStatus.value = s,
                ),
                RiskFilterPill<MaterialTestType>(
                  allLabel: 'All Types',
                  value: logic.testType.value,
                  options: MaterialTestType.values,
                  labelOf: (t) => t.label,
                  onChanged: (t) => logic.testType.value = t,
                ),
              ],
            )),
        const SizedBox(height: 10),
        Divider(height: 1, color: Colors.grey.shade200),
        Obx(() {
          final list = logic.filteredTests;
          if (list.isEmpty) {
            if (logic.materialTests.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 26),
                child: Center(
                  child: Text('No material tests match the filters.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ),
              );
            }
            return const PanelEmptyBody(
              icon: Icons.description_outlined,
              message: 'No material tests',
              hint: 'Material tests track lab results for concrete, soil, steel, and other '
                  'construction materials.',
            );
          }
          return Column(
            children: [
              const SizedBox(height: 10),
              for (final t in list)
                _RowTile(
                  title: t.title,
                  subtitle: '${t.type.label} · ${DateFormat('MMM d, y').format(t.date)}',
                  badge: ProjectBadge(
                    label: t.status.label,
                    background: t.status.background,
                    foreground: t.status.foreground,
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}

/// Populated row shared by both lists. The reference only shows empty
/// states, so this layout is a guess (flagged in the notes file).
class _RowTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget badge;
  const _RowTile({required this.title, required this.subtitle, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          badge,
        ],
      ),
    );
  }
}
