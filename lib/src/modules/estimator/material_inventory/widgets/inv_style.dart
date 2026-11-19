import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

/// Local style tokens for Materials Inventory.
/// Orange / muted text come from the shared [AppColors] (confirmed fields);
/// the rest are local because `AppColors.success` etc. are still unconfirmed.
class InvStyle {
  static Color get orange => AppColors.primaryOrange;
  static Color get muted => AppColors.textMuted;
  static const Color border = Color(0xFFE5E7EB);
  static const Color panel = Color(0xFFF5F6F8);
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFE8F8EF);
  static const Color peach = Color(0xFFFFF1E8);
  static const Color warn = Color(0xFFEA580C);
  static const Color danger = Color(0xFFDC2626);
}

/// White rounded card with a hairline border.
class InvCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const InvCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: InvStyle.border),
      ),
      child: child,
    );
  }
}

/// Icon + bold title used at the top of each form / panel card.
class InvCardTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;

  const InvCardTitle({
    super.key,
    required this.icon,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color ?? InvStyle.orange),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

/// Orange helper line shown on a form when it cannot be submitted yet.
class InvPrereqNotice extends StatelessWidget {
  final String message;

  const InvPrereqNotice({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: InvStyle.peach,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 16, color: InvStyle.warn),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12, color: InvStyle.warn),
            ),
          ),
        ],
      ),
    );
  }
}

/// Two fields side by side with a consistent gap.
class InvRow extends StatelessWidget {
  final Widget left;
  final Widget right;

  const InvRow({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 10),
        Expanded(child: right),
      ],
    );
  }
}
