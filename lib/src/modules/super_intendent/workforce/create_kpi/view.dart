import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';
import '../../../../widgets/app_button.dart';
import '../models/kpi_model.dart';
import '../widgets/wf_common.dart';
import '../widgets/wf_palette.dart';
import 'logic.dart';

/// Create / Edit KPI Template. Pops the finished [KpiTemplate].
class CreateKpiView extends StatelessWidget {
  const CreateKpiView({super.key, this.existing});

  /// When set, the form is prefilled and saves as an edit.
  final KpiTemplate? existing;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateKpiLogic>(
      init: CreateKpiLogic(existing: existing),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: logic.isEditing ? 'Edit KPI Template' : 'Create KPI Template',
            showBackButton: true,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  logic.isEditing
                      ? 'Update this KPI metric.'
                      : 'Define a new KPI metric for your organization.',
                  style: const TextStyle(fontSize: 11, color: WfPalette.muted),
                ),
                const SizedBox(height: 14),
                WfSectionCard(
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        heading: 'Name *',
                        hintText: 'e.g., Jobs Completed Per Week',
                        controller: logic.nameController,
                        isFilled: true,
                        onChange: logic.onNameChanged,
                        validate: (v) {
                          logic.showNameError ? 'Name is required' : null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        heading: 'Description',
                        hintText: 'Describe what this KPI measures...',
                        controller: logic.descriptionController,
                        maxLines: 4,
                        isFilled: true,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomDropdown<KpiCategory>(
                              heading: 'Category',
                              value: logic.category,
                              items: KpiCategory.values,
                              itemLabel: (c) => c.label,
                              onChanged: logic.setCategory,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              heading: 'Unit',
                              hintText: 'count',
                              isFilled: true,
                              controller: logic.unitController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomDropdown<KpiDirection>(
                        heading: 'Direction',
                        value: logic.direction,
                        items: KpiDirection.values,
                        itemLabel: (d) => d.label,
                        onChanged: logic.setDirection,
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: logic.isEditing ? 'Save' : 'Create',
                        onPressed: logic.submit,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
