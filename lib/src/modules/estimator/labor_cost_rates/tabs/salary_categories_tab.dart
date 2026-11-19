import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../logic.dart';
import '../widgets/salary_category_card.dart';
import '../widgets/rates_empty_card.dart';
import '../widgets/rates_section_intro.dart';

class SalaryCategoriesTab extends StatelessWidget {
  final LaborCostRatesLogic logic;

  const SalaryCategoriesTab({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = logic.salaryCategories;
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const RatesSectionIntro(
            title: 'Annual Salary Categories',
            description:
                'Define salary categories with base annual salaries for cost rate calculation.',
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const RatesEmptyCard(message: 'No salary categories yet')
          else
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              SalaryCategoryCard(category: items[i]),
            ],
        ],
      );
    });
  }
}
