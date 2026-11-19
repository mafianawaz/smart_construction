import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../../../utils/app_color.dart';
import '../models/crew_models.dart';
import '../widgets/add_line_sheets.dart';
import '../widgets/crew_buttons.dart';
import '../widgets/crew_line_section.dart';
import '../widgets/crew_palette.dart';
import 'logic.dart';

/// New Crew Template / Edit Crew Template. Pass [initial] to edit; pops with
/// the finished `CrewTemplateModel`.
class CrewTemplateFormView extends StatelessWidget {
  final CrewTemplateModel? initial;

  const CrewTemplateFormView({super.key, this.initial});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CrewTemplateFormLogic>(
      init: CrewTemplateFormLogic(initial: initial),
      global: false,
      builder: (logic) => Scaffold(
        appBar: AppPrimaryBar(
          title: logic.isEdit ? 'Edit Crew Template' : 'New Crew Template',
          showBackButton: true,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: _form(logic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _form(CrewTemplateFormLogic logic) {
    const gap = SizedBox(height: 12);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Define crew composition. Labor cost = count × hourly × hours × '
          '(1 + burden). Equipment cost = count × (daily + fixed).',
          style: TextStyle(fontSize: 11, height: 1.4, color: AppColors.textMuted),
        ),
        const SizedBox(height: 14),
        CustomTextField(
            heading: 'Code',
            hintText: 'e.g. CONC-CREW-A',
            controller: logic.codeController,
            textCapitalization: TextCapitalization.characters,
          ),
        gap,
        CustomTextField(
            heading: 'Name',
            hintText: 'e.g. Concrete Pour Crew',
            controller: logic.nameController,
            textCapitalization: TextCapitalization.words,
          ),
        gap,
        CustomTextField(
          heading: 'Trade Type',
          hintText: 'e.g. Concrete',
          controller: logic.tradeController,
          textCapitalization: TextCapitalization.words,
        ),
        gap,
        CustomTextField(
            heading: 'Default Hours / Day',
            hintText: '8.00',
            controller: logic.hoursController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            onChange: logic.onHoursChanged,
          ),
        gap,
        CustomTextField(
          heading: 'Production Unit',
          hintText: 'e.g. CY, SF, LF',
          controller: logic.unitController,
          textCapitalization: TextCapitalization.characters,
        ),
        gap,
        CustomTextField(
          heading: 'Production / Day',
          hintText: 'Empty',
          controller: logic.productionController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        ),
        gap,
        CustomTextField(
          heading: 'Description',
          hintText: 'Additional notes or details...',
          controller: logic.descriptionController,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Obx(
              () => Switch(
                value: logic.isActive.value,
                onChanged: logic.setActive,
                activeColor: Colors.white,
                activeTrackColor: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Active',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: CrewPalette.ink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(
          () => CrewLineSection(
            title: 'Workers',
            addLabel: '+ Add Worker',
            emptyMessage: 'No workers added.',
            onAdd: () async {
              final w = await showAddWorkerSheet();
              if (w != null) logic.addWorker(w);
            },
            rows: [
              for (var i = 0; i < logic.workers.length; i++)
                CrewLineTile(
                  title: '${logic.workers[i].count} × ${logic.workers[i].role}',
                  subtitle:
                      '${formatCrewUsd(logic.workers[i].hourlyRate)}/hr · '
                      '${logic.workers[i].burdenPercent.toStringAsFixed(1)}% burden',
                  cost: formatCrewUsd(
                    logic.workers[i].dailyCost(logic.hoursForCost),
                  ),
                  onRemove: () => logic.removeWorkerAt(i),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => CrewLineSection(
            title: 'Equipment',
            addLabel: '+ Add Equipment',
            emptyMessage: 'No equipment added.',
            onAdd: () async {
              final e = await showAddEquipmentSheet();
              if (e != null) logic.addEquipment(e);
            },
            rows: [
              for (var i = 0; i < logic.equipment.length; i++)
                CrewLineTile(
                  title: '${logic.equipment[i].count} × ${logic.equipment[i].name}',
                  subtitle:
                      '${formatCrewUsd(logic.equipment[i].dailyRate)}/day + '
                      '${formatCrewUsd(logic.equipment[i].fixedCost)} fixed',
                  cost: formatCrewUsd(logic.equipment[i].dailyCost),
                  onRemove: () => logic.removeEquipmentAt(i),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          // Only shown once something is added; the Figma frame has none.
          if (logic.workers.isEmpty && logic.equipment.isEmpty) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estimated daily cost',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
                Text(
                  formatCrewUsd(logic.previewDailyCost),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ],
            ),
          );
        }),
        // The Figma Edit frame still says "Create Crew Template" — treated as
        // a copy slip; edit mode says "Save Crew Template".
        CrewButton(
          text: logic.isEdit ? 'Save Crew Template' : 'Create Crew Template',
          onPressed: logic.submit,
        ),
      ],
    );
  }
}
