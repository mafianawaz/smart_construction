import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/custom_toggle_switch.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/app_empty_filter.dart';
import 'logic.dart';
import 'models/production_models.dart';
import 'widgets/benchmark_card.dart';
import 'widgets/cost_analytics_card.dart';
import 'widgets/production_filter_bar.dart';
import 'widgets/production_info_card.dart';
import 'widgets/production_palette.dart';
import 'widgets/production_section_heading.dart';


/// Production Settings: Financials toggle (Benchmarks | Cost Analytics) over
/// one scrolling body. `ProductionSettingsLogic.selectedTab` picks the body.
class ProductionSettingsView extends StatelessWidget {
  const ProductionSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ProductionSettingsLogic(),
      builder: (logic){
      return Scaffold(
        appBar: AppPrimaryBar(
          title: 'Production Settings',
          showBackButton: true,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Manage your organization's configuration, branding, and "
                      'integrations. Use production rates to control scheduling '
                      'metrics.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 16),
                const ProductionSectionHeading(title: 'Financials'),
                const SizedBox(height: 12),
                Obx(() => CustomToggle(
                  options: [ProductionTab.benchmarks.label, ProductionTab.costAnalytics.label],
                  onChanged: logic.selectTab,
                  selectedIndex: logic.selectedTab.value,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                      () => logic.selectedTab.value == 0
                      ? _Benchmarks(logic: logic)
                      : _CostAnalytics(logic: logic),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

/// Search + unit/time filters wired to the logic; shared by both tabs.
Widget _filters(ProductionSettingsLogic logic) {
  return Obx(
    () => ProductionFilterBar(
      onSearch: logic.setSearch,
      unit: logic.unitFilter.value,
      unitOptions: logic.unitOptions,
      onUnit: logic.setUnit,
      timeRange: logic.timeRange.value,
      onTimeRange: logic.setTimeRange,
    ),
  );
}

class _Benchmarks extends StatelessWidget {
  final ProductionSettingsLogic logic;

  const _Benchmarks({required this.logic});

  static const _howTo = [
    ProductionInfoItem(
      title: 'For Estimating',
      body: 'Use the average daily rate to calculate crew-days needed for a bid.',
      inline: true,
    ),
    ProductionInfoItem(
      title: 'For Scheduling',
      body: 'Min/Max ranges help identify variability.',
      inline: true,
    ),
    ProductionInfoItem(
      title: 'For Pricing',
      body: 'Combine production rates with labor costs from the Cost Rates page.',
      inline: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProductionSectionHeading(
          title: 'Production Rate Benchmarks',
          description: 'Average daily production by scope of work type',
        ),
        const SizedBox(height: 12),
        _filters(logic),
        const SizedBox(height: 12),
        Obx(() {
          final items = logic.filteredBenchmarks;
          if (items.isEmpty) {
            return const _EmptyBlock(message: 'No benchmarks match your filters');
          }
          return Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                BenchmarkCard(benchmark: items[i]),
              ],
            ],
          );
        }),
        const SizedBox(height: 22),
        const ProductionSectionHeading(title: 'How to use Production Rates'),
        const SizedBox(height: 10),
        const ProductionInfoCard(items: _howTo),
      ],
    );
  }
}

class _CostAnalytics extends StatelessWidget {
  final ProductionSettingsLogic logic;

  const _CostAnalytics({required this.logic});

  static const _legend = [
    ProductionInfoItem(
      title: 'Labor Cost/Unit',
      body: 'Actual labor cost per unit. Calculated from approved time clock '
          'shifts with labor hours and crew wage rates.',
    ),
    ProductionInfoItem(
      title: 'Material Cost/Unit',
      body: 'Material expense per unit based on budgeted estimates from the '
          'linked estimate line items.',
    ),
    ProductionInfoItem(
      title: 'Profit/Unit',
      body: 'Unit revenue minus total costs per unit. Green indicates '
          'profitable work, red indicates a loss that needs investigation.',
    ),
    ProductionInfoItem(
      title: 'Confidence Level',
      body: 'Based on data quantity - HIGH (10+ days, 3+ projects), MEDIUM '
          '(5-9 days, 2+ projects), LOW (2-4 days). Higher confidence means '
          'more reliable benchmarks.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProductionSectionHeading(
          title: 'Cost Per Unit Analytics',
          description: 'Labor cost, materials, and profitability by scope of work',
        ),
        const SizedBox(height: 12),
        _filters(logic),
        const SizedBox(height: 12),
        Obx(() {
          final items = logic.filteredAnalytics;
          if (items.isEmpty) {
            return const _EmptyBlock(message: 'No analytics match your filters');
          }
          return Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                CostAnalyticsCard(analytics: items[i]),
              ],
            ],
          );
        }),
        const SizedBox(height: 22),
        const ProductionSectionHeading(title: 'Understanding Cost Analytics'),
        const SizedBox(height: 10),
        const ProductionInfoCard(items: _legend),
      ],
    );
  }
}

class _EmptyBlock extends StatelessWidget {
  final String message;

  const _EmptyBlock({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProductionPalette.cardBorder),
      ),
      child: AppEmptyState(
        icon: Icons.info_outline_rounded,
        title: message,
        message: '',
        showButton: false,
      ),
    );
  }
}
