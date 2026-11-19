import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../../widgets/project_action_button.dart';
import '../logic.dart';
import '../widgets/financial_record_tiles.dart';
import '../widgets/panel_card.dart';

/// Billing — "New Pay App" (pale/disabled until an SOV exists), the
/// "Progress Billing" heading with an "Open Billing Hub" link, then the Pay
/// Applications, Stored Materials and Retention Releases panels (the last two
/// collapse).
class BillingSection extends StatelessWidget {
  final FinancialsLogic logic;
  const BillingSection({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => ProjectActionButton(
              label: 'New Pay App',
              icon: Icons.add,
              onPressed: logic.sovs.isEmpty ? null : logic.newPayApp,
            )),
        const SizedBox(height: 14),
        Row(
          children: [
            const Expanded(
              child: Text('Progress Billing',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
            InkWell(
              onTap: logic.openBillingHub,
              child: const Text('Open Billing Hub',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryOrange)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() {
          final sovs = logic.sovs.toList();
          return PanelCard(
            title: 'Pay Applications',
            child: sovs.isEmpty
                ? const PanelEmptyBody(
                    icon: Icons.description_outlined,
                    message: 'No pay applications for this project.',
                    hint: 'Create a Schedule of Values first.',
                  )
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(children: [
                      for (final s in sovs) SovRecordTile(record: s, paid: logic.paidFor(s.id)),
                    ]),
                  ),
          );
        }),
        Obx(() => PanelCard(
              title: 'Stored Materials',
              expanded: logic.storedMaterialsOpen.value,
              onToggle: () => logic.storedMaterialsOpen.toggle(),
              child: const PanelEmptyBody(
                icon: Icons.inventory_2_outlined,
                message: 'No stored materials for this project.',
              ),
            )),
        Obx(() => PanelCard(
              title: 'Retention Releases',
              expanded: logic.retentionOpen.value,
              onToggle: () => logic.retentionOpen.toggle(),
              child: const PanelEmptyBody(
                icon: Icons.shield_outlined,
                message: 'No retention releases for this project.',
              ),
            )),
      ],
    );
  }
}
