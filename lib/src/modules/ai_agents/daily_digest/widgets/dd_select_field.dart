import 'package:flutter/material.dart';

import 'dd_palette.dart';

/// Bordered dropdown-looking field. Purely visual when [onTap] is null, so it
/// can be wrapped in a PopupMenuButton (role selector) or given an onTap
/// (date picker).
///
/// [inlineLabel] puts the label in the same line as the value
/// ("Date: Mon 12 Oct 2026 · (90-day history)"); otherwise the label sits
/// above the box.
class DdSelectField extends StatelessWidget {
  final String label;
  final String value;
  final bool inlineLabel;
  final VoidCallback? onTap;

  const DdSelectField({
    super.key,
    required this.label,
    required this.value,
    this.inlineLabel = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: DdPalette.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DdPalette.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: inlineLabel
                ? Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$label ',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: DdPalette.textMuted,
                          ),
                        ),
                        TextSpan(
                          text: value,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: DdPalette.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: DdPalette.textPrimary,
                    ),
                  ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: DdPalette.textSecondary,
          ),
        ],
      ),
    );

    final content = inlineLabel
        ? box
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: DdPalette.textMuted,
                ),
              ),
              const SizedBox(height: 6),
              box,
            ],
          );

    if (onTap == null) return content;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }
}
