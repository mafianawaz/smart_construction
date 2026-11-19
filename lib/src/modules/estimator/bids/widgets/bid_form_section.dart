import 'package:flutter/material.dart';

/// Same visual role as the app's existing `SectionCard` — a titled
/// card wrapping a column of fields. Kept local to this feature for
/// now since it also supports [trailing] (used by the CRM Integration
/// section's "Link to CRM" action) and a [muted] background variant
/// (the CRM card renders on a shaded background in the reference).
///
/// NOTE: if `SectionCard` already supports a trailing slot, prefer
/// that widget instead and delete this one — flagged in
/// NOTES_CREATE_BID.md.
class BidFormSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool muted;
  final List<Widget> children;

  const BidFormSection({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.muted = false,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: muted ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              if (trailing != null) trailing!,
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
