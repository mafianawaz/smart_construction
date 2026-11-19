import 'package:flutter/material.dart';

/// Local titled-card wrapper for the Project Detail screen — same
/// visual role as the app's `SectionCard` (per ways-of-working.md).
/// NOTE: if `SectionCard` already supports a [trailing] slot, prefer
/// that widget instead and delete this one — flagged in
/// NOTES_PROJECTS.md.
class DetailCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final List<Widget> children;

  const DetailCard({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

/// Small "LABEL / value" pair used throughout the detail cards.
class DetailFieldPair extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const DetailFieldPair({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700, color: valueColor)),
      ],
    );
  }
}
