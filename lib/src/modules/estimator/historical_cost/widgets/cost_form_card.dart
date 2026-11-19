import 'package:flutter/material.dart';
import 'cost_colors.dart';

/// White bordered section card used to group form fields.
class CostFormCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const CostFormCard({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CostColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
          ],
          ...children,
        ],
      ),
    );
  }
}

/// Two fields side by side with the standard gap.
class CostFieldRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  const CostFieldRow({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          const SizedBox(width: 12),
          Expanded(child: right),
        ],
      );
}
