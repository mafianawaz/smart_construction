import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

/// Bordered card with a header (title, optional subtitle, optional chevron),
/// a hairline divider, then a body — the "Pay Applications" / "Stored
/// Materials" / "Retention Releases" / "Production Rate Benchmarks" panels.
/// When [onToggle] is given the header shows a chevron and the body hides
/// when [expanded] is false.
class PanelCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool expanded;
  final VoidCallback? onToggle;
  final Widget child;

  const PanelCard({
    super.key,
    required this.title,
    this.subtitle,
    this.expanded = true,
    this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final header = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                ],
              ],
            ),
          ),
          if (onToggle != null)
            Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 18, color: Colors.grey.shade600),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          onToggle == null ? header : InkWell(onTap: onToggle, child: header),
          if (expanded) ...[
            Divider(height: 1, color: Colors.grey.shade200),
            child,
          ],
        ],
      ),
    );
  }
}

/// Icon circle + bold-ish message + optional lighter hint, centered — the
/// body of every empty [PanelCard].
class PanelEmptyBody extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? hint;

  const PanelEmptyBody({super.key, required this.icon, required this.message, this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey.shade100,
              child: Icon(icon, size: 20, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
            if (hint != null) ...[
              const SizedBox(height: 4),
              Text(hint!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
            ],
          ],
        ),
      ),
    );
  }
}
