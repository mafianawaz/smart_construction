import 'package:flutter/material.dart';

import '../models/equipment_models.dart';
import '../widgets/equipment_card.dart';
import '../widgets/equipment_details_card.dart';
import '../widgets/equipment_palette.dart';


/// Overview: "Equipment" label, details grid card, then the unit's own card.
class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key, required this.equipment});

  final EquipmentModel equipment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Equipment',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: EquipmentPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        EquipmentDetailsCard(equipment: equipment),
        const SizedBox(height: 10),
        EquipmentCard(equipment: equipment),
      ],
    );
  }
}
