import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import '../../models/field_ops_models.dart';
import '../../models/project_enums.dart';
import '../../widgets/project_badge.dart';
import '../widgets/project_action_button.dart';
import 'punch_item_detail_logic.dart';

/// Punch Item detail — pushed from a list row. One card: number + title,
/// description, status / priority / trade badges, ASSIGNED TO, ATTACHMENTS
/// with the outlined "Add Photo / File" button, Created / Due dates,
/// UPDATE NOTES, then the two status actions.
class PunchItemDetailView extends StatelessWidget {
  final String projectId;
  final String itemId;
  const PunchItemDetailView({super.key, required this.projectId, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PunchItemDetailLogic>(
      init: PunchItemDetailLogic(projectId, itemId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(title: 'Punch List', showBackButton: true, centerTitle: true),
          body: SafeArea(
            child: Obx(() {
              final item = logic.item;
              if (item == null) {
                return const Center(child: Text('This punch item no longer exists.'));
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
                child: _DetailCard(item: item, logic: logic),
              );
            }),
          ),
        );
      },
    );
  }
}

class _Caption extends StatelessWidget {
  final String text;
  const _Caption(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(text.toUpperCase(),
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w700, color: Colors.grey.shade500)),
      );
}

class _DetailCard extends StatelessWidget {
  final PunchItemModel item;
  final PunchItemDetailLogic logic;
  const _DetailCard({required this.item, required this.logic});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d, y');
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('${item.number} - ${item.title}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ),
              InkWell(
                onTap: logic.edit,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(Icons.edit_outlined, size: 18, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
          if (item.description != null) ...[
            const SizedBox(height: 4),
            Text(item.description!,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
          if (item.location != null) ...[
            const SizedBox(height: 4),
            Text(item.location!, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ProjectBadge(
                  label: item.status.label,
                  background: item.status.background,
                  foreground: item.status.foreground),
              ProjectBadge(
                  label: item.priority.label,
                  background: item.priority.background,
                  foreground: item.priority.foreground),
              ProjectBadge(
                  label: item.trade.label,
                  background: Colors.grey.shade100,
                  foreground: Colors.grey.shade700),
            ],
          ),
          const SizedBox(height: 12),
          const _Caption('Assigned to'),
          Text(item.assigneeName ?? 'Unassigned',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          if (item.assigneeEmail != null)
            Text(item.assigneeEmail!,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          const _Caption('Attachments'),
          ProjectActionButton(
            label: 'Add Photo / File',
            icon: Icons.add_a_photo_outlined,
            filled: false,
            onPressed: logic.addPhotoOrFile,
          ),
          if (item.attachmentCount > 0) ...[
            const SizedBox(height: 6),
            Text('${item.attachmentCount} attached',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Created ${fmt.format(item.createdAt)}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              Text(item.dueDate == null ? 'No due date' : 'Due ${fmt.format(item.dueDate!)}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 10),
          const _Caption('Update notes'),
          TextField(
            controller: logic.notesCtrl,
            onChanged: logic.onNotesChanged,
            maxLines: 2,
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              hintText: 'Add notes about progress or resolution...',
              hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
              isDense: true,
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.fieldBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.fieldBorder),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ProjectActionButton(
                  label: 'Mark In Progress',
                  icon: Icons.play_arrow_outlined,
                  filled: false,
                  height: 40,
                  onPressed: item.status == PunchStatus.inProgress
                      ? null
                      : () => logic.setStatus(PunchStatus.inProgress),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ProjectActionButton(
                  label: 'Mark Complete',
                  icon: Icons.check_circle_outline,
                  filled: false,
                  height: 40,
                  onPressed: item.status == PunchStatus.complete
                      ? null
                      : () => logic.setStatus(PunchStatus.complete),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
