import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/crew_models.dart';
import 'crew_buttons.dart';
import 'crew_card.dart';
import 'crew_palette.dart';

/// Populated list row: code + status tags, name/trade, crew counts and the
/// auto-computed daily cost. Edit and delete sit top-right.
class CrewTemplateCard extends StatelessWidget {
  final CrewTemplateModel template;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CrewTemplateCard({
    super.key,
    required this.template,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final perUnit = template.costPerUnit;
    return CrewCard(
      onTap: onEdit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _tag(template.code, AppColors.primaryOrange),
              const SizedBox(width: 6),
              _tag(
                template.isActive ? 'Active' : 'Inactive',
                template.isActive ? CrewPalette.activeFg : AppColors.textMuted,
              ),
              const Spacer(),
              CrewIconAction(icon: Icons.edit_outlined, onTap: onEdit),
              const SizedBox(width: 6),
              CrewIconAction(
                icon: Icons.delete_outline_rounded,
                onTap: onDelete,
                destructive: true,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            template.name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: CrewPalette.ink,
            ),
          ),
          if (template.tradeType.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              template.tradeType,
              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
          const Divider(height: 22, color: CrewPalette.divider),
          Row(
            children: [
              _figure('WORKERS', '${template.headcount}'),
              _figure('EQUIPMENT', '${template.equipment.length}'),
              _figure('DAILY COST', formatCrewUsd(template.dailyCost),
                  accent: true),
              if (perUnit != null)
                _figure(
                  'PER ${template.productionUnit.isEmpty ? 'UNIT' : template.productionUnit}',
                  formatCrewUsd(perUnit),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tag(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color, width: 0.8),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: color),
        ),
      );

  Widget _figure(String label, String value, {bool accent = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              letterSpacing: 0.4,
              color: accent ? AppColors.primaryOrange : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: accent ? AppColors.primaryOrange : CrewPalette.ink,
            ),
          ),
        ],
      ),
    );
  }
}
