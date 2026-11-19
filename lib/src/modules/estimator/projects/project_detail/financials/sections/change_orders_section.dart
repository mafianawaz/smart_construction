import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/project_empty_card.dart';
import '../../widgets/project_action_button.dart';
import '../logic.dart';
import '../widgets/financial_record_tiles.dart';

/// Change Orders — grey "Export all CSV" + orange "New Change Order" side
/// by side, then the list or the "No Change order Yet" empty state.
class ChangeOrdersSection extends StatelessWidget {
  final FinancialsLogic logic;
  const ChangeOrdersSection({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ProjectActionButton(
                label: 'Export all CSV',
                icon: Icons.file_upload_outlined,
                filled: false,
                onPressed: logic.exportChangeOrdersCsv,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ProjectActionButton(
                label: 'New Change Order',
                icon: Icons.add,
                onPressed: logic.openNewChangeOrder,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          final list = logic.changeOrders.toList();
          if (list.isEmpty) {
            return const ProjectEmptyCard(
              icon: Icons.description_outlined,
              message: 'No Change order Yet',
            );
          }
          return Column(children: [for (final c in list) ChangeOrderRecordTile(record: c)]);
        }),
      ],
    );
  }
}
