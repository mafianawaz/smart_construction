import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_button.dart';

import '../../../../utils/app_color.dart';
import '../../../../widgets/app_textfield.dart';
import '../../../../widgets/custom_dropdown_button.dart';
import '../../calendar/model/calendar_event_model.dart';
import '../../calendar/widget/picker_field.dart';
import '../logic.dart';

class LeaveRequestForm extends StatelessWidget {
  final LeaveManagementLogic logic;

  const LeaveRequestForm({
    super.key,
    required this.logic,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Leave Request',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDropdown(
                  heading: 'LEAVE TYPE',
                  isMuted: true,
                  value: logic.selectedLeaveType.value,
                  hintText: 'Select leave type',
                  items: logic.leaveTypes,
                  onChanged: logic.selectLeaveType,
                  itemLabel: (item) => item,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Obx(() => PickerFormField(
                          label: 'START DATE',
                          placeholder: 'Pick a date',
                          type: PickerFieldType.date,
                          valueText:
                          logic.startDate.value == null
                              ? null
                              : formatCompactDate(
                            logic.startDate.value!,
                          ),
                          onTap: () =>
                              logic.pickStartDate(context),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Obx(() => PickerFormField(
                          label: 'END DATE',
                          placeholder: 'Pick a date',
                          type: PickerFieldType.date,
                          valueText:
                          logic.endDate.value == null
                              ? null
                              : formatCompactDate(
                            logic.endDate.value!,
                          ),
                          onTap: () =>
                              logic.pickEndDate(context),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  heading: 'REASON (OPTIONAL)',
                  controller: logic.reasonController,
                  hintText: 'Provide a reason for your leave request...',
                  maxLines: 4,
                  isFilled: true,
                  isMuted: true,
                  filledColor: AppColors.fieldFill,
                ),
                const SizedBox(height: 16),
                Obx(() {
                    if (logic.requestedDays <= 0) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius:
                        BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${logic.requestedDays} '
                            '${logic.requestedDays == 1 ? 'day' : 'days'} '
                            'requested',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                CustomButton(
                  text: 'Submit',
                  onPressed: logic.submitRequest,
                  isLoading: logic.isSubmitting,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}