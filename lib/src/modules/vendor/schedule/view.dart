import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/app_empty_filter.dart';
import '../../../widgets/stat_card_row.dart';
import 'logic.dart';
import 'schedule_details/view.dart';
import 'widgets/schedule_event_card.dart';


/// "Schedule" — Upcoming/In Progress/Complete stat row plus the Scheduled
/// Events list. Matches reference Section 13, frames 1 & 2.
class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(ScheduleLogic(), tag: 'schedule');

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Schedule',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Obx(() => Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('View your upcoming milestones, scheduled work dates, and '
                  'project milestones for contractors.',style: TextStyle(fontSize: 12,color: AppColors.textMuted),),
              SizedBox(height: 15,),
              StatCardRow(
                items: [
                  StatCardItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Upcoming',
                    value: '${logic.upcomingCount}',
                  ),
                  StatCardItem(
                    icon: Icons.autorenew,
                    label: 'In Progress',
                    value: '${logic.inProgressCount}',
                  ),
                  StatCardItem(
                    icon: Icons.check_circle_outline,
                    label: 'Complete',
                    value: '${logic.completedCount}',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Scheduled Events',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              Text(
                'Delivery windows, work dates, and project milestones '
                'assigned to you.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 15),
              if (!logic.hasEvents)
                const AppEmptyState(
                  icon: Icons.event_busy_outlined,
                  title: 'No schedule events yet',
                  message:
                      'Once your contractor schedules deliveries or work '
                      'windows, they will appear here.',
                  showButton: false,
                )
              else
                ...logic.events.map(
                  (e) => ScheduleEventCard(
                    event: e,
                    onTap: () => Get.to(() => ScheduleEventDetailsView(event: e)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
