import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';
import '../../../field_worker/calendar/model/calendar_event_model.dart';
import '../../../field_worker/calendar/widget/picker_field.dart';
import '../logic.dart';
import '../model/leave_model.dart';

class RequestLeaveView extends StatelessWidget {
  const RequestLeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<SuperInLeaveManagementLogic>();

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Request Leave',
        subtitle: 'Please fill out the details below',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            CustomDropdown(
              heading: 'Leave Type',
                items: LeaveType.values,
                value: logic.selectedType.value,
                onChanged: (t) {
                  if (t != null) logic.selectedType.value = t;
                },
                itemLabel: (t) => t.label,
            ),
            const SizedBox(height: 16),
            _StartDateField(logic: logic),
            const SizedBox(height: 16),
            _EndDateField(logic: logic),
            const SizedBox(height: 16),
            CustomTextField(
              heading: 'Reason/Notes',
              hintText: 'Enter any additional details...',
              controller: logic.reasonController,
              isFilled: true,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            Obx(()=> CustomButton(
              isLoading: logic.isSubmitting.value,
              text: 'Submit Request',
              onPressed: logic.isSubmitting.value ? null : logic.submit,
            )),
          ],
        ),
      ),
    );
  }
}

// ---- Date fields (your PickerFormField, same pattern as before) -----------

class _StartDateField extends StatelessWidget {
  final SuperInLeaveManagementLogic logic;
  const _StartDateField({required this.logic});

  @override
  Widget build(BuildContext context) => Obx(() => PickerFormField(
    label: 'Start Date',
    placeholder: 'Select start date',
    type: PickerFieldType.date,
    valueText: logic.startDate.value == null
        ? null
        : formatCompactDate(logic.startDate.value!),
    onTap: () => logic.pickStartDate(context),
  ));
}

class _EndDateField extends StatelessWidget {
  final SuperInLeaveManagementLogic logic;
  const _EndDateField({required this.logic});

  @override
  Widget build(BuildContext context) => Obx(() => PickerFormField(
    label: 'End Date',
    placeholder: 'Select end date',
    type: PickerFieldType.date,
    valueText: logic.endDate.value == null
        ? null
        : formatCompactDate(logic.endDate.value!),
    onTap: () => logic.pickEndDate(context),
  ));
}
