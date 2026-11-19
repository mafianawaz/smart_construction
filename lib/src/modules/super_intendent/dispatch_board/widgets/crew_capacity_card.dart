import 'package:flutter/material.dart';
import '../data/dispatch_format.dart';
import 'dispatch_palette.dart';

/// One day chip inside a crew's capacity card.
class CapacityDayData {
  final DateTime date;
  final bool booked;
  final bool isToday;
  final VoidCallback onTap;

  const CapacityDayData({
    required this.date,
    required this.booked,
    required this.isToday,
    required this.onTap,
  });
}

/// Crew capacity card: name, "n/5 days", progress bar, Mon-Fri chips.
/// Layout is my own design (the reference has no Crew Capacity screen).
class CrewCapacityCard extends StatelessWidget {
  final String crewName;
  final Color color;
  final int booked;
  final List<CapacityDayData> days;

  const CrewCapacityCard({
    super.key,
    required this.crewName,
    required this.color,
    required this.booked,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    final total = days.length;
    final fraction = total == 0 ? 0.0 : booked / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: DispatchPalette.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  crewName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: DispatchPalette.textDark,
                  ),
                ),
              ),
              Text(
                '$booked/$total days',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: DispatchPalette.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(height: 6, color: DispatchPalette.surfaceMuted),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: fraction,
                  child: Container(height: 6, color: color),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < days.length; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(child: _DayChip(data: days[i], color: color)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  final CapacityDayData data;
  final Color color;

  const _DayChip({required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    final booked = data.booked;
    return GestureDetector(
      onTap: data.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: booked ? color.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: booked ? color : DispatchPalette.border,
            width: data.isToday ? 1.6 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DispatchFormat.weekdayShort(data.date),
              style: const TextStyle(
                fontSize: 10,
                color: DispatchPalette.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${data.date.day}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: DispatchPalette.textDark,
              ),
            ),
            const SizedBox(height: 4),
            booked
                ? Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  )
                : const Icon(Icons.add, size: 12, color: DispatchPalette.textFaint),
          ],
        ),
      ),
    );
  }
}
