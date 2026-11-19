import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../logic.dart';
import '../widgets/cost_assignment_card.dart';
import '../widgets/rates_empty_card.dart';
import '../widgets/rates_section_intro.dart';

class CostAssignmentsTab extends StatelessWidget {
  final LaborCostRatesLogic logic;

  const CostAssignmentsTab({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = logic.costAssignments;
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const RatesSectionIntro(
            title: 'Employee Cost Assignments',
            description:
                'Assign employees to salary categories and burden rate profiles to calculate fully burdened costs and defined hourly rates.',
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const RatesEmptyCard(message: 'No cost assignments yet')
          else
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              CostAssignmentCard(assignment: items[i]),
            ],
        ],
      );
    });
  }
}
