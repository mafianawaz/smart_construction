import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_equipment/view.dart';
import 'data/equipment_mock_data.dart';
import 'models/equipment_models.dart';


/// Controller for the Equipment & Tools list.
///
/// Plain fields + `update()` (GetBuilder), matching PricingLogic.
class EquipmentLogic extends GetxController {
  List<EquipmentItem> items = [];
  String query = '';
  EquipmentStatus? statusFilter; // null = All Status
  EquipmentType? typeFilter; // null = All Types

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() {
    items = EquipmentMockData.items();
    update();
  }

  // ───────────── derived ─────────────

  int get total => items.length;

  int countWhere(EquipmentStatus status) =>
      items.where((e) => e.status == status).length;

  double get fleetValue => items.fold(0.0, (sum, e) => sum + e.purchasePrice);

  List<EquipmentItem> get filtered {
    final q = query.trim().toLowerCase();
    return items.where((e) {
      if (statusFilter != null && e.status != statusFilter) return false;
      if (typeFilter != null && e.type != typeFilter) return false;
      if (q.isEmpty) return true;
      final d = e.details;
      final haystack =
          '${e.name} ${e.code} ${d.make} ${d.model} ${d.serialNumber}'
              .toLowerCase();
      return haystack.contains(q);
    }).toList();
  }

  bool get hasActiveFilter =>
      query.trim().isNotEmpty || statusFilter != null || typeFilter != null;

  // ───────────── filters ─────────────

  void setQuery(String value) {
    query = value;
    update();
  }

  void setStatusFilter(EquipmentStatus? value) {
    statusFilter = value;
    update();
  }

  void setTypeFilter(EquipmentType? value) {
    typeFilter = value;
    update();
  }

  // ───────────── create / edit ─────────────

  Future<void> openAddForm() async {
    final draft = await Get.to<EquipmentDraft>(() => const AddEquipmentView());
    if (draft != null) addEquipment(draft);
  }

  void addEquipment(EquipmentDraft draft) {
    final item = EquipmentItem(
      id: 'eq_${DateTime.now().microsecondsSinceEpoch}',
      code: _nextCode(),
      details: draft,
    );
    items = [item, ...items];
    update();
    Get.snackbar(
      'Equipment created',
      '${item.name} (${item.code}) was added to your tools.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  /// EQ-000N where N = highest existing number + 1.
  String _nextCode() {
    var highest = 0;
    for (final e in items) {
      final n = int.tryParse(e.code.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      if (n > highest) highest = n;
    }
    return 'EQ-${(highest + 1).toString().padLeft(4, '0')}';
  }

  void setStatus(EquipmentItem item, EquipmentStatus status) {
    items = [
      for (final e in items)
        if (e.id == item.id) e.copyWith(status: status) else e,
    ];
    update();
  }

  Future<void> confirmDelete(EquipmentItem item) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete equipment?'),
        content: Text('${item.name} (${item.code}) will be removed from your fleet.'),
        actions: [
          TextButton(
            onPressed: () => Get.back<bool>(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back<bool>(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    items = items.where((e) => e.id != item.id).toList();
    update();
  }

  void openDetails(EquipmentItem item) {
    Get.snackbar(
      item.name,
      'Equipment details is not wired to this list yet.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
