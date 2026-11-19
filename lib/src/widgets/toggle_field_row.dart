import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import 'custom_switch.dart';

/// Label (+ optional subtitle) with a toggle switch.
///
/// [standalone] controls the background:
/// - `true` (default): the row draws its own grey rounded card — use this
///   when the toggle stands alone on the screen (e.g. "Failure Alerts",
///   "Integration Sync").
/// - `false`: the row renders as a plain row with no background/margin —
///   use this when several rows sit together inside one shared
///   [SettingsGroupCard] (e.g. each channel inside "Delivery Channels").
class ToggleFieldRow extends StatelessWidget {
  const ToggleFieldRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.standalone = true,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;
  final bool standalone;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ],
          ),
        ),
        CustomToggleButton(
          initialValue: value,
          onChanged: onChanged,
        ),
      ],
    );

    if (!standalone) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: row,
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        child: row,
      ),
    );
  }
}
