import 'package:flutter/material.dart';

import '../models/permit_models.dart';
import 'permit_expiry_pill.dart';
import 'permits_palette.dart';

/// "Expiring Within 30 Days" card: warning header + divided permit tiles.
class ExpiringPermitsCard extends StatelessWidget {
  final int windowDays;
  final List<PermitModel> permits;
  final ValueChanged<PermitModel> onTap;

  const ExpiringPermitsCard({
    super.key,
    required this.windowDays,
    required this.permits,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      decoration: BoxDecoration(
        color: PermitsPalette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PermitsPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expiring Within $windowDays Days',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: PermitsPalette.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_amber_rounded,
                  size: 20, color: PermitsPalette.warningIcon),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Permits that require attention due to upcoming expiration dates',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: PermitsPalette.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < permits.length; i++) ...[
            _PermitTile(permit: permits[i], onTap: () => onTap(permits[i])),
            if (i != permits.length - 1)
              const Divider(height: 1, color: PermitsPalette.border),
          ],
        ],
      ),
    );
  }
}

class _PermitTile extends StatelessWidget {
  final PermitModel permit;
  final VoidCallback onTap;

  const _PermitTile({required this.permit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    permit.displayTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      color: PermitsPalette.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    permit.projectName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: PermitsPalette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            PermitExpiryPill(permit: permit),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded,
                size: 20, color: PermitsPalette.textMuted),
          ],
        ),
      ),
    );
  }
}
