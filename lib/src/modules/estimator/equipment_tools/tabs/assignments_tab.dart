import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/equipment_models.dart';
import '../widgets/equipment_history_card.dart';

class AssignmentsTab extends StatelessWidget {
  const AssignmentsTab({super.key, required this.equipment});

  final EquipmentModel equipment;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d, y');
    return EquipmentHistoryCard(
      title: 'Assignment History',
      emptyMessage: 'No assignment history',
      rows: [
        for (final a in equipment.assignments)
          EquipmentHistoryRow(
            title: a.assignee,
            subtitle: a.endDate == null
                ? 'Since ${fmt.format(a.startDate)}'
                : '${fmt.format(a.startDate)} – ${fmt.format(a.endDate!)}',
            trailing: a.endDate == null ? 'Active' : null,
          ),
      ],
    );
  }
}
