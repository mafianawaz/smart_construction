import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

/// White bordered card with a bold title, an optional muted subtitle and an
/// optional trailing widget (the "Show" button, the "Reset" link). Shared
/// by every Financials sub-tab.
class FinancialsCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final List<Widget> children;
  final EdgeInsetsGeometry margin;

  const FinancialsCard({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    this.children = const [],
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Row(
              children: [
                Expanded(
                  child: Text(title!,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
          if (title != null || subtitle != null) const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

/// "Title ........ [Show]" row card that expands in place — "Takeoff Cost
/// by Location" and "Cost by Location". The reference only shows the
/// collapsed state, so [emptyMessage] is a guess for the expanded body.
class ShowToggleCard extends StatelessWidget {
  final String title;
  final bool expanded;
  final VoidCallback onToggle;
  final String emptyMessage;

  const ShowToggleCard({
    super.key,
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return FinancialsCard(
      title: title,
      trailing: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onToggle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            expanded ? 'Hide' : 'Show',
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
          ),
        ),
      ),
      children: [
        if (expanded)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(emptyMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ),
          ),
      ],
    );
  }
}
