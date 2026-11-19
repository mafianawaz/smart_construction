import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/project_empty_card.dart';
import '../../widgets/project_action_button.dart';
import '../logic.dart';
import '../widgets/financial_record_tiles.dart';

/// Receipts — full-width Upload button, "Receipts" heading, then the list
/// or the "No receipts Uploaded Yet" empty state.
class ReceiptsSection extends StatelessWidget {
  final FinancialsLogic logic;
  const ReceiptsSection({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectActionButton(
          label: 'Upload',
          icon: Icons.file_upload_outlined,
          onPressed: logic.openUploadReceipt,
        ),
        const SizedBox(height: 14),
        const Text('Receipts', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Obx(() {
          final list = logic.receipts.toList();
          if (list.isEmpty) {
            return const ProjectEmptyCard(
              icon: Icons.receipt_long_outlined,
              message: 'No receipts Uploaded Yet',
            );
          }
          return Column(children: [for (final r in list) ReceiptRecordTile(record: r)]);
        }),
      ],
    );
  }
}
