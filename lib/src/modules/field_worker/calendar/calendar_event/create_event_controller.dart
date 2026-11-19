import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/calendar_event_model.dart';

class CreateEventFormController extends GetxController {
  CreateEventFormController({
    DateTime? initialDate,
  }) {
    startDate.value = initialDate;
  }

  final formKey = GlobalKey<FormState>();

  final titleController =
  TextEditingController();

  final descriptionController =
  TextEditingController();

  final Rx<CalendarEventType> eventType =
      CalendarEventType.meeting.obs;

  final RxBool isAllDay = false.obs;

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);

  final Rx<DateTime?> endDate =
  Rx<DateTime?>(null);

  final Rx<TimeOfDay?> startTime =
  Rx<TimeOfDay?>(
    const TimeOfDay(
      hour: 9,
      minute: 0,
    ),
  );

  final Rx<TimeOfDay?> endTime =
  Rx<TimeOfDay?>(
    const TimeOfDay(
      hour: 17,
      minute: 0,
    ),
  );

  final RxBool isSubmitting = false.obs;

  void setEventType(CalendarEventType type) {
    eventType.value = type;
  }

  void toggleAllDay(bool value) {
    isAllDay.value = value;
  }

  void setStartDate(DateTime date) {
    startDate.value = date;

    // If an end date exists and becomes invalid,
    // clear it.
    final end = endDate.value;

    if (end != null && end.isBefore(date)) {
      endDate.value = null;
    }
  }

  void setEndDate(DateTime? date) {
    endDate.value = date;
  }

  void setStartTime(TimeOfDay time) {
    startTime.value = time;
  }

  void setEndTime(TimeOfDay time) {
    endTime.value = time;
  }

  String? validateTitle(String? value) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Title is required';
    }

    return null;
  }

  Future<void> pickStartDate(
      BuildContext context,
      ) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate:
      startDate.value ?? now,
      firstDate: DateTime(
        now.year - 1,
      ),
      lastDate: DateTime(
        now.year + 5,
      ),
    );

    if (picked == null) return;

    setStartDate(picked);
  }

  Future<void> pickEndDate(
      BuildContext context,
      ) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate:
      endDate.value ??
          startDate.value ??
          now,
      firstDate:
      startDate.value ??
          DateTime(now.year - 1),
      lastDate: DateTime(
        now.year + 5,
      ),
    );

    if (picked == null) return;

    setEndDate(picked);
  }

  Future<void> pickStartTime(
      BuildContext context,
      ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
      startTime.value ??
          TimeOfDay.now(),
    );

    if (picked == null) return;

    setStartTime(picked);
  }

  Future<void> pickEndTime(
      BuildContext context,
      ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
      endTime.value ??
          TimeOfDay.now(),
    );

    if (picked == null) return;

    setEndTime(picked);
  }

  CalendarEvent? buildEvent() {
    final valid =
        formKey.currentState?.validate() ??
            false;

    if (!valid) return null;

    if (startDate.value == null) {
      Get.snackbar(
        'Required',
        'Please select a start date',
      );

      return null;
    }

    final start = startDate.value!;
    final end = endDate.value;

    if (end != null && end.isBefore(start)) {
      Get.snackbar(
        'Invalid date',
        'End date cannot be before start date',
      );

      return null;
    }

    return CalendarEvent(
      id:
      'evt_${DateTime.now().microsecondsSinceEpoch}',
      type: eventType.value,
      title:
      titleController.text.trim(),
      description:
      descriptionController.text
          .trim()
          .isEmpty
          ? null
          : descriptionController.text
          .trim(),
      isAllDay: isAllDay.value,
      startDate: start,
      endDate: end,
      startTime:
      isAllDay.value
          ? null
          : startTime.value,
      endTime:
      isAllDay.value
          ? null
          : endTime.value,
    );
  }

  Future<void> submit() async {
    if (isSubmitting.value) return;

    final event = buildEvent();

    if (event == null) return;

    try {
      isSubmitting.value = true;

      // Future API call goes here.
      //
      // await repository.createEvent(event);

      await Future.delayed(
        const Duration(milliseconds: 200),
      );

      Get.back<CalendarEvent>(
        result: event,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();

    super.onClose();
  }
}