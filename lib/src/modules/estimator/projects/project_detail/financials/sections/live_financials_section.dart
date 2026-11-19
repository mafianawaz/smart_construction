import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../../../models/project_enums.dart';
import '../../widgets/project_format.dart';
import '../logic.dart';
import '../widgets/financials_card.dart';

const _warnBg = Color(0xFFFFF7E8);
const _warnBorder = Color(0xFFF7D9A0);
const _warnText = Color(0xFFB45309);

/// Live Financials — over-budget warning banner, "Budget vs Actual — Cost
/// Breakdown" (progress bar, six category rows, Total Actual Cost), Key
/// Metrics and Recent Snapshots.
class LiveFinancialsSection extends StatelessWidget {
  final FinancialsLogic logic;
  const LiveFinancialsSection({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final live = logic.live.value;
      final consumed = live.budgetConsumedPercent;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (live.isOverBudget)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _warnBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _warnBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 16, color: _warnText),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Costs are running ${live.overBudgetPercent.toStringAsFixed(1)}% over '
                      'budget. Monitor closely as the project progresses.',
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600, color: _warnText),
                    ),
                  ),
                ],
              ),
            ),
          FinancialsCard(
            title: 'Budget vs Actual — Cost Breakdown',
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Total Budget Consumed',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  ),
                  Text('${consumed.toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (consumed / 100).clamp(0.0, 1.0),
                  minHeight: 5,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primaryOrange),
                ),
              ),
              const SizedBox(height: 12),
              for (final c in CostCategory.values)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: c.color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(c.icon, size: 13, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(c.label,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                      ),
                      Text(projectMoney(live.costOf(c)),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              Divider(height: 18, color: Colors.grey.shade200),
              Row(
                children: [
                  const Expanded(
                    child: Text('Total Actual Cost',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                  Text(
                    projectMoney(live.totalActual),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: live.isOverBudget ? AppColors.redColor : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
          FinancialsCard(
            title: 'Key Metrics',
            children: [
              _MetricRow('Labor Hours', '${live.laborHours.toStringAsFixed(2)} hrs'),
              // Efficiency and spend rate need a budget baseline to compare
              // against; the reference shows "Unknown" for both.
              // API: GET /projects/{id}/financials/live (efficiency fields)
              const _MetricRow('Labor Efficiency', 'Unknown'),
              const _MetricRow('Material Spend Rate', 'Unknown'),
              _MetricRow('Subcontractors', '${live.subcontractorCount}'),
              _MetricRow('T&M Tickets', '${live.tmTicketCount}'),
            ],
          ),
          FinancialsCard(
            title: 'Recent Snapshots',
            children: [
              Text(
                'No historical snapshots yet. They are captured automatically every 15 minutes.',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  const _MetricRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
