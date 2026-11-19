import 'package:flutter/material.dart';

import '../models/kpi_model.dart';
import 'wf_common.dart';
import 'wf_palette.dart';

/// Small coloured category chip ("Financial", "Safety", "Quality").
class KpiCategoryChip extends StatelessWidget {
  const KpiCategoryChip(this.category, {super.key});
  final KpiCategory category;

  @override
  Widget build(BuildContext context) =>
      WfStatusChip(category.label, fg: category.color, bg: category.softColor);
}

/// Assignments list card: employee, status, KPI, target/period, progress.
class KpiAssignmentCard extends StatelessWidget {
  const KpiAssignmentCard({super.key, required this.assignment});
  final KpiAssignment assignment;

  @override
  Widget build(BuildContext context) {
    final a = assignment;
    final active = a.status == KpiAssignmentStatus.active;
    final target = a.target == null ? a.unit : '${wfNum(a.target!)} ${a.unit}';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WfPalette.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: WfPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.employeeName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: WfPalette.text,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      a.roleCode,
                      style: const TextStyle(fontSize: 9.5, color: WfPalette.muted),
                    ),
                  ],
                ),
              ),
              WfStatusChip(
                a.status.label,
                fg: active ? WfPalette.success : WfPalette.warning,
                bg: active ? WfPalette.successBg : WfPalette.warningBg,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                child: Text(
                  'KPI: ${a.kpiName}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: WfPalette.text),
                ),
              ),
              const SizedBox(width: 6),
              KpiCategoryChip(a.category),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: WfLabeledValue('Target', target)),
              Expanded(child: WfLabeledValue('Period', a.period)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Progress', style: TextStyle(fontSize: 9.5, color: WfPalette.muted)),
              const SizedBox(width: 8),
              Expanded(child: WfProgressBar(value: a.progress)),
              const SizedBox(width: 8),
              Text(
                '${(a.progress * 100).round()}%',
                style: const TextStyle(fontSize: 9.5, color: WfPalette.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Performance → "Performance Overview": ring gauge, summary, legend counts.
class PerformanceOverviewCard extends StatelessWidget {
  const PerformanceOverviewCard({
    super.key,
    required this.period,
    required this.periodOptions,
    required this.onPeriodChanged,
    required this.overallPercent,
    required this.assigned,
    required this.completed,
    required this.pending,
  });

  final String period;
  final List<String> periodOptions;
  final ValueChanged<String> onPeriodChanged;
  final int overallPercent;
  final int assigned;
  final int completed;
  final int pending;

  /// Placeholder wording thresholds (see NOTES).
  String get _summary {
    if (overallPercent >= 90) return 'Excellent performance';
    if (overallPercent >= 70) return 'Satisfactory performance target met';
    return 'Below target — needs improvement';
  }

  @override
  Widget build(BuildContext context) {
    return WfSectionCard(
      title: 'Performance Overview',
      trailing: WfFilterChip(
        display: period,
        options: periodOptions,
        selected: period,
        onSelected: onPeriodChanged,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 58,
                height: 58,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: overallPercent / 100,
                      strokeWidth: 6,
                      backgroundColor: WfPalette.fill,
                      valueColor: const AlwaysStoppedAnimation(WfPalette.orange),
                    ),
                    Center(
                      child: Text(
                        '$overallPercent%',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: WfPalette.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overall Score',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: WfPalette.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _summary,
                      style: const TextStyle(fontSize: 10.5, color: WfPalette.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: WfPalette.border),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LegendDot('Assigned: $assigned', WfPalette.info),
              _LegendDot('Completed: $completed', WfPalette.success),
              _LegendDot('Pending: $pending', WfPalette.orange),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: WfPalette.muted)),
      ],
    );
  }
}

/// One KPI result: name + category chip, target/actual/score, progress bar.
class KpiResultCard extends StatelessWidget {
  const KpiResultCard({super.key, required this.result});
  final KpiResult result;

  @override
  Widget build(BuildContext context) {
    final r = result;
    final color = r.category.color;
    final pct = r.scorePercent;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WfPalette.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: WfPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  r.kpiName,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: WfPalette.text,
                  ),
                ),
              ),
              KpiCategoryChip(r.category),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: WfLabeledValue('Target', wfNum(r.target))),
              Expanded(
                child: WfLabeledValue(
                  'Actual',
                  r.actual == null ? '—' : wfNum(r.actual!),
                ),
              ),
              Expanded(
                child: WfLabeledValue(
                  'Score',
                  r.isCompleted ? '${pct.round()}%' : '—',
                  valueColor: r.isCompleted ? color : WfPalette.hint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          WfProgressBar(value: pct / 100, color: color),
        ],
      ),
    );
  }
}
