import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../../models/project_enums.dart';
import '../../widgets/project_format.dart';
import '../logic.dart';
import '../widgets/panel_card.dart';

/// Production Rates — heading + "Open Billing Hub" link, underlined
/// Benchmarks / Cost Analytics tabs, a "Search SOW..." field and the
/// selected panel. Both panels are empty in the reference; the populated
/// rows are guesses (flagged in NOTES_BILLING_NOTES_INSPECTIONS.md).
class ProductionRatesSection extends StatelessWidget {
  final FinancialsLogic logic;
  const ProductionRatesSection({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Production Rates',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ),
            InkWell(
              onTap: logic.openBillingHub,
              child: const Text('Open Billing Hub',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryOrange)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() => _UnderlineTabs(
              selected: logic.productionTab.value,
              onChanged: logic.onProductionTabChange,
            )),
        const SizedBox(height: 12),
        CustomTextField(
          hintText: 'Search SOW...',
          leftIconPath: AppIcons.search,
          onChange: logic.onProductionSearch,
        ),
        const SizedBox(height: 12),
        Obx(() => logic.productionTab.value == ProductionRatesTab.benchmarks
            ? _benchmarks()
            : _costAnalytics()),
      ],
    );
  }

  Widget _benchmarks() {
    final rows = logic.filteredBenchmarks;
    return PanelCard(
      title: 'Production Rate Benchmarks',
      subtitle: 'Average daily production by scope of work for this project',
      child: rows.isEmpty
          ? const PanelEmptyBody(
              icon: Icons.track_changes,
              message: 'No production data found for this project.',
              hint: 'Data from progress entries from field reviews will appear here.',
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  for (final b in rows)
                    _row(
                      b.scopeName,
                      '${projectNumber(b.avgDailyQuantity)} ${b.unit}/day',
                      '${b.daysRecorded} ${b.daysRecorded == 1 ? 'day' : 'days'} recorded',
                    ),
                ],
              ),
            ),
    );
  }

  Widget _costAnalytics() {
    final rows = logic.filteredCostAnalytics;
    return PanelCard(
      title: 'Cost Per Unit Analytics',
      subtitle: 'Labor cost, material cost, and profitability for this project',
      child: rows.isEmpty
          ? const PanelEmptyBody(
              icon: Icons.attach_money,
              message: 'No cost data found for this project.',
              hint: 'Cost data appears when time clock shifts with labor hours are approved.',
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  for (final c in rows)
                    _row(
                      c.scopeName,
                      '${projectMoney(c.costPerUnit)}/${c.unit}',
                      'Labor ${projectMoney(c.laborCostPerUnit)} · '
                          'Material ${projectMoney(c.materialCostPerUnit)}',
                    ),
                ],
              ),
            ),
    );
  }

  Widget _row(String title, String value, String caption) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(caption, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
      );
}

/// Icon + label tabs with an orange underline under the selected one.
class _UnderlineTabs extends StatelessWidget {
  final ProductionRatesTab selected;
  final ValueChanged<ProductionRatesTab> onChanged;
  const _UnderlineTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          for (final t in ProductionRatesTab.values)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(t),
              child: Container(
                margin: const EdgeInsets.only(right: 18),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: t == selected ? AppColors.primaryOrange : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(t.icon,
                        size: 14,
                        color: t == selected ? AppColors.primaryOrange : Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      t.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: t == selected ? AppColors.primaryOrange : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
