import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/project_enums.dart';
import '../../models/quality_models.dart';
import '../../models/scope_models.dart';
import '../widgets/project_select_field.dart';
import '../widgets/soft_action_button.dart';
import 'logic.dart';

/// Daily Notes tab — "Daily Report" heading and description, the Notes &
/// Progress box, the Materials Usage Tracking select, the peach "+ Add
/// Entry" button and the Daily Notes card (Filters button, list or the "No
/// notes yet" message).
class DailyNotesView extends StatelessWidget {
  final String projectId;
  const DailyNotesView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DailyNotesLogic>(
      init: DailyNotesLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Daily Report',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                "Record today's progress and optionally track material usage",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 14),
              CustomTextField(
                heading: 'Notes & Progress',
                hintText: "Document today's progress, issues, or important updates...",
                controller: logic.notesCtrl,
                maxLines: 5,
              ),
              const SizedBox(height: 12),
              Obx(() => ProjectSelectField<ScopeItemModel>(
                    allLabel: 'Materials Usage Tracking',
                    muted: true,
                    value: logic.materialItem.value,
                    options: logic.scopeItems,
                    labelOf: (i) => i.name,
                    onChanged: (i) => logic.materialItem.value = i,
                  )),
              const SizedBox(height: 12),
              SoftActionButton(label: '+ Add Entry', onPressed: logic.addEntry),
              const SizedBox(height: 14),
              _DailyNotesCard(logic: logic),
            ],
          ),
        );
      },
    );
  }
}

class _DailyNotesCard extends StatelessWidget {
  final DailyNotesLogic logic;
  const _DailyNotesCard({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Daily Notes',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              ),
              Obx(() => PopupMenuButton<DailyNoteFilter>(
                initialValue: logic.filter.value,
                onSelected: logic.setFilter,
                itemBuilder: (context) => [
                  for (final f in DailyNoteFilter.values)
                    PopupMenuItem(value: f, child: Text(f.label)),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_alt_outlined, size: 14, color: Colors.grey.shade800),
                      const SizedBox(width: 4),
                      const Text('Filters',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              )),
            ],
          ),
          const SizedBox(height: 14),
          Obx(() {
            final list = logic.filteredNotes;
            if (list.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 26),
                child: Center(
                  child: Text(
                    logic.notes.isEmpty
                        ? 'No notes yet. Add the first daily note above.'
                        : 'No notes match this filter.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ),
              );
            }
            return Column(children: [for (final n in list) _NoteTile(note: n)]);
          }),
        ],
      ),
    );
  }
}

/// Populated note row. The reference only shows the empty state, so this
/// layout is a guess (flagged in NOTES_BILLING_NOTES_INSPECTIONS.md).
class _NoteTile extends StatelessWidget {
  final DailyNoteModel note;
  const _NoteTile({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DateFormat('MMM d, y · h:mm a').format(note.createdAt),
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          const SizedBox(height: 4),
          Text(note.text, style: const TextStyle(fontSize: 12)),
          if (note.materialScopeItem != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.inventory_2_outlined, size: 12, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(note.materialScopeItem!,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
