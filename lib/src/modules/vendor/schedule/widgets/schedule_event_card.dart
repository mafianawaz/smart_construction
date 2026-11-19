import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import '../../../../utils/app_color.dart';
import '../models/schedule_event_model.dart';
import 'schedule_status_badge.dart';

/// One row in the Scheduled Events list.
class ScheduleEventCard extends StatelessWidget {
  final ScheduleEventModel event;
  final VoidCallback onTap;

  const ScheduleEventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: SvgPicture.asset(AppIcons.calendar, color: Colors.white, height: 16)),
                ),
                ScheduleStatusBadge(status: event.status),
              ],
            ),
            SizedBox(height: 15,),
            Text(
              event.title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.apartment_outlined, size: 13, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  '${event.contractorName} \u2022 ${event.projectLabel}',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  event.formattedDateRange,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
