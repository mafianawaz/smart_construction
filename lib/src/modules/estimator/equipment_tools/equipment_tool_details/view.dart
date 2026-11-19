import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import '../../../../widgets/custom_toggle_switch.dart';
import '../../marketplace/widgets/marketplace_primitives.dart';
import '../models/equipment_models.dart';
import '../tabs/assignments_tab.dart';
import '../tabs/coming_soon_tab.dart';
import '../tabs/hour_log_tab.dart';
import '../tabs/overview_tab.dart';
import '../tabs/repair_tab.dart';
import 'logic.dart';

/// Equipment detail: scrollable tab bar + the selected tab's body.
/// Stateful only to own the tagged controller's lifecycle (put / delete).
class EquipmentDetailView extends StatefulWidget {
  const EquipmentDetailView({super.key, required this.equipment});

  final EquipmentModel equipment;

  @override
  State<EquipmentDetailView> createState() => _EquipmentDetailViewState();
}

class _EquipmentDetailViewState extends State<EquipmentDetailView> {
  late final EquipmentDetailLogic logic;

  @override
  void initState() {
    super.initState();
    logic = Get.put(EquipmentDetailLogic(widget.equipment),
        tag: widget.equipment.id);
  }

  @override
  void dispose() {
    Get.delete<EquipmentDetailLogic>(tag: widget.equipment.id);
    super.dispose();
  }

  Widget _body(EquipmentDetailTab tab) {
    final e = widget.equipment;
    switch (tab) {
      case EquipmentDetailTab.overview:
        return OverviewTab(equipment: e);
      case EquipmentDetailTab.assignments:
        return AssignmentsTab(equipment: e);
      case EquipmentDetailTab.repair:
        return RepairTab(equipment: e);
      case EquipmentDetailTab.hourLog:
        return HourLogTab(equipment: e);
      case EquipmentDetailTab.preventativeMaintenance:
        return const ComingSoonTab(
          title: 'Preventative Maintenance',
          message: 'No maintenance schedule set',
        );
      case EquipmentDetailTab.documents:
        return const ComingSoonTab(
          title: 'Documents',
          message: 'No documents uploaded',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Equipment & Tools',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Obx(() => CustomToggle(
              options: EquipmentDetailTab.values.map((t) => t.label).toList(),
              selectedIndex: logic.selectedTab.value,
              onChanged: logic.selectTab,
            )),
            SizedBox(height: 20,),
            Obx(() => SingleChildScrollView(child: _body(EquipmentDetailTab.values[logic.selectedTab.value],),),),
          ],
        ),
      ),
    );
  }
}
