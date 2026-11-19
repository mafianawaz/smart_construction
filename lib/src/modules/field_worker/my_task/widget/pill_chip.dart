import 'package:flutter/material.dart';

/// Small rounded label pill — background = [color] at full or reduced
/// opacity, text = [color] or white. Used for status/priority badges
/// throughout the task flow (and reusable anywhere else a colored tag
/// is needed).
class PillChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;
  final double fontSize;

  const PillChip({
    super.key,
    required this.label,
    required this.color,
    this.filled = true,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? color : color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: filled ? Colors.white : color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}


class WhitePillChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;
  final bool showAvatar;
  final double fontSize;

  const WhitePillChip({
    super.key,
    required this.label,
    required this.color,
    this.filled = false,
    this.showAvatar = false,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: filled ? color : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if (showAvatar) ...[
            CircleAvatar(
              radius: 3,
              backgroundColor: color,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: filled ? Colors.white : color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}