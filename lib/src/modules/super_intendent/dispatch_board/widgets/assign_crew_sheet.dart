import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../crew_capacity/logic.dart';
import '../data/dispatch_format.dart';
import '../models/dispatch_models.dart';
import 'dispatch_palette.dart';

/// "Assign Crew" bottom sheet. Open it through `DispatchLogic.openAssignSheet`
/// (`Get.bottomSheet`, `isScrollControlled: true`, transparent background);
/// it pops with an [AssignCrewResult] or null.
class AssignCrewSheet extends StatefulWidget {
  final Crew crew;
  final DateTime date;
  final List<DispatchProject> projects;
  final String? initialProjectId;
  final String initialNotes;

  const AssignCrewSheet({
    super.key,
    required this.crew,
    required this.date,
    required this.projects,
    this.initialProjectId,
    this.initialNotes = '',
  });

  @override
  State<AssignCrewSheet> createState() => _AssignCrewSheetState();
}

class _AssignCrewSheetState extends State<AssignCrewSheet> {
  // Created once so keyboard-driven rebuilds don't spawn throwaway controllers.
  late final AssignCrewLogic _logic = AssignCrewLogic(
    crew: widget.crew,
    date: widget.date,
    projects: widget.projects,
    initialProjectId: widget.initialProjectId,
    initialNotes: widget.initialNotes,
  );

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            child: GetBuilder<AssignCrewLogic>(
              init: _logic,
              builder: (logic) => _SheetBody(logic: logic),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetBody extends StatelessWidget {
  final AssignCrewLogic logic;

  const _SheetBody({required this.logic});

  @override
  Widget build(BuildContext context) {
    final error = logic.projectError;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Assign Crew',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: DispatchPalette.textDark,
                ),
              ),
            ),
            InkResponse(
              onTap: logic.cancel,
              radius: 20,
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: DispatchPalette.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: DispatchPalette.textDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Assign this crew to a project for the selected date.',
          style: TextStyle(fontSize: 13, color: DispatchPalette.textMuted),
        ),
        const SizedBox(height: 18),
        const _FieldLabel('CREW'),
        Text(
          logic.crew.name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: logic.crew.color,
          ),
        ),
        const SizedBox(height: 16),
        const _FieldLabel('DATE'),
        Text(
          DispatchFormat.longDate(logic.date),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: DispatchPalette.purple,
          ),
        ),
        const SizedBox(height: 16),
        const _FieldLabel('PROJECT'),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: error == null ? DispatchPalette.orange : DispatchPalette.red,
              width: 1.2,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: logic.projectId,
              isExpanded: true,
              dropdownColor: Colors.white,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: DispatchPalette.orange,
              ),
              hint: const Text(
                'Select a project',
                style: TextStyle(fontSize: 14, color: DispatchPalette.textFaint),
              ),
              style: const TextStyle(
                fontSize: 14,
                color: DispatchPalette.textDark,
              ),
              items: [
                for (final p in logic.projects)
                  DropdownMenuItem<String>(value: p.id, child: Text(p.name)),
              ],
              onChanged: logic.setProject,
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 2),
            child: Text(
              error,
              style: const TextStyle(fontSize: 11.5, color: DispatchPalette.red),
            ),
          ),
        const SizedBox(height: 16),
        const _FieldLabel('NOTES (OPTIONAL)'),
        TextField(
          controller: logic.notesController,
          minLines: 3,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          style: const TextStyle(fontSize: 14, color: DispatchPalette.textDark),
          decoration: InputDecoration(
            hintText: 'Assignment notes...',
            hintStyle: const TextStyle(
              fontSize: 14,
              color: DispatchPalette.textFaint,
            ),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: DispatchPalette.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: DispatchPalette.orange),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46,
                child: OutlinedButton(
                  onPressed: logic.cancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: DispatchPalette.textDark,
                    side: const BorderSide(color: DispatchPalette.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: logic.submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DispatchPalette.orange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Assign'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          color: DispatchPalette.textDark,
        ),
      ),
    );
  }
}
