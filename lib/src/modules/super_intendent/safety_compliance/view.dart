import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/pill_tab_group.dart';
import 'logic.dart';
import 'models/safety_models.dart';
import 'new_observation/view.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/modules_tab.dart';
import 'tabs/observations_tab.dart';
import 'tabs/osha_logs_tab.dart';
import 'tabs/training_tab.dart';



/// Entry screen of the Safety & Compliance hub.
///
/// Usage: `Get.to(() => const SafetyComplianceView());`
class SafetyComplianceView extends StatelessWidget {
  const SafetyComplianceView({super.key});

  Future<void> _openNewObservation(SafetyLogic logic) async {
    final created = await Get.to<SafetyObservation>(
      () => const NewObservationView(),
    );
    if (created != null) logic.addObservation(created);
  }

  Widget _body(SafetyLogic logic) {
    switch (logic.activeTab) {
      case SafetyTab.dashboard:
        return SafetyDashboardTab(
          key: const ValueKey('dashboard'),
          logic: logic,
        );
      case SafetyTab.observations:
        return SafetyObservationsTab(
          key: const ValueKey('observations'),
          logic: logic,
          onNewObservation: () => _openNewObservation(logic),
        );
      case SafetyTab.oshaLogs:
        return SafetyOshaLogsTab(
          key: const ValueKey('osha'),
          logic: logic,
        );
      case SafetyTab.modules:
        return SafetyModulesTab(
          key: const ValueKey('modules'),
          logic: logic,
        );
      case SafetyTab.training:
        return const SafetyTrainingTab(key: ValueKey('training'));
      }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SafetyLogic>(
      init: SafetyLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Safety & Compliance',
            subtitle: 'Unified hub for incidents, observations, inspections, training, and OSHA reporting.',
            showBackButton: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                PillTabGroup(
                  items: SafetyTab.values.map((t) {
                    return PillTabItem(
                      label: t.label,
                      value: t,
                    );
                  }).toList(),
                  selectedValue: logic.activeTab,
                  onChanged: logic.selectTab,
                ),
                SizedBox(height: 15,),
                Expanded(child: _body(logic)),
              ],
            ),
          ),
        );
      },
    );
  }
}
