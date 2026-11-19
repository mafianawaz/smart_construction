import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/equipment_models.dart';
import '../widgets/equipment_history_card.dart';


class HourLogTab extends StatelessWidget {
  const HourLogTab({super.key, required this.equipment});

  final EquipmentModel equipment;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d, y');
    return EquipmentHistoryCard(
      title: 'Hour Logs',
      emptyMessage: 'No hour log recorded',
      rows: [
        for (final h in equipment.hourLogs)
          EquipmentHistoryRow(
            title: fmt.format(h.date),
            subtitle: h.note ?? '',
            trailing: '${h.hours.toStringAsFixed(1)} hrs',
          ),
      ],
    );
  }
}
