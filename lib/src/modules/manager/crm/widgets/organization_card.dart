import 'package:flutter/material.dart';

import '../models/crm_models.dart';
import 'crm_controls.dart';
import 'crm_palette.dart';

/// One row of the Organizations list: status dot + name, type tag,
/// location / category / owner lines, status text and View / Edit actions.
class OrganizationCard extends StatelessWidget {
  final OrganizationModel org;
  final VoidCallback onView;
  final VoidCallback onEdit;

  const OrganizationCard({
    super.key,
    required this.org,
    required this.onView,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = org.isActive ? CrmPalette.success : CrmPalette.textFaint;
    final category = org.category;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CrmPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  org.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: CrmPalette.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          CrmTag(label: org.type.label),
          const SizedBox(height: 8),
          _InfoRow(icon: Icons.location_on_outlined, text: org.locationLabel),
          if (category != null && category.trim().isNotEmpty)
            _InfoRow(icon: Icons.inventory_2_outlined, text: category),
          _InfoRow(icon: Icons.person_outline, text: org.ownerLine),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                org.status.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
              const Spacer(),
              CrmSmallButton(label: 'View', onTap: onView),
              const SizedBox(width: 6),
              CrmSmallButton(label: 'Edit', onTap: onEdit),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: CrmPalette.textMuted),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11.5, color: CrmPalette.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
