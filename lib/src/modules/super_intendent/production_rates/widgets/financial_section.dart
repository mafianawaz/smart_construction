import 'package:flutter/material.dart';
import '../logic.dart';
import '../models/company_settings_models.dart';
import 'cs_basics.dart';
import 'cs_palette.dart';

/// Financial → Production Rates (Benchmarks / Cost Analytics).
class FinancialSection extends StatelessWidget {
  final CompanySettingsLogic logic;

  const FinancialSection({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Production Rates',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: CsPalette.text,
          ),
        ),
        const SizedBox(height: 10),
        CsUnderlineTabs(
          labels: FinancialTab.values.map((t) => t.label).toList(),
          selectedIndex: logic.financialTab.index,
          onChanged: (i) => logic.selectFinancialTab(FinancialTab.values[i]),
        ),
        const SizedBox(height: 14),
        if (logic.financialTab == FinancialTab.benchmarks)
          _Benchmarks(logic: logic)
        else
          const CsEmptyCard(
            icon: Icons.bar_chart_rounded,
            title: 'Cost analytics coming soon',
            message: 'Labor and material cost trends will appear here.',
          ),
      ],
    );
  }
}

class _Benchmarks extends StatelessWidget {
  final CompanySettingsLogic logic;

  const _Benchmarks({required this.logic});

  @override
  Widget build(BuildContext context) {
    final s = logic.stats;
    final items = logic.filteredBenchmarks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CsStatCard(
                icon: Icons.layers_outlined,
                value: '${s.sowTypesTracked}',
                label: 'SOW Types Tracked',
                caption: 'Across work categories',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CsStatCard(
                icon: Icons.calendar_today_outlined,
                value: '${s.totalWorkDays}',
                label: 'Total Work Days',
                caption: 'Days with recorded progress',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CsStatCard(
                icon: Icons.work_outline,
                value: '${s.projectsContributing}',
                label: 'Projects Contributing',
                caption: 'Projects with data',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CsStatCard(
                icon: Icons.assignment_outlined,
                value: '${s.dailyEntries}',
                label: 'Daily Entries',
                caption: 'Field progress reports',
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'Production Rate Benchmarks',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: CsPalette.text,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Average daily production by scope of work type',
          style: TextStyle(fontSize: 10.5, color: CsPalette.muted),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: CsSearchField(
                hint: 'Search SOW...',
                onChanged: logic.setSowSearch,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: CsFilterPill(
                expand: true,
                value: logic.unitFilter,
                options: logic.unitOptions,
                onSelected: logic.setUnitFilter,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: CsFilterPill(
                expand: true,
                value: logic.timeFilter,
                options: logic.timeOptions,
                onSelected: logic.setTimeFilter,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          const CsEmptyCard(
            icon: Icons.storage_outlined,
            title: 'No production data found',
            message: 'Daily progress entries from field workers will appear here',
          )
        else
          for (final b in items) ...[
            _BenchmarkCard(item: b),
            const SizedBox(height: 10),
          ],
        const SizedBox(height: 6),
        const _HowToUseCard(),
      ],
    );
  }
}

class _BenchmarkCard extends StatelessWidget {
  final ProductionBenchmark item;

  const _BenchmarkCard({required this.item});

  String _n(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CsPalette.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CsPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.sow,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: CsPalette.text,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: CsPalette.orangeSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.unit,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: CsPalette.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${_n(item.avgPerDay)} ${item.unit} / day avg',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: CsPalette.orange,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Range ${_n(item.minPerDay)} – ${_n(item.maxPerDay)} ${item.unit}',
            style: const TextStyle(fontSize: 10.5, color: CsPalette.muted),
          ),
          const SizedBox(height: 8),
          Text(
            '${item.workDays} work days · ${item.projects} projects · ${item.entries} entries',
            style: const TextStyle(fontSize: 10, color: CsPalette.hint),
          ),
        ],
      ),
    );
  }
}

class _HowToUseCard extends StatelessWidget {
  const _HowToUseCard();

  static const _tips = <List<String>>[
    [
      'For Estimating:',
      'Use the average daily rates to calculate crew-days needed for a task.',
    ],
    [
      'For Scheduling:',
      'WorkMax ranges help identify variability in daily output.',
    ],
    [
      'For Pricing:',
      'Combine production rates with labor costs from the Cost Rates page.',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CsPalette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CsPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline, size: 18, color: CsPalette.orange),
              SizedBox(width: 8),
              Text(
                'How to Use Production Rates',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: CsPalette.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final t in _tips)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 1),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CsPalette.orange, width: 1.5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${t[0]} ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: CsPalette.text,
                            ),
                          ),
                          TextSpan(text: t[1]),
                        ],
                      ),
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: CsPalette.muted,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
