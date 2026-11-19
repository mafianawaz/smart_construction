import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';

/// Wraps a set of rows (toggles, radios, etc.) in one shared grey card with
/// an optional bold header — e.g. "Delivery Channels" containing five
/// `ToggleFieldRow(standalone: false)` children, or "CRM Contact Reminders"
/// containing several `RadioFieldRow(standalone: false)` children.
///
/// This is the "grouped" counterpart to a standalone `ToggleFieldRow` /
/// `RadioFieldRow` — use this instead of giving every child row its own
/// card, which would nest a box inside a box.
class SettingsGroupCard extends StatelessWidget {
  const SettingsGroupCard({super.key, this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
            const SizedBox(height: 2),
          ],
          ...children,
        ],
      ),
    );
  }
}
