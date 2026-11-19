import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import '../../../../utils/app_color.dart';
import '../data/marketplace_mock_data.dart';
import '../models/marketplace_models.dart';
import '../widgets/marketplace_primitives.dart';
import 'logic.dart';

/// Create / Edit Equipment Listing. Pops with the built [EquipmentModel].
class EquipmentFormView extends StatefulWidget {
  final EquipmentModel? existing;
  const EquipmentFormView({super.key, this.existing});

  @override
  State<EquipmentFormView> createState() => _EquipmentFormViewState();
}

class _EquipmentFormViewState extends State<EquipmentFormView> {
  late final EquipmentFormLogic form;
  late final String _tag;

  @override
  void initState() {
    super.initState();
    _tag = 'equipment_form_${DateTime.now().microsecondsSinceEpoch}';
    form = Get.put(EquipmentFormLogic(existing: widget.existing), tag: _tag);
  }

  @override
  void dispose() {
    Get.delete<EquipmentFormLogic>(tag: _tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = form.isEdit;
    return Scaffold(
      appBar: AppPrimaryBar(
        title: isEdit ? 'Edit Equipment Listing' : 'List Equipment',
        showBackButton: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Provide details about the equipment you want to make available for rental.',
              style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: MarketplacePalette.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _field('Equipment Name *',
                      _text(form.nameC, 'e.g. Concrete Mixer Truck')),
                  _row(
                    _field(
                      'Category *',
                      Obx(() => MarketplaceDropdown(
                            value: form.category.value,
                            hint: 'Select',
                            items: MarketplaceMockData.formCategories,
                            onChanged: (v) => form.category.value = v,
                          )),
                    ),
                    _field(
                      'Condition',
                      Obx(() => MarketplaceDropdown(
                            value: form.condition.value,
                            items: MarketplaceMockData.conditions,
                            onChanged: (v) => form.condition.value = v,
                          )),
                    ),
                  ),
                  _row(
                    _field('Make / Model',
                        _text(form.makeModelC, 'e.g. Hino 300 Series')),
                    _field('Year',
                        _text(form.yearC, '2021', number: true)),
                  ),
                  _row(
                    _field('Daily Rate (\$)',
                        _text(form.dailyC, '0.00', number: true)),
                    _field('Weekly Rate (\$)',
                        _text(form.weeklyC, '0.00', number: true)),
                  ),
                  _row(
                    _field('Monthly Rate (\$)',
                        _text(form.monthlyC, '0.00', number: true)),
                    _field('Deposit Amount (\$)',
                        _text(form.depositC, '0.00', number: true)),
                  ),
                  _row(
                    _field('Location',
                        _text(form.locationC, 'e.g. Phoenix, AZ')),
                    _field('Delivery Radius (miles)',
                        _text(form.radiusC, '30', number: true)),
                  ),
                  _field(
                    'Photo URLs (comma-separated)',
                    _text(form.photosC,
                        'https://example.com/photo1.jpg, https://...'),
                  ),
                  Obx(() => Row(
                        children: [
                          Switch(
                            value: form.ongoing.value,
                            activeColor: Colors.white,
                            activeTrackColor: AppColors.primaryOrange,
                            onChanged: (v) => form.ongoing.value = v,
                          ),
                          const SizedBox(width: 6),
                          const Expanded(
                            child: Text('Ongoing availability (no fixed end date)',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      )),
                  const SizedBox(height: 6),
                  _field(
                    'Description',
                    TextField(
                      controller: form.descriptionC,
                      minLines: 5,
                      maxLines: 8,
                      style: const TextStyle(fontSize: 12.5),
                      decoration: _box('Describe the equipment'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            MarketplacePrimaryButton(
              label: isEdit ? 'Update Listing' : 'Create Listing',
              onPressed: () {
                final model = form.build();
                if (model != null) Get.back(result: model);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(Widget a, Widget b) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: a),
          const SizedBox(width: 10),
          Expanded(child: b),
        ],
      );

  Widget _field(String label, Widget child) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            child,
          ],
        ),
      );

  Widget _text(TextEditingController c, String hint, {bool number = false}) =>
      TextField(
        controller: c,
        keyboardType: number
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        style: const TextStyle(fontSize: 12.5),
        decoration: _box(hint),
      );

  InputDecoration _box(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12.5, color: AppColors.textMuted),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: MarketplacePalette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: AppColors.primaryOrange),
        ),
      );
}
