import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../utils/app_color.dart';
import '../models/cost_book_models.dart';
import '../widgets/cost_book_buttons.dart';
import '../widgets/cost_book_field.dart';
import '../widgets/cost_book_header.dart';
import '../widgets/cost_book_palette.dart';
import 'logic.dart';

/// Add Region / Edit Region (geo factor). Pass [initial] to edit; the page
/// pops with the finished `GeoFactorModel`.
class RegionFormView extends StatelessWidget {
  final GeoFactorModel? initial;

  const RegionFormView({super.key, this.initial});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegionFormLogic>(
      init: RegionFormLogic(initial: initial),
      global: false,
      builder: (logic) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CostBookHeader(
                    title: logic.isEdit ? 'Edit Region' : 'Add Region',
                    onBack: Get.back,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: _form(logic, context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static final _decimal = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
  ];

  Widget _form(RegionFormLogic logic, BuildContext context) {
    const decimalKeys = TextInputType.numberWithOptions(decimal: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set per-region multipliers. Lookups use the total factor as a '
          'fallback when a per-cost factor is 1.000.',
          style: TextStyle(fontSize: 11, height: 1.4, color: AppColors.textMuted),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CostBookPalette.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Obx(
                      () => CostBookField(
                        heading: 'Region Code',
                        hintText: 'DEN-CO',
                        controller: logic.codeController,
                        errorText: logic.codeError.value,
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(
                      () => CostBookField(
                        heading: 'Region Name',
                        hintText: 'Denver Metro',
                        controller: logic.nameController,
                        errorText: logic.nameError.value,
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: CostBookField(
                      heading: 'City',
                      hintText: 'City name',
                      controller: logic.cityController,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: CostBookField(
                      heading: 'State',
                      hintText: 'CO',
                      controller: logic.stateController,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [LengthLimitingTextInputFormatter(2)],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: CostBookField(
                      heading: 'Postal Code',
                      hintText: '80202',
                      controller: logic.postalController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _multField('Material', logic.materialController, decimalKeys),
                  const SizedBox(width: 8),
                  _multField('Labor', logic.laborController, decimalKeys),
                  const SizedBox(width: 8),
                  _multField('Equipment', logic.equipmentController, decimalKeys),
                  const SizedBox(width: 8),
                  _multField('Total', logic.totalController, decimalKeys),
                ],
              ),
              Obx(() {
                final error = logic.multiplierError.value;
                if (error == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    error,
                    style: const TextStyle(
                      fontSize: 10,
                      color: CostBookPalette.danger,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              CostBookField(
                heading: 'As-of Date',
                hintText: 'MM/DD/YYYY',
                controller: logic.asOfController,
                readOnly: true,
                onTap: () => _pickDate(context, logic),
                suffixIcon: Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // The Figma Edit frame still says "Add Region" — treated as a slip.
        CostBookButton(
          text: logic.isEdit ? 'Save Changes' : 'Add Region',
          onPressed: logic.submit,
        ),
      ],
    );
  }

  Widget _multField(
    String heading,
    TextEditingController controller,
    TextInputType keyboardType,
  ) {
    return Expanded(
      child: CostBookField(
        heading: heading,
        hintText: '1.000',
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: _decimal,
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, RegionFormLogic logic) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: logic.asOf.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) logic.setAsOf(picked);
  }
}
