import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';

import '../../models/project_enums.dart';
import '../widgets/detail_card.dart';
import 'add_risk_logic.dart';
import 'widgets/risk_score_badge.dart';

const _gap = SizedBox(height: 12);

/// "Add New Risk" — pushed as its own screen from the Risks tab's "+
/// Add Risk" button (the reference shows no tab bar behind it, so this
/// is a separate route, not inline tab content).
class AddRiskView extends StatelessWidget {
  const AddRiskView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddRiskLogic>(
      init: AddRiskLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Risk Register',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
                    child: DetailCard(
                      title: 'Add New Risk',
                      children: [
                        CustomTextField(
                            heading: 'Title', hintText: 'Risk title', controller: logic.titleCtrl),
                        _gap,
                        CustomTextField(
                            heading: 'Description',
                            hintText: 'Describe the risk...',
                            controller: logic.descriptionCtrl,
                            maxLines: 3),
                        _gap,
                        Obx(() => _LabeledDropdown<RiskCategory>(
                              label: 'Category',
                              hint: 'Other',
                              value: logic.category.value,
                              options: RiskCategory.values,
                              labelOf: (c) => c.label,
                              onChanged: (v) => logic.category.value = v,
                            )),
                        _gap,
                        Obx(() => _LabeledDropdown<RiskStatus>(
                              label: 'Status',
                              hint: 'Other',
                              value: logic.status.value,
                              options: RiskStatus.values,
                              labelOf: (s) => s.label,
                              onChanged: (v) => logic.status.value = v,
                            )),
                        _gap,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Obx(() => _LabeledDropdown<int>(
                                    label: 'Probability(1-5)',
                                    hint: 'Select',
                                    value: logic.probability.value,
                                    options: const [1, 2, 3, 4, 5],
                                    labelOf: (v) => '$v - ${riskProbabilityScaleLabels[v - 1]}',
                                    onChanged: (v) => v == null ? null : logic.probability.value = v,
                                  )),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              flex: 4,
                              child: Obx(() => _LabeledDropdown<int>(
                                    label: 'Impact(1-5)',
                                    hint: 'Select',
                                    value: logic.impact.value,
                                    options: const [1, 2, 3, 4, 5],
                                    labelOf: (v) => '$v - ${riskRatingScaleLabels[v - 1]}',
                                    onChanged: (v) => v == null ? null : logic.impact.value = v,
                                  )),
                            ),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('Risk Score',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Obx(() => RiskScoreBadge(score: logic.score)),
                              ],
                            ),
                          ],
                        ),
                        _gap,
                        CustomTextField(
                            heading: 'Mitigation Plan',
                            hintText: 'How will this risk be mitigated?',
                            controller: logic.mitigationPlanCtrl,
                            maxLines: 3),
                        _gap,
                        Obx(() => _LabeledDropdown<String>(
                              label: 'Owner',
                              hint: 'Select owner',
                              value: logic.owner.value.isEmpty ? null : logic.owner.value,
                              options: riskOwnerOptions,
                              labelOf: (o) => o,
                              onChanged: (v) => logic.owner.value = v ?? '',
                            )),
                        _gap,
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                  heading: 'Cost Impact (\$)',
                                  hintText: '0.00',
                                  controller: logic.costImpactCtrl,
                                  keyboardType: TextInputType.number),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                  heading: 'Schedule Impact (days)',
                                  hintText: '0',
                                  controller: logic.scheduleImpactCtrl,
                                  keyboardType: TextInputType.number),
                            ),
                          ],
                        ),
                        _gap,
                        CustomTextField(
                            heading: 'Linked Cost Code',
                            hintText: 'e.g., 03-100',
                            controller: logic.linkedCostCodeCtrl),
                        _gap,
                        CustomTextField(
                            heading: 'Linked Milestone',
                            hintText: 'e.g., Foundation Complete',
                            controller: logic.linkedMilestoneCtrl),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Obx(() => CustomButton(
                        text: 'Create Risk',
                        onPressed: logic.isCreating.value
                            ? null
                            : () async {
                                final risk = await logic.createRisk();
                                if (risk != null) Get.back(result: risk);
                              },
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Dropdown styled to match `CustomTextField`'s label/box look — used
/// for every select field on this form since `CustomTextField` itself
/// is a text input, not a picker.
class _LabeledDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> options;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;

  const _LabeledDropdown({
    required this.label,
    required this.hint,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<T>(
      heading: label,
      fontSize: 10,
      value: value,
      hintText: hint,
      items: options,
      itemLabel: (item) => labelOf(item),
      onChanged: onChanged,
    );
  }
}
