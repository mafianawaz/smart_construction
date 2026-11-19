import 'package:flutter/material.dart';
import '../logic.dart';
import '../models/inventory_models.dart';
import 'inv_buttons_tabs.dart';
import 'inv_inputs.dart';
import 'inv_style.dart';
import 'stock_form_state.dart';

const _decimal = TextInputType.numberWithOptions(decimal: true);

List<InvOption<String>> _materialOptions(MaterialInventoryLogic l) =>
    [for (final m in l.materials) InvOption(m.id, m.dropdownLabel)];

List<InvOption<String>> _locationOptions(MaterialInventoryLogic l) =>
    [for (final x in l.locations) InvOption(x.id, x.dropdownLabel)];

Widget _prereq(MaterialInventoryLogic l) {
  if (l.materials.isEmpty) {
    return const InvPrereqNotice(
        message: 'Add a material first (Material button above).');
  }
  if (l.locations.isEmpty) {
    return const InvPrereqNotice(
        message: 'Add a location first (Location button above).');
  }
  return const SizedBox.shrink();
}

/// Receive Stock
class ReceiveStockForm extends StatelessWidget {
  final MaterialInventoryLogic logic;

  const ReceiveStockForm({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final f = logic.receiveForm;
    return InvCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InvCardTitle(
              icon: Icons.file_download_outlined, title: 'Receive Stock'),
          _prereq(logic),
          const SizedBox(height: 12),
          InvRow(
            left: InvDropdown<String>(
              label: 'Material',
              hint: 'Select material',
              value: f.materialId,
              options: _materialOptions(logic),
              errorText: f.errors['material'],
              onChanged: (v) => logic.setMaterial(f, v),
            ),
            right: InvDropdown<String>(
              label: 'Location',
              hint: 'Select location',
              value: f.locationId,
              options: _locationOptions(logic),
              errorText: f.errors['location'],
              onChanged: (v) => logic.setLocation(f, v),
            ),
          ),
          InvRow(
            left: InvField(
              label: 'Quantity',
              hint: '0',
              controller: f.qty,
              keyboardType: _decimal,
              inputFormatters: invNumberFormatters(),
              errorText: f.errors['qty'],
              onChanged: (_) => logic.clearError(f, 'qty'),
            ),
            right: InvField(
              label: 'Unit Cost',
              hint: '\$0.00',
              controller: f.unitCost,
              keyboardType: _decimal,
              inputFormatters: invNumberFormatters(),
            ),
          ),
          InvRow(
            left: InvDropdown<String>(
              label: 'Purchase Order (optional)',
              hint: '- No PO -',
              value: f.purchaseOrder,
              options: [
                const InvOption(kNoPurchaseOrder, '- No PO -'),
                for (final po in logic.purchaseOrderOptions) InvOption(po, po),
              ],
              onChanged: (v) => logic.setPurchaseOrder(f, v),
            ),
            right: InvField(
              label: 'Reference #',
              hint: 'Packing slip / MR-#',
              controller: f.reference,
            ),
          ),
          InvField(
            label: 'Notes',
            hint: 'Add notes about this receive...',
            controller: f.notes,
            maxLines: 4,
          ),
          InvPrimaryButton(text: 'Post receive', onPressed: logic.postReceive),
        ],
      ),
    );
  }
}

/// Issue to Project
class IssueStockForm extends StatelessWidget {
  final MaterialInventoryLogic logic;

  const IssueStockForm({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final f = logic.issueForm;
    return InvCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InvCardTitle(
              icon: Icons.file_upload_outlined, title: 'Issue to Project'),
          _prereq(logic),
          const SizedBox(height: 12),
          InvRow(
            left: InvDropdown<String>(
              label: 'Material',
              hint: 'Select material',
              value: f.materialId,
              options: _materialOptions(logic),
              errorText: f.errors['material'],
              onChanged: (v) => logic.setMaterial(f, v),
            ),
            right: InvDropdown<String>(
              label: 'Location',
              hint: 'Select location',
              value: f.locationId,
              options: _locationOptions(logic),
              errorText: f.errors['location'],
              onChanged: (v) => logic.setLocation(f, v),
            ),
          ),
          InvRow(
            left: InvField(
              label: 'Quantity',
              hint: '',
              controller: f.qty,
              keyboardType: _decimal,
              inputFormatters: invNumberFormatters(),
              errorText: f.errors['qty'],
              onChanged: (_) => logic.clearError(f, 'qty'),
            ),
            right: InvDropdown<String>(
              label: 'Project',
              hint: 'Select project',
              value: f.project,
              options: [
                for (final p in logic.projectOptions) InvOption(p, p),
              ],
              errorText: f.errors['project'],
              onChanged: (v) => logic.setProject(f, v),
            ),
          ),
          InvRow(
            left: InvField(label: 'Cost Code', hint: '', controller: f.costCode),
            right: InvField(
              label: 'Reference #',
              hint: 'Packing slip / MR-#',
              controller: f.reference,
            ),
          ),
          InvField(label: 'Notes', hint: '', controller: f.notes, maxLines: 4),
          InvPrimaryButton(text: 'Post issue', onPressed: logic.postIssue),
        ],
      ),
    );
  }
}

