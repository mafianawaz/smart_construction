import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../widgets/project_action_button.dart';
import '../widgets/project_date_field.dart';
import '../widgets/project_form_card.dart';
import 'new_request_logic.dart';

/// "New Purchase Request" — pushed from the Requests section's New
/// Request button. Title / Needed By / Notes, then a repeatable Line
/// Items list; Create Request is pinned below the scroll area.
class NewRequestView extends StatelessWidget {
  final String projectId;
  const NewRequestView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewRequestLogic>(
      init: NewRequestLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'New Purchase Request',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create a purchase request with line items for approval.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 12),
                        ProjectFormCard(
                          children: [
                            CustomTextField(
                              heading: 'Title *',
                              hintText: 'Brief description...',
                              controller: logic.titleCtrl,
                            ),
                            projectFieldGap,
                            Obx(() => ProjectDateField(
                                  label: 'Needed By',
                                  hint: 'dd/mm/yyyy',
                                  format: 'dd/MM/yyyy',
                                  value: logic.neededBy.value,
                                  onChanged: (d) => logic.neededBy.value = d,
                                )),
                            projectFieldGap,
                            CustomTextField(
                              heading: 'Notes',
                              hintText: 'Additional notes or details...',
                              controller: logic.notesCtrl,
                              maxLines: 3,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Text('Line Items',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                            ),
                            ProjectActionButton(
                              label: 'Add Item',
                              icon: Icons.add,
                              filled: false,
                              expand: false,
                              height: 32,
                              onPressed: logic.addLine,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Obx(() => Column(
                              children: [
                                for (final draft in logic.lines.toList())
                                  _LineItemCard(
                                    key: ObjectKey(draft),
                                    draft: draft,
                                    onRemove: () => logic.removeLine(draft),
                                  ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Obx(() => CustomButton(
                        text: 'Create Request',
                        onPressed: logic.isCreating.value ? null : logic.createRequest,
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LineItemCard extends StatelessWidget {
  final PurchaseLineDraft draft;
  final VoidCallback onRemove;

  const _LineItemCard({super.key, required this.draft, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ProjectFormCard(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: onRemove,
            child: Icon(Icons.delete_outline, size: 18, color: Colors.grey.shade500),
          ),
        ),
        const SizedBox(height: 4),
        CustomTextField(
          heading: 'Description',
          hintText: 'Material/Item...',
          controller: draft.descriptionCtrl,
        ),
        projectFieldGap,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: CustomTextField(
                heading: 'Qty',
                hintText: '0',
                controller: draft.quantityCtrl,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: CustomTextField(
                heading: 'Unit',
                hintText: 'ea, lf...',
                controller: draft.unitCtrl,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: CustomTextField(
                heading: 'Est. Cost',
                hintText: '0.00',
                controller: draft.estCostCtrl,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        projectFieldGap,
        CustomTextField(
          heading: 'Cost Code',
          hintText: 'Search or type a cost code...',
          controller: draft.costCodeCtrl,
          leftIconPath: AppIcons.search,
        ),
      ],
    );
  }
}
