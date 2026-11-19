import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_color.dart';
import '../logic.dart';
import '../widgets/labor_rates_palette.dart';
import '../widgets/rates_empty_card.dart';
import '../widgets/rates_section_intro.dart';


class EmployeeAssignmentsTab extends StatelessWidget {
  final LaborCostRatesLogic logic;

  const EmployeeAssignmentsTab({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = logic.employeeAssignments;
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const RatesSectionIntro(
            title: 'Employee Classification Assignments',
            description:
                'Assign employees to jobs classifications with specific rates. '
                'Primary classification is used by default.',
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const RatesEmptyCard(message: 'No employee assignments yet')
          else
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              RatesCardShell(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        items[i].employeeName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: LaborRatesPalette.ink,
                        ),
                      ),
                    ),
                    Text(
                      items[i].classificationName,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
        ],
      );
    });
  }
}
