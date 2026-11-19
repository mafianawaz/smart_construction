import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import '../models/purchase_request_models.dart';
import '../widgets/proc_inputs.dart';
import 'logic.dart';

/// New Purchase Request form (also used to edit a draft).
class NewRequestView extends StatelessWidget {
  final List<String> projects;
  final String nextNumber;
  final PurchaseRequest? existing;

  const NewRequestView({
    super.key,
    required this.projects,
    required this.nextNumber,
    this.existing,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewRequestLogic>(
      init: NewRequestLogic(
        projects: projects,
        nextNumber: nextNumber,
        existing: existing,
      ),
      builder: (logic) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppPrimaryBar(
            title: logic.isEdit ? 'Edit Purchase Request' : 'New Purchase Request',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create a purchase request with line items for approval.',
                    style: TextStyle(fontSize: 12, color: ProcStyle.muted),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ProcStyle.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ProcDropdown(
                                label: 'Project',
                                required: true,
                                highlight: true,
                                hint: 'Select project...',
                                value: logic.project,
                                options: logic.projects,
                                errorText: logic.errors['project'],
                                onChanged: logic.setProject,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ProcDateField(
                                label: 'Needed By',
                                text: logic.neededBy == null
                                    ? ''
                                    : formatProcDate(logic.neededBy!),
                                onTap: logic.pickDate,
                              ),
                            ),
                          ],
                        ),
                        ProcField(
                          label: 'Title',
                          required: true,
                          hint: 'Brief description...',
                          controller: logic.titleCtrl,
                          errorText: logic.errors['title'],
                          onChanged: (_) => logic.clearError('title'),
                        ),
                        ProcField(
                          label: 'Notes',
                          hint: 'Add any additional context or instructions...',
                          controller: logic.notesCtrl,
                          maxLines: 4,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Text('Line Items',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ),
                            ProcButton(
                              text: '+ Add Item',
                              compact: true,
                              onPressed: logic.addItem,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        for (var i = 0; i < logic.items.length; i++)
                          _LineItemCard(
                            logic: logic,
                            index: i,
                            item: logic.items[i],
                          ),
                        if (logic.errors['items'] != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              logic.errors['items']!,
                              style: const TextStyle(
                                  fontSize: 11, color: ProcStyle.danger),
                            ),
                          ),
                        Row(
                          children: [
                            Text('Estimated total',
                                style: TextStyle(
                                    fontSize: 12, color: ProcStyle.muted)),
                            const Spacer(),
                            Text(logic.estimatedTotalText,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProcButton(
                    text: logic.isEdit ? 'Save Changes' : 'Create Request',
                    fullWidth: true,
                    onPressed: logic.submit,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LineItemCard extends StatelessWidget {
  final NewRequestLogic logic;
  final int index;
  final LineItemDraft item;

  const _LineItemCard({
    required this.logic,
    required this.index,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ProcStyle.panel,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ProcStyle.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (logic.items.length > 1)
            Row(
              children: [
                Text('Item ${index + 1}',
                    style: TextStyle(fontSize: 11, color: ProcStyle.muted)),
                const Spacer(),
                GestureDetector(
                  onTap: () => logic.removeItem(index),
                  child: const Icon(Icons.delete_outline,
                      size: 16, color: ProcStyle.danger),
                ),
              ],
            ),
          if (logic.items.length > 1) const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: ProcField(
                  label: 'Description',
                  hint: 'Material...',
                  controller: item.description,
                  errorText: item.errors['description'],
                  onChanged: (_) => logic.clearItemError(item, 'description'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ProcField(
                  label: 'Qty',
                  hint: '0',
                  controller: item.qty,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: procDecimalFormatters(),
                  errorText: item.errors['qty'],
                  onChanged: (_) {
                    logic.clearItemError(item, 'qty');
                    logic.update();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ProcField(
                  label: 'Unit',
                  hint: 'ea, lf, sf',
                  controller: item.unit,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: ProcField(
                  label: 'Est. Unit Cost',
                  hint: '\$0.00',
                  controller: item.unitCost,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: procDecimalFormatters(),
                  onChanged: (_) => logic.update(),
                ),
              ),
            ],
          ),
          ProcField(
            label: 'Cost Code',
            hint: 'Search or type a cost code...',
            controller: item.costCode,
            prefix: Icon(Icons.search, size: 18, color: ProcStyle.muted),
          ),
        ],
      ),
    );
  }
}
