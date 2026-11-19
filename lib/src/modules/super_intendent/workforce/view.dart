import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import '../../../widgets/pill_tab_group.dart';
import 'logic.dart';
import 'tabs/performance_tab.dart';
import 'tabs/rewards_tab.dart';
import 'tabs/workers_tab.dart';


/// Workforce Management root screen (Workers / Performance / Rewards).
///
/// Sits inside the app's bottom-nav shell, so it renders no nav bar itself.
class WorkforceView extends StatelessWidget {
  const WorkforceView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkforceLogic>(
      init: WorkforceLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: SecondaryAppbar(
            title: 'Workforce Management',
            subTitle: 'Manage your team, track performance, and recognize achievements',
            count: logic.projectCount.toString(),
            isHome: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PillTabGroup<WorkforceTab>(
                  selectedValue: logic.tab,
                  onChanged: logic.setTab,
                  items:  [
                    PillTabItem(value: WorkforceTab.workers,label: 'Workers'),
                    PillTabItem(value: WorkforceTab.performance,label: 'Performance'),
                    PillTabItem(value: WorkforceTab.rewards,label: 'Rewards'),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(child: _body(logic)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _body(WorkforceLogic logic) {
    switch (logic.tab) {
      case WorkforceTab.workers:
        return WorkersTab(logic: logic);
      case WorkforceTab.performance:
        return PerformanceTab(logic: logic);
      case WorkforceTab.rewards:
        return RewardsTab(logic: logic);
    }
  }
}
