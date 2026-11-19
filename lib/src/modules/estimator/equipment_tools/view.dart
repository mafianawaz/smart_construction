import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../../utils/app_icons.dart';
import 'equipment_tool_details/view.dart';
import 'logic.dart';
import 'models/equipment_models.dart';
import 'widgets/equipment_card.dart';
import 'widgets/equipment_filter_pill.dart';
import 'widgets/equipment_palette.dart';


/// Equipment list: search, All Status / All Type filters, equipment cards.
class EquipmentView extends StatelessWidget {
  const EquipmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: EquipmentLogic(),
      builder: (logic){
      return Scaffold(
        appBar: AppPrimaryBar(
          title: 'Equipment & Tools',
          showBackButton: true,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Manage your equipment fleet and track availability',
                style: TextStyle(
                    fontSize: 12, color: EquipmentPalette.textMuted),
              ),
              const SizedBox(height: 14),
              CustomTextField(
                hintText: 'Search Equipment....',
                onChange: logic.setSearch,
                leftIconPath: AppIcons.search,
              ),
              const SizedBox(height: 12),
              Obx(
                    () => Row(
                  children: [
                    EquipmentFilterPill<EquipmentStatus>(
                      label: logic.statusFilter.value?.label ??
                          'All Status',
                      allLabel: 'All Status',
                      filled: true,
                      options: EquipmentStatus.values,
                      optionLabel: (s) => s.label,
                      onSelected: logic.setStatus,
                    ),
                    const SizedBox(width: 8),
                    EquipmentFilterPill<String>(
                      label: logic.typeFilter.value ?? 'All Type',
                      allLabel: 'All Type',
                      options: logic.availableTypes,
                      optionLabel: (t) => t,
                      onSelected: logic.setType,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Equipment',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: EquipmentPalette.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                final list = logic.filtered;
                if (list.isEmpty) {
                  return _EmptyList(
                    filtered: logic.hasActiveFilters,
                    onClear: logic.clearFilters,
                  );
                }
                return Column(
                  children: [
                    for (final e in list) ...[
                      EquipmentCard(
                        equipment: e,
                        onTap: () =>
                            Get.to(() => EquipmentDetailView(equipment: e)),
                        // TODO: kebab menu actions (edit / delete)
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}


class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.filtered, required this.onClear});
  final bool filtered;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Text(
              filtered ? 'No equipment matches your filters' : 'No equipment yet',
              style: const TextStyle(
                  fontSize: 11, color: EquipmentPalette.textMuted),
            ),
            if (filtered) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: onClear,
                child: const Text('Clear filters',
                    style: TextStyle(
                        fontSize: 11, color: EquipmentPalette.orange)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
