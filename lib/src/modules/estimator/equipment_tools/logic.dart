import 'package:get/get.dart';

import 'data/equipment_mock_data.dart';
import 'models/equipment_models.dart';


/// Controller for the Equipment list screen (search + status/type filters).
class EquipmentLogic extends GetxController {
  final items = <EquipmentModel>[].obs;
  final searchQuery = ''.obs;
  final Rxn<EquipmentStatus> statusFilter = Rxn<EquipmentStatus>();
  final RxnString typeFilter = RxnString();

  @override
  void onInit() {
    super.onInit();
    // API seam: GET /equipment
    items.assignAll(EquipmentMockData.equipment());
  }

  /// Distinct equipment types present in the data, for the "All Type" menu.
  List<String> get availableTypes {
    final types = items.map((e) => e.type).toSet().toList()..sort();
    return types;
  }

  List<EquipmentModel> get filtered {
    final q = searchQuery.value.trim().toLowerCase();
    final status = statusFilter.value;
    final type = typeFilter.value;
    return items.where((e) {
      if (status != null && e.status != status) return false;
      if (type != null && e.type != type) return false;
      if (q.isEmpty) return true;
      return e.name.toLowerCase().contains(q) ||
          e.code.toLowerCase().contains(q) ||
          e.make.toLowerCase().contains(q) ||
          e.model.toLowerCase().contains(q);
    }).toList();
  }

  bool get hasActiveFilters =>
      searchQuery.value.trim().isNotEmpty ||
      statusFilter.value != null ||
      typeFilter.value != null;

  void setSearch(v) => searchQuery.value = v;
  void setStatus(EquipmentStatus? s) => statusFilter.value = s;
  void setType(String? t) => typeFilter.value = t;

  void clearFilters() {
    searchQuery.value = '';
    statusFilter.value = null;
    typeFilter.value = null;
  }
}
