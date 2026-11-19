import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';
import '../../../../utils/app_color.dart';
import '../../../../widgets/app_textfield.dart';
import '../../../field_worker/my_work/project_details/widget/job_info_card.dart';
import '../models/pricing_category.dart';
import '../models/pricing_item_model.dart';
import 'logic.dart';


class PricingFormView extends StatelessWidget {
  final PricingCategory category;
  final PricingItemModel? existingItem;

  const PricingFormView({
    super.key,
    required this.category,
    this.existingItem,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PricingFormLogic>(
      init: PricingFormLogic(category: category, existingItem: existingItem),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'My Pricing',
            showBackButton: true,
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(15),
            children: [
              SectionCard(
                cardColor: Colors.white,
                title: logic.screenTitle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      logic.isEditing
                          ? 'Update this pricing item for your enrolled contractor clients.'
                          : 'Add a new pricing item to submit to your enrolled contractor clients.',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      heading: 'Item Name',
                      hintText: 'e.g. 2x4x8 Stud',
                      controller: logic.nameController,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      heading: 'Item Code',
                      hintText: 'e.g. LBR-2X4-96',
                      controller: logic.codeController,
                    ),
                    const SizedBox(height: 10),
                    CustomDropdown(
                      heading: 'Category',
                      value: logic.subCategory.value,
                      items: category.subCategoryOptions,
                      itemLabel: (item) => item,
                      onChanged: logic.setSubCategory,
                    ),
                    const SizedBox(height: 10),
                    CustomDropdown(
                      heading: 'Unit',
                      value: logic.unit.value,
                      items: category.unitOptions,
                      itemLabel: (item) => item,
                      onChanged: logic.setUnit,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      heading: 'Description',
                      hintText: 'Describe the product...',
                      controller: logic.descriptionController,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      heading: 'Unit Price (\$)',
                      hintText: '0.00',
                      controller: logic.unitPriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      heading: 'Minimum Order',
                      hintText: '1',
                      controller: logic.minimumOrderController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      heading: 'Delivery Fee (\$)',
                      hintText: '0.00',
                      controller: logic.deliveryFeeController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      heading: 'Lead Time (days)',
                      hintText: '1',
                      controller: logic.leadTimeController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    if (logic.errorMessage.value.isNotEmpty) ...[
                      Text(
                        logic.errorMessage.value,
                        style: TextStyle(color: AppColors.redColor, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                    ],
                    SizedBox(height: 16),
                    CustomButton(
                        text: 'Submit Pricing',
                      onPressed: () {
                        final result = logic.submit();
                        if (result == null) {
                          logic.update();
                          return;
                        }
                        // TODO(api): the caller (PricingLogic.upsertItem)
                        // currently just merges this into the in-memory
                        // list — swap for a refetch once the create/edit
                        // endpoints are wired up.
                        Get.back(result: result);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
