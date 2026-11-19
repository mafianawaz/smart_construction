import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/modules/field_worker/account_settings/view.dart';
import '../../../utils/app_icons.dart';
import '../../field_worker/calculator/view.dart';
import '../../field_worker/more_menu/model/model.dart';
import '../../field_worker/more_menu/widget/tile_widget.dart';
import '../bid_network/view.dart';
import '../cost_book/view.dart';
import '../crew_templates/view.dart';
import '../equipment_tools/view.dart';
import '../historical_cost/view.dart';
import '../labor_cost_rates/view.dart';
import '../marketplace/view.dart';
import '../material_inventory/view.dart';
import '../procurement/view.dart';
import '../production_settings/view.dart';


class EstimatorMoreScreen extends StatelessWidget {
  const EstimatorMoreScreen({super.key});

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
                      id: 'estimating',
                      label: 'Estimating',
                      icon: AppIcons.docs,
                      iconBackgroundColor: Colors.orange,
                      type: MoreMenuItemType.expandable,
                      children: [
                        MoreMenuItem(
                          id: 'historical_cost',
                          label: 'Historical Coast',
                          onTap: () {
                            Get.to(() => const HistoricalCostView());
                          },
                        ),
                        MoreMenuItem(
                          id: 'bid_network',
                          label: 'Bid Network',
                          onTap: () {
                            Get.to(() => const BidNetworkView());
                          },
                        ),
                        MoreMenuItem(
                          id: 'marketplace',
                          label: 'Marketplace',
                          onTap: () {
                            Get.to(() => const MarketplaceView());
                          },
                        ),
                      ],
                    ),
                    MoreMenuItem(
                      id: 'reference',
                      label: 'Reference',
                      icon: AppIcons.template,
                      iconBackgroundColor: Colors.purple,
                      type: MoreMenuItemType.expandable,
                      children: [
                        MoreMenuItem(
                          id: 'cost_rate',
                          label: 'Cost Rate',
                          onTap: () {
                            Get.to(() => const LaborCostRatesView());
                          }
                        ),
                        MoreMenuItem(
                            id: 'cost_book',
                            label: 'Cost Book',
                            onTap: () {
                              Get.to(() => const CostBookView());
                            }
                        ),
                        MoreMenuItem(
                            id: 'crew_templates',
                            label: 'Crew Templates',
                            onTap: () {
                              Get.to(() => const CrewTemplatesView());
                            }
                        ),
                        MoreMenuItem(
                            id: 'production_rate',
                            label: 'Production Rate',
                            onTap: () {
                              Get.to(() => const ProductionSettingsView());
                            }
                        ),
                      ],
                    ),
                    MoreMenuItem(
                      id: 'field_ops',
                      label: 'field Ops',
                      icon: AppIcons.calculator,
                      iconBackgroundColor: Colors.teal,
                      type: MoreMenuItemType.expandable,
                      children: [
                        MoreMenuItem(
                            id: 'equipment',
                            label: 'Equipment',
                            onTap: () {
                              Get.to(() => const EquipmentView());
                            }
                        ),
                        MoreMenuItem(
                            id: 'inventory',
                            label: 'Inventory',
                            onTap: () {
                              Get.to(() => const MaterialInventoryView());
                            }
                        ),
                        MoreMenuItem(
                            id: 'procurement',
                            label: 'Procurement',
                            onTap: () {
                              Get.to(() => const ProcurementView());
                            }
                        ),
                      ],
                    ),
                    MoreMenuItem(
                      id: 'tools',
                      label: 'Tools',
                      icon: AppIcons.calculator,
                      iconBackgroundColor: Colors.yellow,
                      type: MoreMenuItemType.expandable,
                      children: [
                        MoreMenuItem(
                            id: 'calculator',
                            label: 'Calculator',
                            onTap: () {
                              Get.to(() => const CalculatorView());
                            }
                        ),
                      ]
                    ),
                    MoreMenuItem(
                      id: 'account_settings',
                      label: 'Account Settings',
                      icon: AppIcons.calculator,
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