/// Transfer Between Locations
class TransferStockForm extends StatelessWidget {
  final MaterialInventoryLogic logic;

  const TransferStockForm({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final f = logic.transferForm;
    return InvCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InvCardTitle(
              icon: Icons.crop_free, title: 'Transfer Between Locations'),
          _prereq(logic),
          if (logic.locations.length == 1)
            const InvPrereqNotice(
                message: 'Add a second location to transfer between.'),
          const SizedBox(height: 12),
          InvRow(
            left: InvDropdown<String>(
              label: 'Material',
              hint: 'Select material',
              value: f.materialId,
              options: _materialOptions(logic),
              errorText: f.errors['material'],
              onChanged: (v) => logic.setMaterial(f, v),
            ),
            right: InvDropdown<String>(
              label: 'From Location',
              hint: 'Select location',
              value: f.locationId,
              options: _locationOptions(logic),
              errorText: f.errors['location'],
              onChanged: (v) => logic.setLocation(f, v),
            ),
          ),
          InvRow(
            left: InvDropdown<String>(
              label: 'To Location',
              hint: 'Destination',
              value: f.toLocationId,
              options: _locationOptions(logic),
              errorText: f.errors['toLocation'],
              onChanged: (v) => logic.setToLocation(f, v),
            ),
            right: InvField(
              label: 'Quantity',
              hint: '',
              controller: f.qty,
              keyboardType: _decimal,
              inputFormatters: invNumberFormatters(),
              errorText: f.errors['qty'],
              onChanged: (_) => logic.clearError(f, 'qty'),
            ),
          ),
          InvField(
            label: 'Reference #',
            hint: 'Packing slip / MR-#',
            controller: f.reference,
          ),
          InvField(label: 'Notes', hint: '', controller: f.notes, maxLines: 4),
          InvPrimaryButton(text: 'Post transfer', onPressed: logic.postTransfer),
        ],
      ),
    );
  }
}

/// Adjust (with reason). Labels are orange in the Figma, so [labelColor] is
/// passed on every field.
class AdjustStockForm extends StatelessWidget {
  final MaterialInventoryLogic logic;

  const AdjustStockForm({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final f = logic.adjustForm;
    final c = InvStyle.orange;
    return InvCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InvCardTitle(
            icon: Icons.warning_amber_rounded,
            title: 'Adjust (with reason)',
            color: InvStyle.warn,
          ),
          _prereq(logic),
          const SizedBox(height: 12),
          InvDropdown<String>(
            label: 'Material',
            labelColor: c,
            hint: 'Select material',
            value: f.materialId,
            options: _materialOptions(logic),
            errorText: f.errors['material'],
            onChanged: (v) => logic.setMaterial(f, v),
          ),
          InvDropdown<String>(
            label: 'Location',
            labelColor: c,
            hint: 'Select location',
            value: f.locationId,
            options: _locationOptions(logic),
            errorText: f.errors['location'],
            onChanged: (v) => logic.setLocation(f, v),
          ),
          InvField(
            label: 'Quantity (signed: + add, - remove)',
            labelColor: c,
            hint: '',
            controller: f.qty,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: true),
            inputFormatters: invNumberFormatters(signed: true),
            errorText: f.errors['qty'],
            onChanged: (_) => logic.clearError(f, 'qty'),
          ),
          InvDropdown<AdjustReason>(
            label: 'Reason',
            labelColor: c,
            hint: 'Select reason',
            value: f.reason,
            options: [
              for (final r in AdjustReason.values) InvOption(r, r.label),
            ],
            onChanged: (v) => logic.setReason(f, v),
          ),
          InvField(
            label: 'Reference #',
            labelColor: c,
            hint: 'Packing slip / MR-#',
            controller: f.reference,
          ),
          InvField(
            label: 'Reason note (required)',
            labelColor: c,
            hint: '',
            controller: f.reasonNote,
            maxLines: 4,
            errorText: f.errors['reasonNote'],
            onChanged: (_) => logic.clearError(f, 'reasonNote'),
          ),
          InvPrimaryButton(text: 'Post adjust', onPressed: logic.postAdjust),
        ],
      ),
    );
  }
}
