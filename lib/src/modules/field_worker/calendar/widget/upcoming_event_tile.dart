import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_color.dart';
import '../../../../widgets/app_empty_filter.dart';
import '../calendar_event/logic.dart';
import '../model/calendar_event_model.dart';

class UpcomingEventsSection extends StatelessWidget {
  final CalendarEventLogic logic;

  const UpcomingEventsSection({
    super.key,
    required this.logic,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final date = logic.selectedDate.value;

      final dayEvents =
      logic.eventsForDate(date);

      return Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),

              Text(
                formatFullDate(date),
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.fieldBorder,
              ),
            ),
            child: dayEvents.isEmpty
                ? const AppEmptyState(
              icon:
              Icons.event_note_outlined,
              title: 'No events scheduled',
              message:
              'There are no events for this date',
              showButton: false,
            )
                : Column(
              children: [
                for (
                int i = 0;
                i < dayEvents.length;
                i++
                ) ...[
                  UpcomingEventTile(
                    event: dayEvents[i],
                  ),

                  if (i !=
                      dayEvents.length - 1)
                    const Divider(
                      height: 1,
                      color:
                      Color(0xFFF1F1F4),
                    ),
                ],
              ],
            ),
          ),
        ],
      );
    });
  }
}

class UpcomingEventTile extends StatelessWidget {
  final CalendarEvent event;
  final VoidCallback? onTap;

  const UpcomingEventTile({super.key, required this.event, this.onTap});

  String get _timeLabel {
    if (event.isAllDay) return 'All day';
    final start = event.startTime;
    final end = event.endTime;
    if (start == null) return '';
    final startLabel = formatTimeOfDay(start);
    return end == null ? startLabel : '$startLabel - ${formatTimeOfDay(end)}';
  }

  @override
  Widget build(BuildContext context) {
    final color = event.type.color;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(event.type.icon, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF232D42),
                    ),
                  ),
                  if (event.description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      event.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF8B8D97),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _timeLabel,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B6B70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
