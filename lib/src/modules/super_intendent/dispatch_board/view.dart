import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/app_calendar/view.dart';
import 'logic.dart';
import 'widgets/assignments_card.dart';
import 'widgets/dispatch_header.dart';
import 'widgets/dispatch_palette.dart';


/// Dispatch Board: crew-coloured calendar + the selected day's assignments.
///
/// Usage: `Get.to(() => const DispatchBoardView());`
class DispatchBoardView extends StatelessWidget {
  const DispatchBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DispatchLogic>(
      init: DispatchLogic(),
      builder: (logic) {
        final rows = <AssignmentRowData>[
          for (final a in logic.selectedAssignments)
            if (logic.crewById(a.crewId) != null)
              AssignmentRowData(
                color: logic.crewById(a.crewId)!.color,
                crewName: logic.crewById(a.crewId)!.name,
                projectName: logic.projectById(a.projectId)?.name ?? 'Unknown project',
                onTap: () => logic.openAssignSheet(logic.crewById(a.crewId)!),
              ),
        ];

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                DispatchHeader(
                  title: 'Dispatch Board',
                  subtitle: 'Manage crew assignments across projects and tasks',
                  actionLabel: 'Crew Capacity',
                  onAction: logic.openCrewCapacity,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    children: [
                      AppCalendar(
                        tag: 'dispatch_board_calendar',
                        skin: CalendarSkin.board,
                        showLegend: false,
                        selectedDate: logic.selectedDate,
                        onDateSelected: logic.selectDate,
                        dayIndicatorsBuilder: logic.indicatorColorsFor,
                        selectedColor: DispatchPalette.orange,
                        todayBorderColor: DispatchPalette.orange,
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      const SizedBox(height: 16),
                      AssignmentsCard(title: logic.assignmentsTitle, rows: rows),
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
