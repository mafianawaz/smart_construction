import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_color.dart';
import '../../../../widgets/app_textfield.dart';
import '../calendar_event/create_event_controller.dart';
import '../model/calendar_event_model.dart';

enum PickerFieldType {
  date,
  time,
}

class PickerFormField extends StatelessWidget {
  final String label;
  final String placeholder;
  final String? valueText;
  final PickerFieldType type;
  final VoidCallback onTap;

  const PickerFormField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.type,
    required this.onTap,
    this.valueText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      heading: label,
      isMuted: true,
      hintText: valueText ?? placeholder,
      readOnly: true,
      onClick: onTap,
      rightIcon: Icon(
        type == PickerFieldType.date
            ? Icons.calendar_today_outlined
            : Icons.access_time_outlined,
        size: 17,
        color: AppColors.textMuted,
      ),
      filledColor: AppColors.fieldFill,
      isFilled: true,
    );
  }
}

class StartDateField extends StatelessWidget {
  final CreateEventFormController logic;

  const StartDateField({
    super.key,
    required this.logic,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => PickerFormField(
        label: 'START DATE',
        placeholder: 'Pick a date',
        type: PickerFieldType.date,
        valueText:
        logic.startDate.value == null
            ? null
            : formatCompactDate(
          logic.startDate.value!,
        ),
        onTap: () => logic.pickStartDate(context),
      ),
    );
  }
}

class EndDateField extends StatelessWidget {
  final CreateEventFormController logic;

  const EndDateField({
    super.key,
    required this.logic,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => PickerFormField(
        label: 'END DATE (OPTIONAL)',
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
    );
  }
}

class StartTimeField extends StatelessWidget {
  final CreateEventFormController logic;

  const StartTimeField({
    super.key,
    required this.logic,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => PickerFormField(
        label: 'START TIME',
        placeholder: 'Pick a time',
        type: PickerFieldType.time,
        valueText:
        logic.startTime.value == null
            ? null
            : formatTimeOfDay(
          logic.startTime.value!,
        ),
        onTap: () =>
            logic.pickStartTime(context),
      ),
    );
  }
}

class EndTimeField extends StatelessWidget {
  final CreateEventFormController logic;

  const EndTimeField({
    super.key,
    required this.logic,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => PickerFormField(
        label: 'END TIME',
        placeholder: 'Pick a time',
        type: PickerFieldType.time,
        valueText:
        logic.endTime.value == null
            ? null
            : formatTimeOfDay(
          logic.endTime.value!,
        ),
        onTap: () =>
            logic.pickEndTime(context),
      ),
    );
  }
}