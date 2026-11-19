import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/pill_tab_group.dart';
import 'logic.dart';
import 'models/inventory_models.dart';
import 'widgets/field_activity_cards.dart';
import 'widgets/inv_buttons_tabs.dart';
import 'widgets/inv_inputs.dart';
import 'widgets/inv_style.dart';
import 'widgets/labels_panel.dart';
import 'widgets/stock_action_forms.dart';
import 'widgets/stock_panels.dart';

class MaterialInventoryView extends StatelessWidget {
  const MaterialInventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MaterialInventoryLogic>(
      init: MaterialInventoryLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Materials Inventory',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Warehouse / yard stock, receiving, issuing, and cycle counts.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomIconButton(
                          text: 'Material',
                          icon: AppIcons.add,
                          onPressed: logic.addMaterial,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomIconButton(
                          text: 'Location',
                          icon: AppIcons.location,
                          onPressed: logic.addLocation,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  const Text('Barcode / QR Scan',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  Text(
                    'Type or scan a barcode/SKU to look up on-hand.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InvField(
                          hint: 'Scan or type Barcode / Sku...',
                          controller: logic.lookupCtrl,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => logic.lookUp(),
                          prefix: Icon(Icons.search,
                              size: 18, color: InvStyle.muted),
                          suffix: IconButton(
                            icon: Icon(Icons.qr_code_scanner,
                                size: 18, color: InvStyle.muted),
                            onPressed: logic.scanBarcode,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        // InvField reserves 10px for its error line; keep the
                        // button vertically aligned with the input.
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InvPrimaryButton(
                          text: 'Look Up',
                          onPressed: logic.lookUp,
                        ),
                      ),
                    ],
                  ),
                  if (logic.lookupSearched) LookupResultCard(logic: logic),
                  const SizedBox(height: 6),
                  const Text('Equipment',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  FromTheFieldCard(logic: logic),
                  const SizedBox(height: 14),
                  PillTabGroup<InventoryTab>(
                    items: InventoryTab.values.map((tab) => PillTabItem<InventoryTab>(
                        value: tab,
                        label: tab.label,
                      ),
                    ).toList(),
                    selectedValue: logic.tab,
                    onChanged: logic.selectTab,
                    style: PillTabStyle.filled,
                  ),
                  const SizedBox(height: 12),
                  _TabBody(logic: logic),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TabBody extends StatelessWidget {
  final MaterialInventoryLogic logic;

  const _TabBody({required this.logic});

  @override
  Widget build(BuildContext context) {
    switch (logic.tab) {
      case InventoryTab.onHand:
        return StockByLocationCard(logic: logic);
      case InventoryTab.receive:
        return ReceiveStockForm(logic: logic);
      case InventoryTab.issue:
        return IssueStockForm(logic: logic);
      case InventoryTab.transfer:
        return TransferStockForm(logic: logic);
      case InventoryTab.adjust:
        return AdjustStockForm(logic: logic);
      case InventoryTab.reports:
        return ReportsPanel(logic: logic);
      case InventoryTab.labels:
        return LabelsPanel(logic: logic);
    }
  }
}
