import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import '../../../widgets/pill_tab_group.dart';
import 'logic.dart';
import 'models/crm_models.dart';
import 'tabs/analytics_tab.dart';
import 'tabs/contacts_tab.dart';
import 'tabs/organizations_tab.dart';
import 'tabs/calls_tab.dart';
import 'tabs/pipeline_tab.dart';
import 'tabs/quotes_tab.dart';
import 'tabs/reports_tab.dart';
import 'tabs/sequences_tab.dart';
import 'tabs/tasks_tab.dart';
import 'widgets/crm_palette.dart';


/// Customer Relationship Management screen: fixed header + tab bar, with a
/// scrolling body per tab (Organizations / Contacts / Analytics / Reports /
/// Sequences / Pipeline / Tasks / Calls / Quotes).
class CrmView extends StatelessWidget {
  const CrmView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CrmLogic>(
      init: CrmLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Customer Relationship Management',
            showBackButton: true,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Text('Manage contractors, subcontractors, suppliers, and vendors.', style: TextStyle(
                  fontSize: 12,
                  color: CrmPalette.textMuted,
                ),),
                SizedBox(height: 15,),
                PillTabGroup<CrmTab>(
                  items: CrmTab.values.map((tab) => PillTabItem<CrmTab>(
                    value: tab,
                    label: tab.label,
                  ),
                  ).toList(),
                  selectedValue: logic.tab,
                  onChanged: logic.setTab,
                  style: PillTabStyle.filled,
                ),
                SizedBox(height: 15,),
                Expanded(child: _bodyFor(logic)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bodyFor(CrmLogic logic) {
    switch (logic.tab) {
      case CrmTab.organizations:
        return OrganizationsTab(logic: logic);
      case CrmTab.contacts:
        return ContactsTab(logic: logic);
      case CrmTab.analytics:
        return AnalyticsTab(logic: logic);
      case CrmTab.reports:
        return ReportsTab(logic: logic);
      case CrmTab.sequences:
        return SequencesTab(logic: logic);
      case CrmTab.pipeline:
        return PipelineTab(logic: logic);
      case CrmTab.tasks:
        return TasksTab(logic: logic);
      case CrmTab.calls:
        return CallsTab(logic: logic);
      case CrmTab.quotes:
        return QuotesTab(logic: logic);
    }
  }
}
