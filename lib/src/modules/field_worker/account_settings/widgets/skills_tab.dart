import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/custom_switch.dart';
import '../../../../utils/app_color.dart';
import '../../../../widgets/custom_tabbar.dart';
import '../../../../widgets/custom_toggle_switch.dart';
import '../data/account_settings_data.dart';
import '../logic.dart';
import '../models/account_settings_models.dart';
import 'certifications_sub_tab.dart';
import 'equipment_sub_tab.dart';
import 'skills_sub_tab.dart';


class SkillsTab extends StatelessWidget {
  const SkillsTab({super.key, required this.logic});

  final AccountSettingsLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills & Certifications',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage your skills, certifications, and equipment',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 16),
        CustomToggle(
         options: AccountSettingsData.skillsSubTabs,
         selectedIndex: SkillsSubTab.values.indexOf(logic.selectedSkillsSubTab),
         onChanged: (i) => logic.changeSkillsSubTab(SkillsSubTab.values[i]),
        ),
        const SizedBox(height: 20),
        _buildSubTab(),
      ],
    );
  }

  Widget _buildSubTab() {
    switch (logic.selectedSkillsSubTab) {
      case SkillsSubTab.skills:
        return SkillsSubTabView(logic: logic);
      case SkillsSubTab.certifications:
        return CertificationsSubTabView(logic: logic);
      case SkillsSubTab.equipment:
        return EquipmentSubTabView(logic: logic);
    }
  }
}
