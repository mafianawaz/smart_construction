import 'package:get/get.dart';

class HomeLogic extends GetxController{

  // Tabs
  int selectedTab = 0;
  void changeTab(int index) {
    selectedTab = index;
    update();
  }

  // Toggle Tabs
  final selectedIndex = 0.obs;
  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  // Toggle Switch
  var isAvailable = true.obs;
}