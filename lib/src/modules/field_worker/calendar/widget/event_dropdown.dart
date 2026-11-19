import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/custom_dropdown_button.dart';
import '../calendar_event/create_event_controller.dart';
import '../model/calendar_event_model.dart';

class EventTypeDropdown extends StatelessWidget {
  final CreateEventFormController controller;

  const EventTypeDropdown({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => CustomDropdown<CalendarEventType>(
        heading: 'EVENT TYPE',
        hintText: 'Select event type',
        items: CalendarEventType.values,
        value: controller.eventType.value,
        isMuted: true,
        onChanged: (value) {
          if (value != null) {
            controller.setEventType(value);
          }
        },
        itemLabel: (type) => type.label,
      ),
    );
  }
}