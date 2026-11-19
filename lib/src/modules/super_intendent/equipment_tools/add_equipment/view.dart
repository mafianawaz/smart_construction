import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';
import '../models/equipment_models.dart';
import '../widgets/equipment_form_widgets.dart';
import '../widgets/equipment_palette.dart';
import 'logic.dart';

/// Add New Equipment form. Pops with an [EquipmentDraft] on Create.
///
/// Usage: `final draft = await Get.to<EquipmentDraft>(() => const AddEquipmentView());`
class AddEquipmentView extends StatelessWidget {
  const AddEquipmentView({super.key});

  Future<void> _pickDate(BuildContext context, AddEquipmentLogic logic) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: logic.inServiceDate ?? now,
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) logic.setInServiceDate(picked);
  }


  @override
  Widget build(BuildContext context) {
    final decimal = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))];

    return GetBuilder<AddEquipmentLogic>(
      init: AddEquipmentLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Add New Equipment',
            subtitle: 'Enter the details for the new equipment or tool.',
            showBackButton: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                      heading: 'Name *',
                      hintText: 'e.g., CAT 320 Excavator #1',
                      controller: logic.nameC,
                      onChange: logic.onTextChanged,
                    ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdown<EquipmentType>(
                          heading: 'Type *',
                          hintText: 'Select type',
                          value: logic.type,
                          items: EquipmentType.values,
                          itemLabel: (t) => t.label,
                          onChanged: logic.setType,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          heading: 'Current Hours',
                          hintText: '0',
                          controller: logic.hoursC,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatter: decimal,
                          isFilled: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          heading: 'Make',
                          hintText: 'e.g., Caterpillar',
                          controller: logic.makeC,
                          isFilled: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          heading: 'Model',
                          hintText: 'e.g., 320D L',
                          controller: logic.modelC,
                          isFilled: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          heading: 'Year',
                          hintText: 'e.g., 2020',
                          controller: logic.yearC,
                          keyboardType: TextInputType.number,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          onChange: logic.onTextChanged,
                          isFilled: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          heading: 'Serial Number',
                          hintText: 'Serial Number',
                          controller: logic.serialC,
                          isFilled: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          heading: 'VIN (Vehicles)',
                          hintText: 'VIN (Vehicles)',
                          controller: logic.vinC,
                          isFilled: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          heading: 'License Plate',
                          hintText: 'License Plate',
                          controller: logic.plateC,
                          isFilled: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          heading: 'Purchase Price',
                          hintText: '0.00',
                          controller: logic.priceC,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatter: decimal,
                          isFilled: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          heading: 'Home Location',
                          hintText: 'Default storage location',
                          controller: logic.locationC,
                          isFilled: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const EquipmentSectionTitle('Depreciation Settings'),
                  const SizedBox(height: 15),
                  CustomDropdown<DepreciationMethod>(
                    heading: 'Depreciation Method',
                    hintText: 'Select method',
                    value: logic.method,
                    items: DepreciationMethod.values,
                    itemLabel: (m) => m.label,
                    onChanged: logic.setMethod,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    heading: 'Useful Life (Years)',
                    hintText: 'e.g., 10',
                    controller: logic.lifeC,
                    keyboardType: TextInputType.number,
                    inputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    isFilled: true,
                  ),
                  const SizedBox(height: 10),
                  Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            heading: 'Salvage Value (\$)',
                            hintText: '0.00',
                            controller: logic.salvageC,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatter: decimal,
                            isFilled: true,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: CustomTextField(
                            heading: 'In-Service Date',
                            hintText: 'mm/dd/yyyy',
                            // controller: logic.inServiceDate == null
                            //     ? null
                            //     : EquipmentFormat.date(logic.inServiceDate!),
                            onClick: () => _pickDate(context, logic),
                            isFilled: true,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 10,),
                  CustomTextField(
                      heading: 'Description',
                      hintText: 'Description and specifications...',
                      controller: logic.descriptionC,
                      maxLines: 3,
                      isFilled: true,
                    ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    heading: 'Notes',
                    hintText: 'Additional notes...',
                    controller: logic.notesC,
                    maxLines: 3,
                    isFilled: true,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: SuperInEquipmentPalette.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: OutlinedButton(
                              onPressed: logic.cancel,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: SuperInEquipmentPalette.textDark,
                                side: const BorderSide(
                                  color: SuperInEquipmentPalette.border,
                                ),
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
                                backgroundColor: SuperInEquipmentPalette.orange,
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
                              child: const Text('Create Equipment'),
                            ),
                          ),
                        ),
                      ],
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
}
