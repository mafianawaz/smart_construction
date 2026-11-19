import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_icons.dart';
import '../../field_worker/account_settings/view.dart';
import '../../field_worker/more_menu/model/model.dart';
import '../../field_worker/more_menu/widget/tile_widget.dart';
import '../analytics/view.dart';
import '../compliance_document/view.dart';
import '../enrolled_clients/view.dart';
import '../purchase_orders/view.dart';
import '../schedule/view.dart';
import '../shared_documents/view.dart';

class VendorMoreScreen extends StatelessWidget {
  const VendorMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              MoreMenuList(
                items: [
                  MoreMenuItem(
                    id: 'clients',
                    label: 'Clients',
                    icon: AppIcons.personal,
                    iconBackgroundColor: AppColors.primaryOrange,
                    onTap: () {
                      Get.to(()=> EnrolledClientsView());
                    },
                  ),
                  MoreMenuItem(
                    id: 'purchase_orders',
                    label: 'Purchase Orders',
                    icon: AppIcons.calendar,
                    iconBackgroundColor: Colors.deepPurple,
                    onTap: () {
                      Get.to(()=> PurchaseOrdersView());
                    },
                  ),
                  MoreMenuItem(
                    id: 'schedule',
                    label: 'Schedule',
                    icon: AppIcons.calendar,
                    iconBackgroundColor: Colors.teal,
                    onTap: () {
                      Get.to(()=> ScheduleView());
                    },
                  ),
                  MoreMenuItem(
                    id: 'documents',
                    label: 'Documents',
                    icon: AppIcons.docs,
                    iconBackgroundColor: Colors.green,
                    onTap: () {
                      Get.to(()=> SharedDocumentsView());
                    },
                  ),
                  MoreMenuItem(
                    id: 'compliance',
                    label: 'Compliance',
                    icon: AppIcons.safety,
                    iconBackgroundColor: Colors.pink,
                    onTap: () {
                      Get.to(()=> ComplianceDocumentsView());
                    },
                  ),
                  MoreMenuItem(
                    id: 'analytics',
                    label: 'Analytics',
                    icon: AppIcons.analytics,
                    iconBackgroundColor: Colors.orange,
                    onTap: () {
                      Get.to(() => AnalyticsView());
                    },
                  ),
                  MoreMenuItem(
                    id: 'account_settings',
                    label: 'Account Settings',
                    icon: AppIcons.settings,
                    iconBackgroundColor: Colors.blueGrey,
                    onTap: () {
                      Get.to(()=> AccountSettingsView());
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