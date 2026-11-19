import 'package:get/get.dart';

class MyWorkLogic extends GetxController{

  // Toggle Tabs
  final selectedIndex = 0.obs;
  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}