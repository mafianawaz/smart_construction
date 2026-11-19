import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/estimate_models.dart';
import '../../models/project_enums.dart';
import '../../widgets/project_badge.dart';
import '../../widgets/project_empty_card.dart';
import '../widgets/project_action_button.dart';
import '../widgets/project_format.dart';
import 'logic.dart';
import 'widgets/estimate_line_item_tile.dart';
import 'widgets/estimate_stat_card.dart';

const _breakdownBg = Color(0xFFFFF7E8);
const _breakdownBorder = Color(0xFFF7D9A0);
const _breakdownAccent = Color(0xFFB45309);

/// Estimate tab — description + Draft badge, Approve & Sync, Markups /
/// PDF / Excel actions, the four stat tiles, the Org Markup Breakdown
/// card, then Estimate Line Items (Import Takeoff / Add Line Items).
///
/// The reference puts the "Draft" badge in the app bar's trailing slot;
/// `AppPrimaryBar`'s actions API isn't known here, so the badge sits at
/// the end of the description line instead — flagged in
/// NOTES_ESTIMATING_TABS.md.
class EstimateView extends StatelessWidget {
  final String projectId;
  const EstimateView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EstimateLogic>(
      init: EstimateLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Manage cost estimates and project budget',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ),
                  Obx(() {
                    final s = logic.status.value;
                    return ProjectBadge(
                        label: s.label, background: s.background, foreground: s.foreground);
                  }),
                ],
              ),
              const SizedBox(height: 12),
              ProjectActionButton(
                label: 'Approve & Sync to Budget',
                icon: Icons.check_circle_outline,
                onPressed: logic.approveAndSync,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ProjectActionButton(
                      label: 'Markups',
                      icon: Icons.tune,
                      onPressed: logic.openMarkups,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ProjectActionButton(
                      label: 'PDF',
                      icon: Icons.picture_as_pdf_outlined,
                      filled: false,
                      onPressed: logic.exportPdf,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ProjectActionButton(
                      label: 'Excel',
                      icon: Icons.table_chart_outlined,
                      filled: false,
                      onPressed: logic.exportExcel,
                      height: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                final t = logic.totals;
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: EstimateStatCard(
                            label: 'TOTAL ESTIMATE',
                            value: projectMoney(t.total),
                            caption: '${t.lineCount} line ${t.lineCount == 1 ? 'item' : 'items'}',
                            icon: Icons.attach_money,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: EstimateStatCard(
                            label: 'MATERIAL COST',
                            value: projectMoney(t.materialCost),
                            caption: '${projectPercent(t.materialShare)} of total',
                            icon: Icons.inventory_2_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: EstimateStatCard(
                            label: 'LABOR COST',
                            value: projectMoney(t.laborCost),
                            caption: '${projectPercent(t.laborShare)} of total',
                            icon: Icons.groups_outlined,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: EstimateStatCard(
                            label: 'PROFIT MARGIN',
                            value: projectPercent(t.profitMargin),
                            caption: projectMoney(t.profitAmount),
                            icon: Icons.percent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _OrgMarkupBreakdownCard(logic: logic, totals: t),
                  ],
                );
              }),
              const SizedBox(height: 16),
              const Text('Estimate Line Items',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ProjectActionButton(
                      label: 'Import Takeoff',
                      icon: Icons.file_upload_outlined,
                      filled: false,
                      onPressed: logic.openImportTakeoff,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ProjectActionButton(
                      label: 'Add Line Items',
                      icon: Icons.add,
                      onPressed: logic.openAddLineItem,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                final items = logic.items.toList();
                if (items.isEmpty) {
                  return const ProjectEmptyCard(
                    icon: Icons.description_outlined,
                    message: 'No Line items yet',
                  );
                }
                return Column(
                  children: [
                    for (final item in items)
                      EstimateLineItemTile(item: item, onRemove: () => logic.removeLineItem(item)),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _OrgMarkupBreakdownCard extends StatelessWidget {
  final EstimateLogic logic;
  final EstimateTotals totals;
  const _OrgMarkupBreakdownCard({required this.logic, required this.totals});

  @override
  Widget build(BuildContext context) {
    final hasItems = totals.lineCount > 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _breakdownBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _breakdownBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 14, color: _breakdownAccent),
              const SizedBox(width: 6),
              const Expanded(
                child: Text('Org Markup Breakdown',
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700, color: _breakdownAccent)),
              ),
              InkWell(
                onTap: logic.showOrgDefaults,
                child: const Text(
                  'DEFAULTS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _breakdownAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Markup-adjusted bid total using org-wide estimating factors. '
            'Add line items to see final totals.',
            style: TextStyle(fontSize: 11, color: _breakdownAccent),
          ),
          if (hasItems) ...[
            const SizedBox(height: 10),
            for (final kind in MarkupKind.values)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${kind.label} (${projectPercent(logic.effectivePercent(kind))})',
                        style: const TextStyle(fontSize: 11, color: _breakdownAccent),
                      ),
                    ),
                    Text(
                      projectMoney(totals.markupAmounts[kind] ?? 0),
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700, color: _breakdownAccent),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
