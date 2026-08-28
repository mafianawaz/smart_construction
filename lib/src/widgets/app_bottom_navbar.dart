import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import '../modules/field_worker/home/view.dart';
import '../utils/app_color.dart';

class NavController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}

// Main Bottom Nav View
class CustomBottomNavBarView extends StatelessWidget {
  CustomBottomNavBarView({super.key});

  final List<Widget> pages = [
    HomeView(),
    Center(child: const Text('Page 2')),
    Center(child: const Text('Page 3')),
    Center(child: const Text('Page 4')),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavController());

    return Scaffold(
      extendBody: true, // optional if you want nav to float slightly
      body: Obx(() {
        // Dynamic bottom padding for safe area
        final bottomPadding = MediaQuery.of(context).padding.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: pages[controller.selectedIndex.value],
        );
      }),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

// Custom Bottom Navigation Bar
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavController>();

    final List<String> icons = [
      AppIcons.myDay,
      AppIcons.myWork,
      AppIcons.messages,
      AppIcons.more,
    ];
    final List<String> labels = [
      "My Day",
      "My Work",
      "Messages",
      "More",
    ];

    // Dynamic bottom padding for devices with gesture navigation
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
            SizedBox(height: 10,),
            // Indicator bar
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
            // Icon Row
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
                          color: isSelected ? AppColors.primaryOrange : AppColors.textMuted,
                        ),
                        SizedBox(height: 5),
                        Text(labels[index],
                          style: TextStyle(
                           color: isSelected ? AppColors.primaryOrange : AppColors.textMuted,
                              fontSize: 12, fontWeight: FontWeight.w600),)
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