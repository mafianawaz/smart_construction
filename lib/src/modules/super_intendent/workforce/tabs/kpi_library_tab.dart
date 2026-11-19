import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../../../utils/app_icons.dart';
import '../../../../widgets/custom_tabbar.dart';
import '../logic.dart';
import '../widgets/kpi_widgets.dart';
import '../widgets/wf_common.dart';
import '../widgets/wf_palette.dart';
import 'kpi_assignments_section.dart';
import 'kpi_performance_section.dart';

/// Performance → KPI Library (KPI Management header, inner tabs, templates).
class KpiLibraryTab extends StatelessWidget {
  const KpiLibraryTab({super.key, required this.logic});
  final WorkforceLogic logic;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: WfHeader(
                title: 'KPI Management',
                subtitle: 'Define, assign, and track key performance indicators for your team',
                fontSize: 16,
              ),
            ),
            GestureDetector(
              onTap: logic.showKpiHelp,
              child: Container(
                margin: const EdgeInsets.only(left: 8, top: 2),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: WfPalette.border),
                ),
                child: const Icon(Icons.question_mark, size: 13, color: WfPalette.muted),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CustomTabBar(
          selectedIndex: logic.kpiTab.value,
          onChanged: logic.setKpiTab,
          tabs: const [
            CustomTabItem(label:  'KPI Library'),
            CustomTabItem(label: 'Assignments'),
            CustomTabItem(label:'Performance'),
          ],
        ),
        const SizedBox(height: 14),
        ..._body(),
      ],
    );
  }

  List<Widget> _body() {
    switch (logic.kpiTab.value) {
      case 0:
        return _library();
      case 1:
        return [KpiAssignmentsSection(logic: logic)];
      case 2:
        return [KpiPerformanceSection(logic: logic)];
      default:
        return [];
    }
  }

  List<Widget> _library() {
    final list = logic.filteredTemplates;
    return [
      CustomTextField(
        hintText: 'Search templates...',
        controller: logic.templateSearch,
        onChange: logic.setTemplateSearch,
        leftIconPath: AppIcons.search,
      ),
      const SizedBox(height: 12),
      Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 145,
          child: CustomIconButton(
            text: 'Create KPI',
            icon: AppIcons.add,
            onPressed: logic.openCreateKpi,
          ),
        ),
      ),
      const SizedBox(height: 14),
      if (list.isEmpty)
        const Padding(
          padding: EdgeInsets.only(top: 24),
          child: AppEmptyState(
            icon: Icons.flag_outlined,
            title: 'No KPI templates',
            message: 'Create a KPI to start rating your team.',
            showButton: false,
          ),
        )
      else
        for (final t in list)
          KpiTemplateCard(
            template: t,
            onEdit: () => logic.openEditKpi(t),
            onDelete: () => logic.confirmDeleteKpi(t),
          ),
    ];
  }
}
