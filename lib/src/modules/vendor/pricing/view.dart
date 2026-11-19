import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/modules/vendor/pricing/models/pricing_category.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_toggle_switch.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/app_empty_filter.dart';
import 'bulk_upload/view.dart';
import 'logic.dart';
import 'models/pricing_item_model.dart';
import 'pricing_form_view/view.dart';
import 'widgets/pricing_dropdown_pill.dart';
import 'widgets/pricing_item_card.dart';


class PricingView extends StatelessWidget {
  const PricingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PricingLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: SecondaryAppbar(
            isHome: false,
            title: 'My Pricing',
            subTitle: 'Manage your pricing items for enrolled contractor clients',
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomIconButton(
                        onPressed: () async {
                          final result = await Get.to<PricingItemModel>(
                            () => PricingFormView(category: logic.currentTab.value),
                          );
                          if (result != null) logic.upsertItem(result);
                          logic.update();
                        },
                        icon: AppIcons.export,
                        text: 'Add Pricing Item',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlineIconButton(
                        onPressed: () async {
                          await Get.to(
                            () => BulkUploadView(category: logic.currentTab.value),
                          );
                          logic.update();
                        },
                        icon: AppIcons.export,
                        text: 'Add Bulk Items',
                        isMuted: true,
                      ),
                    ),
                  ],
                ),
                CustomTextField(
                 hintText: 'Search items...',
                 leftIconPath: AppIcons.search,
                 onChange: logic.setSearch,
                ),
                const SizedBox(height: 15),
                CustomToggle(
                  options: PricingCategory.values.map((category) => category.tabLabel).toList(),
                  selectedIndex: logic.currentTab.value.index,
                  onChanged: (index) {
                    logic.selectTab(PricingCategory.values[index]);
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    PricingDropdownPill(
                      value: logic.categoryFilter.value,
                      options: logic.categoryOptions,
                      filled: true,
                      onChanged: logic.setCategoryFilter,
                    ),
                    const SizedBox(width: 10),
                    PricingDropdownPill(
                      value: logic.statusFilter.value,
                      options: logic.statusOptions,
                      onChanged: logic.setStatusFilter,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: logic.filteredItems.isEmpty
                      ? AppEmptyState(
                          icon: Icons.inventory_2_outlined,
                          title: logic.currentTab.value.emptyStateTitle,
                          message: 'Try adjusting your search or filters',
                          showButton: false,
                        )
                      : ListView.separated(
                          itemCount: logic.filteredItems.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = logic.filteredItems[index];
                            return PricingItemCard(
                              item: item,
                              onEdit: () async {
                                final result = await Get.to<PricingItemModel>(
                                  () => PricingFormView(
                                    category: item.category,
                                    existingItem: item,
                                  ),
                                );
                                if (result != null) logic.upsertItem(result);
                                logic.update();
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
