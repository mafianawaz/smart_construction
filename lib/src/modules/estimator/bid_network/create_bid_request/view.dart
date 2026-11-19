import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import '../../../../utils/app_color.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_textfield.dart';
import '../widgets/bid_common_widgets.dart';
import '../widgets/trade_picker_sheet.dart';
import 'logic.dart';

/// Screens 2–3 — Create Bid Request form (+ trade multi-select sheet).
/// Pops with the created [BidRequestModel] (draft) via `Get.back(result:)`.
class CreateBidRequestView extends StatelessWidget {
  const CreateBidRequestView({super.key});

  @override
  Widget build(BuildContext context) {
   return  GetBuilder(
      init: CreateBidRequestLogic(),
      builder: (logic){
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Create Bid Request',
            showBackButton: true,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create a new bid and solicitation to send to subcontractors on this network.',
                    style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 12),
                  _Section(
                    title: 'Basic Information',
                    children: [
                      Obx(() => _ErrorWrap(
                        error: logic.titleError,
                        child: CustomTextField(
                          heading: 'Title',
                          hintText: 'e.g. Site electrical package',
                          controller: logic.titleController,
                        ),
                      )),
                      const SizedBox(height: 10),
                      CustomTextField(
                        heading: 'Description / Note',
                        hintText: 'Describe the project and context...',
                        controller: logic.descriptionController,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        heading: 'Scope of Work',
                        hintText: 'Detail the specific work required...',
                        controller: logic.scopeController,
                        maxLines: 4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _Section(
                    title: 'Required Trades*',
                    subtitle: 'Select trade categories needed to bid on this bid',
                    children: [
                      Obx(() => _ErrorWrap(
                        error: logic.tradesError,
                        child: _PickerField(
                          hint: logic.selectedTrades.isEmpty
                              ? 'Select trades'
                              : '${logic.selectedTrades.length} selected',
                          hasValue: logic.selectedTrades.isNotEmpty,
                          trailing: Icons.keyboard_arrow_down,
                          onTap: () => TradePickerSheet.show(
                            context,
                            initial: logic.selectedTrades.toList(),
                            onDone: logic.setTrades,
                          ),
                        ),
                      )),
                      Obx(() => logic.selectedTrades.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            for (final t in logic.selectedTrades)
                              BidTradeTag(t),
                          ],
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _Section(
                    title: 'Timeline & Location',
                    children: [
                      Obx(() => _ErrorWrap(
                        error: logic.dueDateError,
                        child: _LabeledPicker(
                          label: 'Bid Due Date *',
                          hint: 'Pick a date and time',
                          value: logic.dueDate.value == null
                              ? null
                              : DateFormat('MMM d, y · h:mm a')
                              .format(logic.dueDate.value!),
                          trailing: Icons.calendar_today_outlined,
                          onTap: () async {
                            final d = await _pickDateTime(context, logic.dueDate.value);
                            if (d != null) logic.dueDate.value = d;
                          },
                        ),
                      )),
                      const SizedBox(height: 10),
                      Obx(() => _LabeledPicker(
                        label: 'Project Start Date',
                        hint: 'Select project launch target',
                        value: logic.projectStart.value == null
                            ? null
                            : DateFormat('MMM d, y').format(logic.projectStart.value!),
                        trailing: Icons.calendar_today_outlined,
                        onTap: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: logic.projectStart.value ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (d != null) logic.projectStart.value = d;
                        },
                      )),
                      const SizedBox(height: 10),
                      CustomTextField(
                        heading: 'Address',
                        hintText: 'e.g., 500 Grand Ave',
                        controller: logic.addressController,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              heading: 'City',
                              hintText: 'City name',
                              controller: logic.cityController,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomTextField(
                              heading: 'State',
                              hintText: 'State code',
                              controller: logic.stateController,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _Section(
                    title: 'Budget Estimation',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              heading: 'Budget Range Min (\$)',
                              hintText: 'e.g. 10,000',
                              controller: logic.budgetMinController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomTextField(
                              heading: 'Budget Range Max (\$)',
                              hintText: 'e.g. 50,000',
                              controller: logic.budgetMaxController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Obx(() => BidSwitchRow(
                        title: 'Show budget range to subcontractors',
                        subtitle: 'Subcontractors will see these targets',
                        value: logic.showBudget.value,
                        onChanged: (v) => logic.showBudget.value = v,
                      )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Figma labels this card "Required Trades*" a second time;
                  // its content is requirements, so it is titled accordingly.
                  _Section(
                    title: 'Requirements',
                    children: [
                      Obx(() => BidSwitchRow(
                        title: 'Requires Bonding',
                        subtitle: 'Verify subcontractor bondability',
                        value: logic.requiresBonding.value,
                        onChanged: (v) => logic.requiresBonding.value = v,
                      )),
                      Obx(() => BidSwitchRow(
                        title: 'Requires Insurance',
                        subtitle: 'General liability coverage mandate',
                        value: logic.requiresInsurance.value,
                        onChanged: (v) => logic.requiresInsurance.value = v,
                      )),
                      const SizedBox(height: 6),
                      CustomTextField(
                        heading: 'Special Requirements',
                        hintText: 'Any additional requirements or qualifications...',
                        controller: logic.specialController,
                        maxLines: 4,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: CustomButton(
                      text: 'Save as Draft',
                      onPressed: () {
                        final created = logic.saveAsDraft();
                        if (created != null) Get.back(result: created);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<DateTime?> _pickDateTime(BuildContext context, DateTime? initial) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null || !context.mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial ?? DateTime.now()),
    );
    if (time == null) return DateTime(date.year, date.month, date.day);
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, this.subtitle, required this.children});

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return BidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!,
                style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ],
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _ErrorWrap extends StatelessWidget {
  const _ErrorWrap({required this.error, required this.child});

  final String? error;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (error == null) return child;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(error!,
              style: TextStyle(fontSize: 10, color: AppColors.redColor)),
        ),
      ],
    );
  }
}

class _LabeledPicker extends StatelessWidget {
  const _LabeledPicker({
    required this.label,
    required this.hint,
    required this.onTap,
    required this.trailing,
    this.value,
  });

  final String label;
  final String hint;
  final String? value;
  final IconData trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        _PickerField(
          hint: value ?? hint,
          hasValue: value != null,
          trailing: trailing,
          onTap: onTap,
        ),
      ],
    );
  }
}

/// Tap-to-open field styled like the text inputs (used for dates and trades).
class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.hint,
    required this.hasValue,
    required this.trailing,
    required this.onTap,
  });

  final String hint;
  final bool hasValue;
  final IconData trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kBidBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hint,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: hasValue ? Colors.black87 : AppColors.textMuted,
                ),
              ),
            ),
            Icon(trailing, size: 16, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
