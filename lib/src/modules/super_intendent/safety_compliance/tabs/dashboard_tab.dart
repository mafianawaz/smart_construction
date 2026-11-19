import 'package:flutter/material.dart';
import '../logic.dart';
import '../widgets/safety_common_widgets.dart';
import '../widgets/safety_palette.dart';

/// Dashboard tab: Lagging then Leading indicators.
class SafetyDashboardTab extends StatelessWidget {
  final SafetyLogic logic;

  const SafetyDashboardTab({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SafetySectionTitle(
          title: 'Lagging Indicators (${logic.dashboardYear})',
          subtitle: 'OSHA recordable rates per 200,000 hours worked',
          trailing: _HoursChip(label: logic.hoursWorkedLabel),
        ),
        const SizedBox(height: 15),
        SafetyTwoColumnGrid(
          children: [
            for (final item in logic.laggingIndicators)
              SafetyIndicatorCard(data: item),
          ],
        ),
        const SizedBox(height: 22),
        const SafetySectionTitle(
          title: 'Leading Indicators',
          subtitle: 'Proactive safety activity preventing future incidents',
        ),
        const SizedBox(height: 12),
        SafetyTwoColumnGrid(
          children: [
            for (final item in logic.leadingIndicators)
              SafetyIndicatorCard(data: item),
          ],
        ),
      ],
    );
  }
}

class _HoursChip extends StatelessWidget {
  final String label;

  const _HoursChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: SafetyPalette.border),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 8.5,
          fontWeight: FontWeight.w600,
          color: SafetyPalette.textDark,
        ),
      ),
    );
  }
}
