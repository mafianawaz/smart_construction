import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../logic.dart';
import '../models/crm_models.dart';
import '../widgets/crm_birthday_banner.dart';
import '../widgets/crm_controls.dart';
import '../widgets/crm_palette.dart';
import '../widgets/crm_search_field.dart';
import '../widgets/crm_stat_grid.dart';
import '../widgets/pipeline_board.dart';
import 'opportunity_form_view.dart';

/// Pipeline tab (reference screen 5): stats, search, stage/assignee filters,
/// Board | List toggle and Add Opportunity.
class PipelineTab extends StatelessWidget {
  final CrmLogic logic;

  const PipelineTab({super.key, required this.logic});

  Future<void> _addOpportunity() async {
    final result = await Get.to<OpportunityModel>(
      () => OpportunityFormView(
        id: logic.newOpportunityId(),
        organizationNames: logic.organizations.map((o) => o.name).toList(),
        owners: logic.owners,
      ),
    );
    if (result != null) logic.addOpportunity(result);
  }

  @override
  Widget build(BuildContext context) {
    final isBoard = logic.pipelineView == PipelineViewMode.board;
    final list = logic.filteredOpportunities;

    return ListView(
      children: [
        CrmBirthdayBanner(contacts: logic.upcomingBirthdays),
        const SizedBox(height: 12),
        CrmStatGrid(
          stacked: true,
          items: [
            CrmStatItem(
              label: 'Total Pipeline',
              value: crmMoney(logic.totalPipeline),
              icon: Icons.attach_money,
              color: CrmPalette.blue,
              tint: CrmPalette.blueTint,
            ),
            CrmStatItem(
              label: 'Weighted Value',
              value: crmMoney(logic.weightedValue),
              icon: Icons.trending_up,
              color: CrmPalette.success,
              tint: CrmPalette.successTint,
            ),
            CrmStatItem(
              label: 'Win Rate',
              value: '${logic.winRatePercent}%',
              icon: Icons.bar_chart,
              color: CrmPalette.purple,
              tint: CrmPalette.purpleTint,
            ),
            CrmStatItem(
              label: 'Open Deals',
              value: '${logic.openDeals}',
              icon: Icons.track_changes,
              color: CrmPalette.orange,
              tint: CrmPalette.orangeTint,
            ),
          ],
        ),
        const SizedBox(height: 12),
        CrmSearchField(
          hint: 'Search opportunities...',
          initialValue: logic.oppQuery,
          onChanged: logic.setOppQuery,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CrmDropdownPill<OpportunityStage>(
                allLabel: 'All Stages',
                options: OpportunityStage.values,
                labelOf: (s) => s.label,
                value: logic.stageFilter,
                onChanged: logic.setStageFilter,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CrmDropdownPill<String>(
                allLabel: 'All Assignees',
                options: logic.owners,
                labelOf: (s) => s,
                value: logic.assigneeFilter,
                onChanged: logic.setAssigneeFilter,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            CrmSegmented(
              options: const ['Board', 'List'],
              selectedIndex: isBoard ? 0 : 1,
              onChanged: (i) => logic.setPipelineView(
                i == 0 ? PipelineViewMode.board : PipelineViewMode.list,
              ),
            ),
            const Spacer(),
            CrmSmallButton(
              label: 'Add Opportunity',
              icon: Icons.add,
              filled: true,
              onTap: _addOpportunity,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (isBoard)
          PipelineBoard(
            stages: OpportunityStage.values,
            itemsFor: logic.opportunitiesIn,
          )
        else if (list.isEmpty)
          const CrmEmptyState(
            icon: Icons.view_list_outlined,
            title: 'No opportunities',
            message: 'Add an opportunity to start tracking your pipeline.',
          )
        else
          for (final opportunity in list)
            OpportunityCard(
              key: ValueKey(opportunity.id),
              opportunity: opportunity,
            ),
      ],
    );
  }
}
