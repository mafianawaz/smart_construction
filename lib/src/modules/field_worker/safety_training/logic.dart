import 'package:get/get.dart';

class SafetyTrainingLogic extends GetxController{

  final selectedIndex = 0.obs;
  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  // Toolbox Talks Toggle
  final selectedToolboxItem = 0.obs;
  void onChange(int index) {
    selectedToolboxItem.value = index;
  }

  // Checklist Toggle
  final selectedChecklistItem = 0.obs;
  void onChangeChecklist(int index) {
    selectedChecklistItem.value = index;
  }
}