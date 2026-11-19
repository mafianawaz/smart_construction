import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../../data/project_work_store.dart';
import '../../widgets/project_list_tile.dart';
import '../financials/widgets/panel_card.dart';
import '../widgets/project_format.dart';

/// Equipment tab — two sections, each a heading + muted line + bordered
/// card: "Equipment Plan" (planned from the estimate / takeoff) and
/// "Assigned Equipment" (currently on the project). Read-only: no create
/// flow in the references, so lists come straight from `ProjectWorkStore`.
class EquipmentView extends StatelessWidget {
  final String projectId;
  const EquipmentView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final planned = ProjectWorkStore.to.plannedEquipment(projectId);
    final assigned = ProjectWorkStore.to.assignedEquipment(projectId);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            title: 'Equipment Plan',
            subtitle: 'Planned equipment for this project from the estimate / takeoff',
          ),
          Obx(() => _Box(
                child: planned.isEmpty
                    ? const PanelEmptyBody(
                        icon: Icons.build_outlined,
                        message: 'No equipment planned for this project',
                        hint: 'Equipment added to the estimate or takeoff will appear here.',
                      )
                    : Column(children: [
                        for (final p in planned)
                          ProjectListTile(
                            icon: Icons.construction,
                            title: p.name,
                            subtitle: '${projectNumber(p.quantity)} units · ${p.days} days',
                          ),
                      ]),
              )),
          const SizedBox(height: 14),
          const _SectionHeader(
            title: 'Assigned Equipment',
            subtitle: 'Equipment currently assigned to this project',
          ),
          Obx(() => _Box(
                child: assigned.isEmpty
                    ? const PanelEmptyBody(
                        icon: Icons.local_shipping_outlined,
                        message: 'No equipment currently assigned to this project',
                      )
                    : Column(children: [
                        for (final a in assigned)
                          ProjectListTile(
                            icon: Icons.local_shipping_outlined,
                            title: a.name,
                            subtitle: [
                              if (a.operatorName != null) a.operatorName!,
                              'Since ${DateFormat('MMM d, y').format(a.assignedOn)}',
                            ].join(' · '),
                          ),
                      ]),
              )),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          ],
        ),
      );
}

class _Box extends StatelessWidget {
  final Widget child;
  const _Box({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: child,
      );
}
