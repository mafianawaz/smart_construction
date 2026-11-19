import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../logic.dart';
import '../widgets/prevailing_wage_card.dart';
import '../widgets/rates_section_intro.dart';


class PrevailingWageTab extends StatelessWidget {
  final LaborCostRatesLogic logic;

  const PrevailingWageTab({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = logic.prevailingWages;
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const RatesSectionIntro(
            title: 'Project Prevailing Wage Rates',
            description:
                'Define prevailing wage rates for specific projects. These '
                'override employee base rates and classification rates.',
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            PrevailingWageCard(wage: items[i]),
          ],
        ],
      );
    });
  }
}
