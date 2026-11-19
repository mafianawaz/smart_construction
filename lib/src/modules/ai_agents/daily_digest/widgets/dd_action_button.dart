import 'package:flutter/material.dart';

import 'dd_palette.dart';

/// Outlined, left-aligned action button. Purely visual when [onTap] is null so
/// it can sit inside a PopupMenuButton (the Snooze menu).
class DdActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool trailingChevron;
  final bool disabled;

  const DdActionButton({
    super.key,
    required this.label,
    this.onTap,
    this.trailingChevron = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final visual = Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: disabled ? DdPalette.surfaceMuted : DdPalette.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DdPalette.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                color:
                    disabled ? DdPalette.textMuted : DdPalette.textPrimary,
              ),
            ),
          ),
          if (trailingChevron)
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: DdPalette.textSecondary,
            ),
        ],
      ),
    );

    if (onTap == null || disabled) return visual;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: visual,
    );
  }
}

/// Lays buttons out two per row with equal widths.
class DdActionGrid extends StatelessWidget {
  final List<Widget> children;

  const DdActionGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += 2) {
      final second = i + 1 < children.length ? children[i + 1] : null;
      rows.add(
        Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
          child: Row(
            children: [
              Expanded(child: children[i]),
              const SizedBox(width: 8),
              Expanded(child: second ?? const SizedBox.shrink()),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}
