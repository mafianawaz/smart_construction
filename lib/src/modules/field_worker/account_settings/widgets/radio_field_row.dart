import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';

/// Label with a radio-style selection indicator — the "checkbox row"
/// counterpart to [ToggleFieldRow], with the same dual mode:
///
/// - [standalone] `true`: draws its own grey rounded card — use for a
///   single radio option that stands alone on the screen.
/// - [standalone] `false` (default): renders as a plain row with no
///   background — use for several options grouped together inside one
///   shared `SettingsGroupCard` (e.g. each frequency inside
///   "CRM Contact Reminders").
class RadioFieldRow extends StatelessWidget {
  const RadioFieldRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.standalone = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? subtitle;
  final bool standalone;

  @override
  Widget build(BuildContext context) {
    final row = InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            size: 18,
            color: selected ? AppColors.primaryOrange : AppColors.textMuted,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 13, color: AppColors.textDark)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (!standalone) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
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
