import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/project_enums.dart';
import '../../models/risk_model.dart';

/// Owns the "Add New Risk" form. Short-lived — created when the form
/// opens, discarded when it closes (no `tag`, so a second Add Risk pass
/// always starts clean).
class AddRiskLogic extends GetxController {
  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final mitigationPlanCtrl = TextEditingController();
  final costImpactCtrl = TextEditingController();
  final scheduleImpactCtrl = TextEditingController();
  final linkedCostCodeCtrl = TextEditingController();
  final linkedMilestoneCtrl = TextEditingController();

  final Rx<RiskCategory?> category = Rx<RiskCategory?>(null);
  final Rx<RiskStatus?> status = Rx<RiskStatus?>(null);
  final RxInt probability = 3.obs;
  final RxInt impact = 3.obs;
  final RxString owner = ''.obs;

  final isCreating = false.obs;

  int get score => probability.value * impact.value;

  // API: POST /projects/{id}/risks
  Future<RiskModel?> createRisk() async {
    if (titleCtrl.text.trim().isEmpty) {
      Get.snackbar('Missing title', 'Give this risk a title first.');
      return null;
    }
    isCreating.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return RiskModel(
        id: 'risk_${DateTime.now().microsecondsSinceEpoch}',
        title: titleCtrl.text.trim(),
        description: descriptionCtrl.text.trim().isEmpty ? null : descriptionCtrl.text.trim(),
        category: category.value ?? RiskCategory.other,
        status: status.value ?? RiskStatus.open,
        probability: probability.value,
        impact: impact.value,
        mitigationPlan: mitigationPlanCtrl.text.trim().isEmpty ? null : mitigationPlanCtrl.text.trim(),
        owner: owner.value.isEmpty ? null : owner.value,
        costImpact: double.tryParse(costImpactCtrl.text.trim()),
        scheduleImpactDays: int.tryParse(scheduleImpactCtrl.text.trim()),
        linkedCostCode: linkedCostCodeCtrl.text.trim().isEmpty ? null : linkedCostCodeCtrl.text.trim(),
        linkedMilestone:
            linkedMilestoneCtrl.text.trim().isEmpty ? null : linkedMilestoneCtrl.text.trim(),
        createdAt: DateTime.now(),
      );
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in [
      titleCtrl,
      descriptionCtrl,
      mitigationPlanCtrl,
      costImpactCtrl,
      scheduleImpactCtrl,
      linkedCostCodeCtrl,
      linkedMilestoneCtrl,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
