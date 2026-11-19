import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/pill_tab_group.dart';
import 'logic.dart';
import 'models/company_settings_models.dart';
import 'widgets/cs_palette.dart';
import 'widgets/financial_section.dart';
import 'widgets/operations_section.dart';
import 'widgets/people_section.dart';


class CompanySettingsView extends StatelessWidget {
  const CompanySettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompanySettingsLogic>(
      init: CompanySettingsLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Company Settings',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manage your organization\'s configuration, branding, and integrations',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: CsPalette.muted,
                  ),
                ),
                const SizedBox(height: 12),
                PillTabGroup(
                  items: CompanySection.values.map((t) {
                    return PillTabItem(
                      label: t.label,
                      value: t,
                    );
                  }).toList(),
                  selectedValue: logic.section,
                  onChanged: logic.selectSection,
                ),
                const SizedBox(height: 16),
                _body(logic),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _body(CompanySettingsLogic logic) {
    switch (logic.section) {
      case CompanySection.financial:
        return FinancialSection(logic: logic);
      case CompanySection.people:
        return PeopleSection(logic: logic);
      case CompanySection.operations:
        return OperationsSection(logic: logic);
    }
  }
}
