import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/modules/super_intendent/equipment_tools/data/equipment_format.dart';
import 'package:smart_construction/src/modules/super_intendent/equipment_tools/models/equipment_models.dart';
import 'package:smart_construction/src/modules/super_intendent/equipment_tools/widgets/equipment_list_widgets.dart';
import 'package:smart_construction/src/modules/super_intendent/equipment_tools/widgets/equipment_stat_widgets.dart';
import 'logic.dart';
import 'widgets/equipment_header.dart';
import 'widgets/equipment_palette.dart';


/// Equipment & Tools: stats, search, filters and the fleet list.
///
/// Usage: `Get.to(() => const EquipmentListView());`
class EquipmentListView extends StatelessWidget {
  const EquipmentListView({super.key});

  void _onAction(
    EquipmentLogic logic,
    EquipmentItem item,
    EquipmentMenuAction action,
  ) {
    switch (action) {
      case EquipmentMenuAction.viewDetails:
        logic.openDetails(item);
        break;
      case EquipmentMenuAction.markAvailable:
        logic.setStatus(item, EquipmentStatus.available);
        break;
      case EquipmentMenuAction.markAssigned:
        logic.setStatus(item, EquipmentStatus.assigned);
        break;
      case EquipmentMenuAction.markInRepair:
        logic.setStatus(item, EquipmentStatus.inRepair);
        break;
      case EquipmentMenuAction.delete:
        logic.confirmDelete(item);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EquipmentLogic>(
      init: EquipmentLogic(),
      builder: (logic) {
        final list = logic.filtered;

        final statusOptions = [
          'All Status',
          for (final s in EquipmentStatus.values) s.label,
        ];
        final typeOptions = [
          'All Types',
          for (final t in EquipmentType.values) t.label,
        ];
        final statusIndex = logic.statusFilter == null
            ? 0
            : EquipmentStatus.values.indexOf(logic.statusFilter!) + 1;
        final typeIndex = logic.typeFilter == null
            ? 0
            : EquipmentType.values.indexOf(logic.typeFilter!) + 1;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SuperInEquipmentHeader(
                  title: 'Equipment & Tools',
                  subtitle: 'Manage your equipment fleet and track availability',
                  actionLabel: '+ Add Equipment',
                  onAction: logic.openAddForm,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      EquipmentTwoColumnGrid(
                        children: [
                          EquipmentStatCard(
                            label: 'Total Equipment',
                            value: '${logic.total}',
                            icon: Icons.local_shipping_outlined,
                            iconColor: SuperInEquipmentPalette.orange,
                            iconBackground: SuperInEquipmentPalette.orangeSoft,
                          ),
                          EquipmentStatCard(
                            label: 'Available',
                            value:
                                '${logic.countWhere(EquipmentStatus.available)}',
                            icon: Icons.check_circle_outline,
                            iconColor: SuperInEquipmentPalette.green,
                            iconBackground: SuperInEquipmentPalette.greenSoft,
                          ),
                          EquipmentStatCard(
                            label: 'Assigned',
                            value:
                                '${logic.countWhere(EquipmentStatus.assigned)}',
                            icon: Icons.group_outlined,
                            iconColor: SuperInEquipmentPalette.teal,
                            iconBackground: SuperInEquipmentPalette.tealSoft,
                          ),
                          EquipmentStatCard(
                            label: 'In Repair',
                            value:
                                '${logic.countWhere(EquipmentStatus.inRepair)}',
                            icon: Icons.build_outlined,
                            iconColor: SuperInEquipmentPalette.red,
                            iconBackground: SuperInEquipmentPalette.redSoft,
                          ),
                          EquipmentStatCard(
                            label: 'Fleet Value',
                            value: EquipmentFormat.compactMoney(logic.fleetValue),
                            icon: Icons.link,
                            iconColor: SuperInEquipmentPalette.blue,
                            iconBackground: SuperInEquipmentPalette.blueSoft,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      EquipmentSearchField(onChanged: logic.setQuery),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          EquipmentFilterPill(
                            options: statusOptions,
                            selectedIndex: statusIndex,
                            onSelected: (i) => logic.setStatusFilter(
                              i == 0 ? null : EquipmentStatus.values[i - 1],
                            ),
                          ),
                          const SizedBox(width: 8),
                          EquipmentFilterPill(
                            options: typeOptions,
                            selectedIndex: typeIndex,
                            onSelected: (i) => logic.setTypeFilter(
                              i == 0 ? null : EquipmentType.values[i - 1],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (list.isEmpty)
                        EquipmentEmptyState(
                          message: logic.hasActiveFilter
                              ? 'No equipment matches your search or filters.'
                              : 'No equipment yet.\nTap + Add Equipment to create one.',
                        )
                      else
                        for (var i = 0; i < list.length; i++) ...[
                          EquipmentCard(
                            item: list[i],
                            onTap: () => logic.openDetails(list[i]),
                            onAction: (a) => _onAction(logic, list[i], a),
                          ),
                          if (i != list.length - 1) const SizedBox(height: 12),
                        ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
