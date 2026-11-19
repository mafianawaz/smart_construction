import 'package:get/get.dart';

import '../models/equipment_models.dart';

/// Tagged controller for one equipment detail screen (tag = equipment id).
class EquipmentDetailLogic extends GetxController {
  EquipmentDetailLogic(this.equipment);

  final EquipmentModel equipment;
  final selectedTab = 0.obs;

  void selectTab(tab) => selectedTab.value = tab;
}
