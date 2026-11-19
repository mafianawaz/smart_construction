import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/custom_tabbar.dart';
import 'data/account_settings_data.dart';
import 'logic.dart';
import 'models/account_settings_models.dart';
import 'widgets/alerts_tab.dart';
import 'widgets/privacy_tab.dart';
import 'widgets/profile_tab.dart';
import 'widgets/security_tab.dart';
import 'widgets/skills_tab.dart';


class AccountSettingsView extends StatelessWidget {
  const AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AccountSettingsLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Account settings',
            showBackButton: true,
            centerTitle: true,
          ),
          body: Column(
            children: [
              CustomTabBar(
                tabs: AccountSettingsData.topTabs,
                selectedIndex: AccountSettingsTab.values.indexOf(logic.selectedTab),
                onChanged: (i) => logic.changeTab(AccountSettingsTab.values[i]),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15.0),
                  child: _buildTabContent(logic),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabContent(AccountSettingsLogic logic) {
    switch (logic.selectedTab) {
      case AccountSettingsTab.profile:
        return ProfileTab(logic: logic);
      case AccountSettingsTab.security:
        return SecurityTab(logic: logic);
      case AccountSettingsTab.alerts:
        return AlertsTab(logic: logic);
      case AccountSettingsTab.skills:
        return SkillsTab(logic: logic);
      case AccountSettingsTab.privacy:
        return PrivacyTab(logic: logic);
    }
  }
}
