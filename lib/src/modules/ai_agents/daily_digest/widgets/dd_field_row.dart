import 'package:flutter/material.dart';

import 'dd_palette.dart';

/// Label / value row used inside conflict and item cards. Pass [text] for a
/// plain value or [child] for a custom widget (chips, links, buttons).
class DdFieldRow extends StatelessWidget {
  final String label;
  final String? text;
  final Widget? child;

  const DdFieldRow({
    super.key,
    required this.label,
    this.text,
    this.child,
  }) : assert(text != null || child != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: DdPalette.textMuted,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: child ??
                Text(
                  text!,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: DdPalette.textPrimary,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
