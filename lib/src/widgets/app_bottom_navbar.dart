import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import '../modules/estimator/bids/view.dart';
import '../modules/estimator/home/view.dart';
import '../modules/estimator/more/view.dart';
import '../modules/estimator/projects/view.dart';
import '../modules/field_worker/home/view.dart';
import '../modules/field_worker/messages/view.dart';
import '../modules/field_worker/messages/widget/messages_mock_data.dart';
import '../modules/field_worker/more_menu/view.dart';
import '../modules/field_worker/my_task/view.dart';
import '../modules/field_worker/my_work/view.dart';
import '../modules/hustler/cfo_organization/view.dart';
import '../modules/hustler/home/view.dart';
import '../modules/hustler/more/more.dart';
import '../modules/manager/home/view.dart';
import '../modules/manager/more/more.dart';
import '../modules/super_intendent/home/view.dart';
import '../modules/super_intendent/more/more.dart';
import '../modules/super_intendent/workforce/view.dart';
import '../modules/vendor/bids/view.dart';
import '../modules/vendor/home/view.dart';
import '../modules/vendor/more/view.dart';
import '../modules/vendor/pricing/view.dart';
import '../services/session/session.dart';
import '../utils/app_color.dart';

class NavController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}

class RoleNavConfig {
  final List<Widget> pages;
  final List<String> icons;
  final List<String> labels;
  const RoleNavConfig({required this.pages, required this.icons, required this.labels});
}

class FieldWorkerNav {
  static RoleNavConfig get config => RoleNavConfig(
    pages: [
      HomeView(),
      MyWorkView(),
      TaskListView(),
      MessagesScreen(
        config: MessagesMockData.forRole(MockSession.currentRole),
        tag: 'messages_${MockSession.currentRole.name}',
      ),
      MoreScreen(),
    ],
    icons: [AppIcons.myDay, AppIcons.myWork, AppIcons.task, AppIcons.messages, AppIcons.more],
    labels: const ["My Day", "My Work", "My Task", "Messages", "More"],
  );
}

/// Placeholder for any role that doesn't have real screens yet, so
/// switching MockSession.currentRole during testing never crashes.
/// Delete a role's entry from this and point it at its own *Nav.config
/// class the day that role's screens are built — nothing else changes.
class VendorNav {
  static RoleNavConfig get config => RoleNavConfig(
    pages: [
      VendorHomeView(),
      BidsView(),
      PricingView(),
      MessagesScreen(
        config: MessagesMockData.forRole(MockSession.currentRole),
        tag: 'messages_${MockSession.currentRole.name}',
      ),
      VendorMoreScreen(),
    ],
    icons: [AppIcons.task, AppIcons.bids, AppIcons.pricing, AppIcons.messages, AppIcons.more],
    labels: const ["Home", "Bids", "Pricing", "Messages", "More"],
  );
}

class EstimatorNav {
  static RoleNavConfig get config => RoleNavConfig(
    pages: [
      EstimatorHomeView(),
      EstimatorBidView(),
      ProjectsView(),
      MessagesScreen(
        config: MessagesMockData.forRole(MockSession.currentRole),
        tag: 'messages_${MockSession.currentRole.name}',
      ),
      EstimatorMoreScreen(),
    ],
    icons: [AppIcons.task, AppIcons.bids, AppIcons.projects, AppIcons.messages, AppIcons.more],
    labels: const ["Home", "Bids", "Projects", "Messages", "More"],
  );
}

class SuperIntendentNav {
  static RoleNavConfig get config => RoleNavConfig(
    pages: [
      SuperHomeView(),
      WorkforceView(),
      ProjectsView(),
      MessagesScreen(
        config: MessagesMockData.forRole(MockSession.currentRole),
        tag: 'messages_${MockSession.currentRole.name}',
      ),
      SuperInMoreScreen(),
    ],
    icons: [AppIcons.task, AppIcons.workforce, AppIcons.projects, AppIcons.messages, AppIcons.more],
    labels: const ["Home", "Workforce", "Projects", "Messages", "More"],
  );
}

class ManagerNav {
  static RoleNavConfig get config => RoleNavConfig(
    pages: [
      ManagerHomeView(),
      WorkforceView(),
      ProjectsView(),
      MessagesScreen(
        config: MessagesMockData.forRole(MockSession.currentRole),
        tag: 'messages_${MockSession.currentRole.name}',
      ),
      ManagerMoreScreen(),
    ],
    icons: [AppIcons.task, AppIcons.workforce, AppIcons.projects, AppIcons.messages, AppIcons.more],
    labels: const ["Home", "Workforce", "Projects", "Messages", "More"],
  );
}

class HustlerNav {
  static RoleNavConfig get config => RoleNavConfig(
    pages: [
      HustlerHomeView(),
      CfoMyOrganizationView(),
      MessagesScreen(
        config: MessagesMockData.forRole(MockSession.currentRole),
        tag: 'messages_${MockSession.currentRole.name}',
      ),
      HustlerMoreScreen(),
    ],
    icons: [AppIcons.task, AppIcons.cfo, AppIcons.messages, AppIcons.more],
    labels: const ["Home", "CFO", "Messages", "More"],
  );
}


/// Single lookup point: role -> bottom nav config. This is the only
/// place that needs an entry added when a new role's screens land.
final Map<UserRole, RoleNavConfig> roleNavRegistry = {
  UserRole.fieldWorker: FieldWorkerNav.config,
  UserRole.vendor: VendorNav.config,
  UserRole.estimator: EstimatorNav.config,
  UserRole.superIntendent: SuperIntendentNav.config,
  UserRole.manager: ManagerNav.config,
  UserRole.hustler: HustlerNav.config,
};

// Main Bottom Nav View
class CustomBottomNavBarView extends StatelessWidget {
  final RoleNavConfig config;

  CustomBottomNavBarView({super.key, RoleNavConfig? config})
      : config = config ?? roleNavRegistry[MockSession.currentRole]!;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavController());

    return Scaffold(
      body: Obx(() => config.pages[controller.selectedIndex.value]),
      bottomNavigationBar: CustomBottomNavBar(config: config),
    );
  }
}

// Custom Bottom Navigation Bar
class CustomBottomNavBar extends StatelessWidget {
  final RoleNavConfig config;
  const CustomBottomNavBar({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavController>();

    final icons = config.icons;
    final labels = config.labels;

    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Obx(() {
      return Container(
        padding: EdgeInsets.only(bottom: bottomPadding),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Row(
              children: List.generate(icons.length, (index) {
                final isSelected = controller.selectedIndex.value == index;
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 3,
                    color: isSelected ? AppColors.primaryOrange : Colors.transparent,
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(icons.length, (index) {
                  final isSelected = controller.selectedIndex.value == index;
                  return GestureDetector(
                    onTap: () => controller.changeTab(index),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          icons[index],
                          width: 20,
                          height: 20,
                          color: isSelected ? AppColors.primaryOrange : Colors.grey,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          labels[index],
                          style: TextStyle(
                            color: isSelected ? AppColors.primaryOrange : Colors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    });
  }
}