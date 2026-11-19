import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/modules/estimator/bids/view.dart';
import 'package:smart_construction/src/modules/field_worker/bulletins/view.dart';
import 'package:smart_construction/src/modules/field_worker/calculator/view.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../../../utils/app_icons.dart';
import '../../estimator/marketplace/view.dart';
import '../../estimator/material_inventory/view.dart';
import '../../estimator/procurement/view.dart';
import '../../field_worker/account_settings/view.dart';
import '../../field_worker/calendar/view.dart';
import '../../field_worker/more_menu/model/model.dart';
import '../../field_worker/more_menu/widget/tile_widget.dart';
import '../../super_intendent/daily_tm_sheet/view.dart';
import '../../super_intendent/dispatch_board/view.dart';
import '../../super_intendent/equipment_tools/view.dart';
import '../../super_intendent/leave_management/view.dart';
import '../../super_intendent/permits_licenses/view.dart';
import '../../super_intendent/production_rates/view.dart';
import '../../super_intendent/reports/view.dart';
import '../../super_intendent/safety_compliance/view.dart';
import '../../super_intendent/time_clock_management/view.dart';
import '../cfo_dashboard/view.dart';
import '../crm/view.dart';
import '../portfolio_rollup/view.dart';


class ManagerMoreScreen extends StatelessWidget {
  const ManagerMoreScreen({super.key});

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
                      id: 'time_clock',
                      label: 'Time Clock Management',
                      icon: AppIcons.progress,
                      iconBackgroundColor: Colors.orange,
                      onTap: (){
                        Get.to(() => const TimeClockManagementView());
                      },
                    ),
                    MoreMenuItem(
                      id: 'daily_tm',
                      label: 'Daily T&M Sheet',
                      icon: AppIcons.tool,
                      iconBackgroundColor: Colors.amber,
                      onTap: (){
                        Get.to(() => const DailyTmSheetView());
                      },
                    ),
                    MoreMenuItem(
                      id: 'portfolio_rollup',
                      label: 'Portfolio Rollup',
                      icon: AppIcons.portfolioRollUp,
                      iconBackgroundColor: Colors.blueGrey,
                      onTap: (){
                        Get.to(() => const PortfolioRollupView());
                      },
                    ),
                    MoreMenuItem(
                      id: 'sales',
                      label: 'Sales',
                      icon: AppIcons.sales,
                      iconBackgroundColor: AppColors.primaryOrangeDark,
                      type: MoreMenuItemType.expandable,
                      children: [
                        MoreMenuItem(
                         id: 'crm',
                         label: 'CRM',
                          onTap: (){
                            Get.to(() => const CrmView());
                          },
                        ),
                        MoreMenuItem(
                          id: 'bids',
                          label: 'Bids',
                          onTap: (){
                            Get.to(() => const EstimatorBidView());
                          },
                        ),
                        MoreMenuItem(
                          id: 'marketplace',
                          label: 'Marketplace',
                          onTap: (){
                            Get.to(() => const MarketplaceView());
                          },
                        ),
                      ]
                    ),
                    MoreMenuItem(
                      id: 'leave_management',
                      label: 'Leave Management',
                      icon: AppIcons.email,
                      iconBackgroundColor: Colors.pink,
                      onTap: (){
                        Get.to(() => const SuperInLeaveManagementView());
                      },
                    ),
                    MoreMenuItem(
                      id: 'cfo_dashboard',
                      label: 'CFO Dashboard',
                      icon: AppIcons.target,
                      iconBackgroundColor: Colors.pink,
                      onTap: (){
                        Get.to(() => const CfoDashboardView());
                      },
                    ),
                    MoreMenuItem(
                      id: 'safety_compliance',
                      label: 'Safety & Compliance',
                      icon: AppIcons.safety,
                      iconBackgroundColor: Colors.green,
                      onTap: (){
                        Get.to(() => const SafetyComplianceView());
                      },
                    ),
                    MoreMenuItem(
                      id: 'dispatch_board',
                      label: 'Dispatch Board',
                      icon: AppIcons.target,
                      iconBackgroundColor: Colors.purple,
                      onTap: (){
                        Get.to(() => const DispatchBoardView());
                      },
                    ),
                    MoreMenuItem(
                      id: 'equipment_tools',
                      label: 'Equipment & Tools',
                      icon: AppIcons.tool,
                      iconBackgroundColor: Colors.amber,
                      onTap: (){
                        Get.to(() => EquipmentListView());
                      },
                    ),
                    MoreMenuItem(
                      id: 'materials_inventory',
                      label: 'Materials Inventory',
                      icon: AppIcons.tool,
                      iconBackgroundColor: AppColors.primaryOrangeDark,
                      onTap: (){
                        Get.to(() => const MaterialInventoryView());
                      },
                    ),
                    MoreMenuItem(
                      id: 'calendar',
                      label: 'Calendar',
                      icon: AppIcons.calendar,
                      iconBackgroundColor: Colors.purple,
                      onTap: (){
                        Get.to(() =>  CalendarScreen());
                      },
                    ),
                    MoreMenuItem(
                      id: 'procurement',
                      label: 'Procurement',
                      icon: AppIcons.task,
                      iconBackgroundColor: Colors.pink,
                      onTap: (){
                        Get.to(() => ProcurementView());
                      },
                    ),
                    MoreMenuItem(
                      id: 'permit_licence',
                      label: 'Permits & Licence',
                      icon: AppIcons.docs,
                      iconBackgroundColor: Colors.indigo,
                      onTap: (){
                        Get.to(() => PermitsView());
                      },
                    ),
                    MoreMenuItem(
                      id: 'bulletin',
                      label: 'Bulletin',
                      icon: AppIcons.bulletin,
                      iconBackgroundColor: Colors.blue,
                      onTap: (){
                        Get.to(() => BulletinView());
                      },
                    ),
                    MoreMenuItem(
                      id: 'reports',
                      label: 'Reports',
                      icon: AppIcons.docs,
                      iconBackgroundColor: Colors.tealAccent,
                      onTap: (){
                        Get.to(() => SuperInReportsView());
                      },
                    ),
                    MoreMenuItem(
                      id: 'production_rates',
                      label: 'Production Rates',
                      icon: AppIcons.task,
                      iconBackgroundColor: AppColors.accentPeach,
                      onTap: (){
                        Get.to(() => const CompanySettingsView());
                      },
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