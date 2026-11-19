import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../../../utils/app_icons.dart';
import '../account_settings/view.dart';
import '../bulletins/view.dart';
import '../calculator/view.dart';
import '../calendar/view.dart';
import '../leave_management/view.dart';
import '../safety_training/view.dart';
import '../time_tracking/view.dart';
import 'model/model.dart';
import 'widget/tile_widget.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              MoreMenuList(
                items: [
                  MoreMenuItem(
                    id: 'time_clock',
                    label: 'Manage Time Clock',
                    icon: AppIcons.clock,
                    iconBackgroundColor: AppColors.primaryOrange,
                    onTap: () {
                      Get.to(()=> TimeTrackingScreen());
                    },
                  ),
                  MoreMenuItem(
                    id: 'calendar',
                    label: 'Calendar',
                    icon: AppIcons.calendar,
                    iconBackgroundColor: Colors.deepPurple,
                    onTap: () {
                      Get.to(()=> CalendarScreen());
                    },
                  ),
                  // MoreMenuItem(
                  //   id: 'tasks',
                  //   label: 'Tasks',
                  //   icon: AppIcons.total,
                  //   iconBackgroundColor: Colors.teal,
                  //   onTap: () {},
                  // ),
                  MoreMenuItem(
                    id: 'safety_training',
                    label: 'Safety Training',
                    icon: AppIcons.safety,
                    iconBackgroundColor: Colors.green,
                    onTap: () {
                      Get.to(()=> SafetyTrainingView());
                    },
                  ),
                  MoreMenuItem(
                    id: 'leave_management',
                    label: 'Leave Management',
                    icon: AppIcons.email,
                    iconBackgroundColor: Colors.pink,
                    onTap: () {
                      Get.to(()=> LeaveManagementView());
                    },
                  ),
                  MoreMenuItem(
                    id: 'bulletins',
                    label: 'Bulletins',
                    icon: AppIcons.bulletin,
                    iconBackgroundColor: Colors.amber,
                    onTap: () {
                      Get.to(() => BulletinView());
                    },
                  ),
                  MoreMenuItem(
                    id: 'calculator',
                    label: 'Calculator',
                    icon: AppIcons.calculator,
                    iconBackgroundColor: Colors.blueGrey,
                    onTap: () {
                      Get.to(() => CalculatorView());
                    },
                  ),
                  MoreMenuItem(
                    id: 'account_settings',
                    label: 'Account Settings',
                    icon: AppIcons.settings,
                    iconBackgroundColor: Colors.blueGrey,
                    onTap: () {
                      Get.to(() => AccountSettingsView());
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
              MoreMenuList(
                items: [
                  MoreMenuItem(
                    id: 'logout',
                    label: 'Logout',
                    icon: AppIcons.logout,
                    iconBackgroundColor: Colors.red,
                    isDestructive: true,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}