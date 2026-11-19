import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';
import 'package:smart_construction/src/widgets/custom_tabbar.dart';
import 'package:smart_construction/src/widgets/custom_toggle_switch.dart';

import '../../models/project_enums.dart';
import 'logic.dart';
import 'widgets/risk_card.dart';
import 'widgets/risk_filter_pill.dart';
import 'widgets/risk_heat_map.dart';
import 'widgets/risk_heat_map_legend.dart';

/// Risks tab — "+ Add Risk", a Register/Heat Map underline toggle, and
/// either the filtered risk list (with an empty state when there are
/// none) or the 5×5 probability/impact matrix.
class RiskRegisterView extends StatelessWidget {
  final String projectId;
  const RiskRegisterView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RiskRegisterLogic>(
      init: RiskRegisterLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomIconButton(
                  text: 'Add Risk',
                  icon: AppIcons.add,
                  onPressed: logic.addRisk,
              ),
              const SizedBox(height: 14),
              Obx(()=> CustomTabBar(
                  tabs: [
                    CustomTabItem(label: 'Register'),
                    CustomTabItem(label: 'Heat Map'),
                  ],
                  selectedIndex: logic.viewMode.value,
                  onChanged: logic.onViewModeChange
              )),
              // _ViewModeToggle(logic: logic),
              const SizedBox(height: 14),
              Obx(() => logic.viewMode.value == 0
                  ? _RegisterSection(logic: logic)
                  : _HeatMapSection(logic: logic)),
            ],
          ),
        );
      },
    );
  }
}


class _RegisterSection extends StatelessWidget {
  final RiskRegisterLogic logic;
  const _RegisterSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => RiskFilterPill<RiskCategory>(
                    allLabel: 'All Categories',
                    value: logic.categoryFilter.value,
                    options: RiskCategory.values,
                    labelOf: (c) => c.label,
                    onChanged: logic.setCategoryFilter,
                    filled: true,
                  )),
              const SizedBox(width: 8),
              Obx(() => RiskFilterPill<RiskStatus>(
                    allLabel: 'All Statuses',
                    value: logic.statusFilter.value,
                    options: RiskStatus.values,
                    labelOf: (s) => s.label,
                    onChanged: logic.setStatusFilter,
                  )),
              const SizedBox(width: 8),
              Obx(() => RiskFilterPill<RiskSeverityBand>(
                    allLabel: 'All Severities',
                    value: logic.severityFilter.value,
                    options: RiskSeverityBand.values,
                    labelOf: (s) => s.label,
                    onChanged: logic.setSeverityFilter,
                  )),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Obx(() {
          final list = logic.filteredRisks;
          if (list.isEmpty) {
            return const AppEmptyState(
              icon: Icons.shield_outlined,
              title: 'No Risk Found',
              message: 'Add risks manually or use AI suggestions to get started.',
              showButton: false,
            );
          }
          return Column(children: [for (final r in list) RiskCard(risk: r)]);
        }),
      ],
    );
  }
}

class _HeatMapSection extends StatelessWidget {
  final RiskRegisterLogic logic;
  const _HeatMapSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RiskHeatMap(openRisks: logic.openRisksForMatrix),
              const SizedBox(height: 16),
               Divider(color: AppColors.fieldBorder,),
              const SizedBox(height: 14),
              const RiskHeatMapLegend(),
            ],
          )),
    );
  }
}
