import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import '../widgets/inv_buttons_tabs.dart';
import '../widgets/inv_inputs.dart';
import '../widgets/inv_style.dart';
import 'logic.dart';

/// New Material / SKU form. Pops with the created `InventoryMaterial`.
class NewMaterialView extends StatelessWidget {
  final Set<String> existingSkus;
  final Set<String> existingBarcodes;

  const NewMaterialView({
    super.key,
    required this.existingSkus,
    required this.existingBarcodes,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewMaterialLogic>(
      init: NewMaterialLogic(
        existingSkus: existingSkus,
        existingBarcodes: existingBarcodes,
      ),
      builder: (logic) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppPrimaryBar(
            title: 'New Material / SKU',
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
                    'Add a new material or SKU item to your inventory catalog.',
                    style: TextStyle(fontSize: 12, color: InvStyle.muted),
                  ),
                  const SizedBox(height: 16),
                  InvRow(
                    left: InvField(
                      label: 'SKU',
                      required: true,
                      hint: '',
                      controller: logic.skuCtrl,
                      autofocus: true,
                      errorText: logic.errors['sku'],
                      onChanged: (_) => logic.clearError('sku'),
                    ),
                    right: InvField(
                      label: 'Barcode / QR',
                      hint: 'Scan or enter',
                      controller: logic.barcodeCtrl,
                      errorText: logic.errors['barcode'],
                      onChanged: (_) => logic.clearError('barcode'),
                      suffix: IconButton(
                        icon: Icon(Icons.qr_code_scanner,
                            size: 18, color: InvStyle.muted),
                        onPressed: logic.scanBarcode,
                      ),
                    ),
                  ),
                  InvField(
                    label: 'Name',
                    required: true,
                    hint: 'e.g., Concrete mix, Grade A',
                    controller: logic.nameCtrl,
                    errorText: logic.errors['name'],
                    onChanged: (_) => logic.clearError('name'),
                  ),
                  InvRow(
                    left: InvDropdown<String>(
                      label: 'UOM',
                      hint: 'EA',
                      value: logic.uom,
                      options: [
                        for (final u in logic.uoms) InvOption(u, u),
                      ],
                      onChanged: logic.setUom,
                    ),
                    right: InvDropdown<String>(
                      label: 'Category',
                      hint: 'Select category',
                      value: logic.category,
                      options: [
                        for (final c in logic.categories) InvOption(c, c),
                      ],
                      onChanged: logic.setCategory,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: InvStyle.panel,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: InvStyle.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Inventory Metrics',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        InvField(
                          label: 'Unit Cost (\$)',
                          hint: '0.00',
                          controller: logic.unitCostCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: invNumberFormatters(),
                          errorText: logic.errors['unitCost'],
                          onChanged: (_) => logic.clearError('unitCost'),
                        ),
                        InvRow(
                          left: InvField(
                            label: 'Reorder Point',
                            hint: 'Min Level',
                            controller: logic.reorderPointCtrl,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            inputFormatters: invNumberFormatters(),
                            errorText: logic.errors['reorderPoint'],
                            onChanged: (_) => logic.clearError('reorderPoint'),
                          ),
                          right: InvField(
                            label: 'Reorder Qty',
                            hint: 'Quantity',
                            controller: logic.reorderQtyCtrl,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            inputFormatters: invNumberFormatters(),
                            errorText: logic.errors['reorderQty'],
                            onChanged: (_) => logic.clearError('reorderQty'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  InvPrimaryButton(
                    text: 'Create',
                    fullWidth: true,
                    onPressed: logic.create,
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
