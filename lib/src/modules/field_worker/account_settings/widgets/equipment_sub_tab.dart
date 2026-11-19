import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../../../utils/app_color.dart';
import '../logic.dart';
import 'removable_chip.dart';


class EquipmentSubTabView extends StatelessWidget {
  const EquipmentSubTabView({super.key, required this.logic});

  final AccountSettingsLogic logic;

  @override
  Widget build(BuildContext context) {
    final suggestions = logic.filteredEquipmentSuggestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                hintText: 'Type equipment name...',
                controller: logic.equipmentSearchController,
                onSubmit: (value) => logic.addEquipment(value),
              ),
            ),
            const SizedBox(width: 8),
            _AddButton(onTap: () => logic.addEquipment(logic.equipmentSearchController.text)),
          ],
        ),
        if (suggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final suggestion in suggestions)
                GestureDetector(
                  onTap: () => logic.addEquipment(suggestion),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.fieldFill,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.fieldBorder),
                    ),
                    child: Text(
                      suggestion,
                      style: TextStyle(fontSize: 13, color: AppColors.textDark),
                    ),
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        if (logic.addedEquipment.isEmpty)
          const AppEmptyState(
            showButton: false,
            title: 'No equipment added yet',
            message: 'Use the search above to add equipment.',
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final equipment in logic.addedEquipment)
                RemovableChip(label: equipment, onRemove: () => logic.removeEquipment(equipment)),
            ],
          ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: AppColors.primaryOrange, borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
