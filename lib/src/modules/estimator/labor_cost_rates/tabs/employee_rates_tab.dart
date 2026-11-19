import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../logic.dart';
import '../widgets/employee_rate_tile.dart';
import '../widgets/labor_rates_palette.dart';
import '../widgets/rates_section_intro.dart';

class EmployeeRatesTab extends StatelessWidget {
  final LaborCostRatesLogic logic;

  const EmployeeRatesTab({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final employees = logic.employeeRates;
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const RatesSectionIntro(
            title: 'Base Employee Rates',
            description:
                'Default hourly rates for each employee. These are used when '
                'no classification or project-specific rate applies.',
          ),
          const SizedBox(height: 12),
          RatesCardShell(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                for (var i = 0; i < employees.length; i++) ...[
                  if (i > 0)
                    const Divider(height: 1, color: LaborRatesPalette.divider),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: EmployeeRateTile(employee: employees[i]),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    });
  }
}
