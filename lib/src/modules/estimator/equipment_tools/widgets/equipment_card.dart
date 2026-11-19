import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../models/equipment_models.dart';
import 'equipment_palette.dart';

/// One equipment row card: icon, name/subtitle, location tag, kebab menu,
/// and a bottom row of type chip, hours chip and status pill.
/// Screen-agnostic: used on the list and again at the bottom of Overview.
class EquipmentCard extends StatelessWidget {
  const EquipmentCard({
    super.key,
    required this.equipment,
    this.onTap,
    this.onMenuTap,
  });

  final EquipmentModel equipment;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EquipmentPalette.card,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: EquipmentPalette.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: EquipmentPalette.chipFill,
                    child: const Icon(Icons.local_shipping_outlined,
                        size: 15, color: EquipmentPalette.textMuted),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          equipment.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: EquipmentPalette.textPrimary,
                          ),
                        ),
                        Text(
                          equipment.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11, color: EquipmentPalette.textMuted),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onMenuTap,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8, bottom: 4),
                          child: Icon(Icons.more_vert, size: 18, color: EquipmentPalette.textMuted),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _LocationTag(count: equipment.locationCount),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Divider(height: 1, color: AppColors.fieldBorder),
              SizedBox(height: 10,),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _TextChip(label: equipment.type),
                  _TextChip(
                    label: equipment.hoursLabel,
                    icon: Icons.schedule,
                  ),
                  _StatusPill(status: equipment.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationTag extends StatelessWidget {
  const _LocationTag({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: EquipmentPalette.chipFill,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Location: $count',
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: EquipmentPalette.textPrimary,
        ),
      ),
    );
  }
}

class _TextChip extends StatelessWidget {
  const _TextChip({required this.label, this.icon});
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: EquipmentPalette.chipFill,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: EquipmentPalette.textMuted),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: const TextStyle(
                fontSize: 9, color: EquipmentPalette.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});
  final EquipmentStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: status.color,
        ),
      ),
    );
  }
}
