import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/app_calendar/view.dart';
import 'calendar_event/logic.dart';
import 'calendar_event/view.dart';
import 'model/calendar_event_model.dart';
import 'widget/upcoming_event_tile.dart';

class CalendarScreen extends StatelessWidget {
   CalendarScreen({super.key});

  final logic = Get.put(CalendarEventLogic());


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Calendar',
        showBackButton: true,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: InkResponse(
              onTap: logic.openCreateEvent,
              radius: 24,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage meetings, milestones, deadlines, and events',
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textMuted,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Obx(
                          () => AppCalendar(
                        variant: CalendarVariant.full,
                        selectedDate:
                        logic.selectedDate.value,
                        onDateSelected:
                        logic.selectDate,
                        onMonthChanged:
                        logic.loadEventsForMonth,
                        dayIndicatorsBuilder:
                        logic.colorsForDate,
                        showLegend: false,
                      ),
                    ),

                    const SizedBox(height: 20),

                    UpcomingEventsSection(
                      logic: logic,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}