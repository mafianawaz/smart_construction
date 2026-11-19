import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../logic.dart';
import '../models/dispatch_models.dart';
import '../widgets/crew_capacity_card.dart';
import '../widgets/dispatch_header.dart';
import '../widgets/dispatch_palette.dart';

/// Crew Capacity: booked days per crew for one Mon-Fri week, with a chip per
/// day that opens the Assign Crew sheet. The reference design has no screen
/// for this (only the "Crew Capacity" button), so the layout is my own.
///
/// Uses the `DispatchLogic` already registered by `DispatchBoardView`.
class CrewCapacityView extends StatelessWidget {
  const CrewCapacityView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DispatchLogic>(
      builder: (logic) {
        final today = dateOnly(DateTime.now());
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const DispatchHeader(
                  title: 'Crew Capacity',
                  subtitle: 'Booked days per crew. Tap a day to assign or change.',
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    children: [
                      _WeekSwitcher(
                        label: logic.capacityRangeLabel,
                        onPrevious: () => logic.shiftCapacityWeek(-1),
                        onNext: () => logic.shiftCapacityWeek(1),
                      ),
                      const SizedBox(height: 14),
                      for (final crew in logic.crews) ...[
                        CrewCapacityCard(
                          crewName: crew.name,
                          color: crew.color,
                          booked: logic.bookedDays(crew),
                          days: [
                            for (final d in logic.capacityDays)
                              CapacityDayData(
                                date: d,
                                booked: logic.assignmentFor(crew.id, d) != null,
                                isToday: d == today,
                                onTap: () =>
                                    logic.openAssignSheet(crew, date: d),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WeekSwitcher extends StatelessWidget {
  final String label;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _WeekSwitcher({
    required this.label,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _RoundArrow(icon: Icons.chevron_left, onTap: onPrevious),
        Text(
          'Week of $label',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: DispatchPalette.textDark,
          ),
        ),
        _RoundArrow(icon: Icons.chevron_right, onTap: onNext),
      ],
    );
  }
}

class _RoundArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundArrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 20,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: DispatchPalette.surfaceMuted,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: DispatchPalette.textDark),
      ),
    );
  }
}
