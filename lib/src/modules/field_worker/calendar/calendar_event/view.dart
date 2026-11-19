import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import '../../../../widgets/app_textfield.dart';
import '../widget/all_day_widget.dart';
import '../widget/event_dropdown.dart';
import '../widget/picker_field.dart';
import 'create_event_controller.dart';

class CreateEventScreen extends StatelessWidget {
  final DateTime? initialDate;

  CreateEventScreen({super.key, this.initialDate});

  final logic = Get.put(CreateEventFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Calendar',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: logic.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EventTypeDropdown(controller: logic),
                      const SizedBox(height: 18),
                      CustomTextField(
                        heading: 'TITLE',
                        hintText: 'Team standup, project review..',
                        controller: logic.titleController,
                        validate: logic.validateTitle,
                        isMuted: true,
                      ),
                      const SizedBox(height: 18),
                      CustomTextField(
                        heading: 'DESCRIPTION (OPTIONAL)',
                        hintText: 'Additional detail...',
                        controller: logic.descriptionController,
                        maxLines: 4,
                        isMuted: true,
                      ),
                      const SizedBox(height: 16),
                      Obx(() => AllDayToggle(
                          value: logic.isAllDay.value,
                          onChanged: logic.toggleAllDay,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: StartDateField(logic: logic)),
                          const SizedBox(width: 12),
                          Expanded(child: EndDateField(logic: logic)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Obx(() {
                        if (logic.isAllDay.value) {
                          return const SizedBox.shrink();
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: StartTimeField(logic: logic)),
                            const SizedBox(width: 12),
                            Expanded(child: EndTimeField(logic: logic)),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Obx(() => CustomButton(
                text: 'Create Event',
                onPressed: logic.submit,
                isLoading: logic.isSubmitting.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
