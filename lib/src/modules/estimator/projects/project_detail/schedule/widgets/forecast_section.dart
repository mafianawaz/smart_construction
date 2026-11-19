import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../../../models/schedule_model.dart';
import '../../../widgets/project_empty_card.dart';

/// Schedule -> Forecast: three stat cards + the "Project Completion
/// Trends" chart card (empty state only until trend data exists).
class ForecastSection extends StatelessWidget {
  final ScheduleForecastModel forecast;
  const ForecastSection({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d, y');
    final variance = forecast.baselineVarianceDays;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ForecastStatCard(
          label: 'Projected Completion',
          value: fmt.format(forecast.projectedCompletion),
          caption: 'Baseline: ${fmt.format(forecast.baselineCompletion)}',
        ),
        _ForecastStatCard(
          label: 'Schedule Performance Index',
          value: forecast.spiLabel,
          caption: 'Last baseline to calculate',
        ),
        _ForecastStatCard(
          label: 'Baseline Variance',
          value: forecast.varianceLabel,
          valueColor: variance > 0 ? const Color(0xFFE53E3E) : const Color(0xFF1FA463),
          caption: 'Critical path remaining: ${forecast.criticalPathRemainingDays} days',
        ),
        const SizedBox(height: 8),
        const Text('Project Completion Trends',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 10),
        // API: GET /projects/{id}/schedule/trends — the chart replaces
        // this empty state once SPI history exists.
        const ProjectEmptyCard(icon: Icons.folder_outlined, message: 'No data to display'),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _TrendLegendItem(label: 'SPI = 1.0'),
            SizedBox(width: 14),
            _TrendLegendItem(label: 'SPI > 1.0'),
            SizedBox(width: 14),
            _TrendLegendItem(label: 'SPI < 1.0'),
          ],
        ),
      ],
    );
  }
}

class _ForecastStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String caption;
  final Color? valueColor;

  const _ForecastStatCard({
    required this.label,
    required this.value,
    required this.caption,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w800, color: valueColor ?? Colors.black87)),
          const SizedBox(height: 4),
          Text(caption, style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}

class _TrendLegendItem extends StatelessWidget {
  final String label;
  const _TrendLegendItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: Colors.grey.shade500, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
      ],
    );
  }
}
