import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/equipment_models.dart';
import '../widgets/equipment_history_card.dart';


class RepairTab extends StatelessWidget {
  const RepairTab({super.key, required this.equipment});

  final EquipmentModel equipment;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d, y');
    return EquipmentHistoryCard(
      title: 'Repair History',
      emptyMessage: 'No repair history',
      rows: [
        for (final r in equipment.repairs)
          EquipmentHistoryRow(
            title: r.description,
            subtitle: fmt.format(r.date),
            trailing: r.cost,
          ),
      ],
    );
  }
}
