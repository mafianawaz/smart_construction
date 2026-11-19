import 'package:flutter/material.dart';

import 'reports_palette.dart';

/// "No data available for this report." state. Local stand-in for `AppEmptyState`.
class ReportEmptyCard extends StatelessWidget {
  const ReportEmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: ReportsPalette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ReportsPalette.border),
      ),
      child: const Column(
        children: [
          Icon(Icons.description_outlined,
              size: 44, color: ReportsPalette.textMuted),
          SizedBox(height: 12),
          Text(
            'No data available for this report.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: ReportsPalette.textDark,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Select a project or adjust filters to view report data.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: ReportsPalette.textMuted),
          ),
        ],
      ),
    );
  }
}
