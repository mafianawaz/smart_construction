import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../logic.dart';
import '../widgets/burden_rate_card.dart';
import '../widgets/rates_empty_card.dart';
import '../widgets/rates_section_intro.dart';

class BurdenRatesTab extends StatelessWidget {
  final LaborCostRatesLogic logic;

  const BurdenRatesTab({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = logic.burdenRates;
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const RatesSectionIntro(
            title: 'Burden Rate Configurations',
            description:
                'Define burden rate profile with component breakdowns for taxes, benefits, insurance, and overhead.',
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const RatesEmptyCard(message: 'No burden rate defined yet')
          else
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              BurdenRateCard(burden: items[i]),
            ],
        ],
      );
    });
  }
}
