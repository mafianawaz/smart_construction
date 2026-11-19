import 'package:flutter/material.dart';

import '../logic.dart';
import '../models/inventory_models.dart';
import 'inv_buttons_tabs.dart';
import 'inv_inputs.dart';
import 'inv_style.dart';

/// Labels tab: pick materials and produce a printable barcode / QR sheet.
class LabelsPanel extends StatelessWidget {
  final MaterialInventoryLogic logic;

  const LabelsPanel({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final shown = logic.labelMaterials;
    final selected = logic.selectedLabelIds.length;

    return Column(
      children: [
        InvCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InvCardTitle(
                  icon: Icons.print_outlined, title: 'Print Barcode / QR Labels'),
              const SizedBox(height: 6),
              Text(
                'Select materials and produce a printable PDF using your preferred label sheet. '
                'Materials without a barcode are auto-assigned one before printing.',
                style: TextStyle(fontSize: 11, color: InvStyle.muted),
              ),
              const SizedBox(height: 12),
              InvField(
                label: 'Search',
                hint: 'Filter by SKU, name, or barcode',
                controller: logic.labelSearchCtrl,
                onChanged: (_) => logic.update(),
              ),
              InvDropdown<LabelTemplate>(
                label: 'Sheet template',
                hint: 'Select template',
                value: logic.labelTemplate,
                options: [
                  for (final t in kLabelTemplates) InvOption(t, t.name),
                ],
                onChanged: logic.setLabelTemplate,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  logic.labelTemplate.description,
                  style: TextStyle(fontSize: 10, color: InvStyle.muted),
                ),
              ),
              InvDropdown<LabelSymbology>(
                label: 'Symbology',
                hint: 'Select symbology',
                value: logic.symbology,
                options: [
                  for (final s in LabelSymbology.values) InvOption(s, s.label),
                ],
                onChanged: logic.setSymbology,
              ),
              InvRow(
                left: InvField(
                  label: 'Copies / SKU',
                  hint: '1',
                  controller: logic.copiesCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: invDigitsOnly(),
                  onChanged: (_) => logic.update(),
                ),
                right: InvField(
                  label: 'Skip first',
                  hint: '0',
                  controller: logic.skipCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: invDigitsOnly(),
                  onChanged: (_) => logic.update(),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$selected selected · ${shown.length} shown',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  InvPrimaryButton(
                    text: 'Print PDF',
                    icon: Icons.print_outlined,
                    onPressed: selected == 0 ? null : logic.printLabels,
                  ),
                ],
              ),
              if (selected > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${logic.totalLabels} labels on ${logic.sheetsNeeded} sheet(s)',
                    style: TextStyle(fontSize: 10, color: InvStyle.muted),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        InvCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('Materials List',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                  if (shown.isNotEmpty)
                    GestureDetector(
                      onTap: () => logic.selectAllLabels(shown),
                      child: Text(
                        shown.every(
                                (m) => logic.selectedLabelIds.contains(m.id))
                            ? 'Clear'
                            : 'Select all',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: InvStyle.orange),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              if (shown.isEmpty)
                Text('No materials match your search.',
                    style: TextStyle(fontSize: 12, color: InvStyle.muted))
              else
                for (final m in shown)
                  _MaterialLabelTile(
                    material: m,
                    selected: logic.selectedLabelIds.contains(m.id),
                    onChanged: (v) => logic.toggleLabel(m.id, v),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MaterialLabelTile extends StatelessWidget {
  final InventoryMaterial material;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const _MaterialLabelTile({
    required this.material,
    required this.selected,
    required this.onChanged,
  });

  Widget _line(String k, Widget v) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          children: [
            Text(k, style: TextStyle(fontSize: 11, color: InvStyle.muted)),
            const Spacer(),
            v,
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!selected),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected ? InvStyle.orange : InvStyle.border),
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: Checkbox(
                    value: selected,
                    activeColor: InvStyle.orange,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (v) => onChanged(v ?? false),
                  ),
                ),
                const SizedBox(width: 10),
                Text(material.sku,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: InvStyle.panel,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(material.uom,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            _line('Name',
                Text(material.name, style: const TextStyle(fontSize: 12))),
            _line(
              'Barcode',
              Text(
                material.barcode.isEmpty ? 'Auto-assigned' : material.barcode,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: material.barcode.isEmpty
                      ? InvStyle.muted
                      : InvStyle.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
