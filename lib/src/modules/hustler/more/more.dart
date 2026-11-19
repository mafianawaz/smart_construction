import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/modules/field_worker/calculator/view.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../../../utils/app_icons.dart';
import '../../ai_agents/ai_agent_hub/view.dart';
import '../../ai_agents/ai_review_queue/view.dart';
import '../../ai_agents/daily_digest/view.dart';
import '../../field_worker/account_settings/view.dart';
import '../../field_worker/more_menu/model/model.dart';
import '../../field_worker/more_menu/widget/tile_widget.dart';
import '../../manager/cfo_dashboard/view.dart';
import '../../super_intendent/reports/view.dart';
import '../cfo_bulletins/view.dart';
import '../executive_digest/view.dart';
import '../portfolio_report/view.dart';


class HustlerMoreScreen extends StatelessWidget {
  const HustlerMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MoreMenuList(
                  items: [
                    MoreMenuItem(
                      id: 'home',
                      label: 'Home',
                      icon: AppIcons.home,
                      iconBackgroundColor: AppColors.primaryOrangeDark,
                      type: MoreMenuItemType.expandable,
                      children: [
                        MoreMenuItem(
                         id: 'executive_digest',
                         label: 'Executive Digest',
                          onTap: (){
                            Get.to(() => const ExecutiveDigestView());
                          },
                        ),
                        MoreMenuItem(
                          id: 'bulletins',
                          label: 'Bulletins',
                          onTap: (){
                            Get.to(() => const CfoBulletinsView());
                          },
                        ),
                      ]
                    ),
                    MoreMenuItem(
                      id: 'finance',
                      label: 'Finance',
                      icon: AppIcons.dollar,
                      iconBackgroundColor: Colors.pink,
                      type: MoreMenuItemType.expandable,
                      children: [
                        MoreMenuItem(
                          id: 'cfo_dashboard',
                          label: 'CFO Dashboard',
                          onTap: (){
                            Get.to(() => const CfoDashboardView());
                          },
                        ),
                      ]
                    ),
                    MoreMenuItem(
                      id: 'reports',
                      label: 'Reports',
                      icon: AppIcons.bars,
                      iconBackgroundColor: Colors.lightGreenAccent,
                      type: MoreMenuItemType.expandable,
                      children: [
                        MoreMenuItem(
                          id: 'portfolio_reports',
                          label: 'Portfolio Reports',
                          onTap: (){
                            Get.to(() => const PortfolioReportView());
                          },
                        ),
                      ]
                    ),
                    MoreMenuItem(
                      id: 'calculator',
                      label: 'Calculator',
                      icon: AppIcons.calculator,
                      iconBackgroundColor: Colors.green,
                      onTap: (){
                        Get.to(() => CalculatorView());
                      },
                    ),
                    MoreMenuItem(
                      id: 'account_settings',
                      label: 'Account Settings',
                      icon: AppIcons.settings,
                      iconBackgroundColor: Colors.blueGrey,
                      onTap: () {
                        Get.to(() => const AccountSettingsView());
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                MoreMenuList(
                  items: [
                    MoreMenuItem(
                      id: 'ai_agents',
                      label: 'AI Agents',
                      icon: AppIcons.ai,
                      iconBackgroundColor: Colors.red.shade600,
                      type: MoreMenuItemType.expandable,
                      children:[
                        MoreMenuItem(
                          id: 'ai_agents_hub',
                          label: 'AI Agents Hub',
                          onTap: () {
                            Get.to(() => const AiAgentsHubView());
                          },
                        ),
                        MoreMenuItem(
                          id: 'daily_digest',
                          label: 'Daily Digest',
                          onTap: () {
                            Get.to(() => const DailyDigestView());
                          },
                        ),
                        MoreMenuItem(
                          id: 'ai_review_queue',
                          label: 'AI Review Queue',
                          onTap: () {
                            Get.to(() => const AiReviewQueueView());
                          },
                        ),
                      ]
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
      ),
    );
  }
}