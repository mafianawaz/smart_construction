import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';
import '../models/equipment_models.dart';
import 'equipment_palette.dart';

/// "Equipment Details" card on the Overview tab: a 2-column grid of
/// TYPE / CURRENT HOURS / MAKE / MODEL / YEAR / SERIAL NUMBER.
class EquipmentDetailsCard extends StatelessWidget {
  const EquipmentDetailsCard({super.key, required this.equipment});

  final EquipmentModel equipment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EquipmentPalette.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: EquipmentPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Equipment Details',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: EquipmentPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: AppColors.fieldBorder,),
          const SizedBox(height: 10),
          _FieldRow(
            left: _Field(label: 'TYPE', value: equipment.type),
            right: _Field(
              label: 'CURRENT HOURS',
              value: equipment.hoursLabel,
              icon: Icons.schedule,
              iconColor: EquipmentPalette.orange,
              emphasize: true,
            ),
          ),
          const SizedBox(height: 14),
          _FieldRow(
            left: _Field(label: 'MAKE', value: equipment.make),
            right: _Field(label: 'MODEL', value: equipment.model),
          ),
          const SizedBox(height: 14),
          _FieldRow(
            left: _Field(
                label: 'YEAR', value: equipment.year?.toString() ?? '-'),
            right: _Field(
              label: 'SERIAL NUMBER',
              value: (equipment.serialNumber ?? '').isEmpty
                  ? '-'
                  : equipment.serialNumber!,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.left, required this.right});
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Expanded(child: left), Expanded(child: right)],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 0.4,
            color: EquipmentPalette.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: emphasize ? 12 : 12,
                  fontWeight: FontWeight.w600,
                  color: EquipmentPalette.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
