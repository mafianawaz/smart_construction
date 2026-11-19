import 'package:flutter/material.dart';

import '../../models/project_enums.dart';

/// Tinted notice at the top of Warranty / Maintenance ("Handover Pending",
/// "Handover In Progress"): icon, bold title, small body copy.
class HandoverBanner extends StatelessWidget {
  final HandoverTone tone;
  final String title;
  final String body;

  const HandoverBanner({
    super.key,
    required this.tone,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final isInfo = tone == HandoverTone.info;
    final accent = isInfo ? const Color(0xFF2563EB) : const Color(0xFFD97706);
    final bg = isInfo ? const Color(0xFFEFF6FF) : const Color(0xFFFFF7E6);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withAlpha(70)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isInfo ? Icons.shield_outlined : Icons.info_outline, size: 16, color: accent),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: accent)),
                const SizedBox(height: 3),
                Text(body, style: TextStyle(fontSize: 10, color: accent.withAlpha(220))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
