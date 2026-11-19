import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../../../field_worker/my_task/widget/pill_chip.dart';
import '../models/client_organization_model.dart';

class ClientOrganizationCard extends StatelessWidget {
  final ClientOrganizationModel client;

  const ClientOrganizationCard({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final isActive = client.status == ClientOrgStatus.active;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      client.code,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.fieldFill, height: 1),
          const SizedBox(height: 10),
          _InfoRow(
            label: 'Status',
            trailing: WhitePillChip(
              label: client.status.label,
              color: isActive ? AppColors.statusChip : AppColors.primaryOrangeDark,
              showAvatar: true,
            ),
          ),
          const SizedBox(height: 10),
          _InfoRow(
            label: 'Auto-Approve',
            trailing:  WhitePillChip(
              label: client.autoApproveEnabled ? 'Enabled' : 'Disabled',
              color: client.autoApproveEnabled
                  ? AppColors.statusChip
                  : AppColors.primaryOrangeDark,
              showAvatar: true,
            ),
          ),
          const SizedBox(height: 10),
          _InfoRow(
            label: 'Notifications',
            trailingText: client.notificationsEnabled ? 'On' : 'Off',
            trailingTextColor: client.notificationsEnabled
                ? AppColors.redColor
                : AppColors.textMuted,
          ),
          const SizedBox(height: 10),
          _InfoRow(
            label: 'Enrolled',
            trailingText: client.formattedEnrolledDate,
          ),
        ],
      ),
    );
  }
}

/// Small pill with a leading status dot (e.g. "• Active").
///
/// NOTE: `PillChip`'s confirmed API has no `icon`/leading-dot slot, so this
/// is a standalone widget copying `PillChip`'s visual style rather than an
/// extension of it. Consider adding an optional `leadingDot` param to the
/// shared `PillChip` if this pattern recurs elsewhere.
class _StatusDotPill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusDotPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final Widget? trailing;
  final String? trailingText;
  final Color? trailingTextColor;

  const _InfoRow({
    required this.label,
    this.trailing,
    this.trailingText,
    this.trailingTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
        trailing ??
            Text(
              trailingText ?? '',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: trailingTextColor ?? Colors.black87,
              ),
            ),
      ],
    );
  }
}
