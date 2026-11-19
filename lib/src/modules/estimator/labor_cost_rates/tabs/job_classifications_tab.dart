import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../logic.dart';
import '../widgets/job_classification_card.dart';
import '../widgets/rates_section_intro.dart';

class JobClassificationsTab extends StatelessWidget {
  final LaborCostRatesLogic logic;

  const JobClassificationsTab({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = logic.jobClassifications;
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // The reference design reuses the "Base Employee Rates" heading on
          // this tab; looks like a copy slip, so this uses the tab's own
          // name. Flagged in NOTES_LABOR_COST_RATES.md.
          const RatesSectionIntro(
            title: 'Job Classifications',
            description:
                'Default hourly rates for each classification. These are used '
                'when no project-specific rate applies.',
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            JobClassificationCard(classification: items[i]),
          ],
        ],
      );
    });
  }
}
