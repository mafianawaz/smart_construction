import 'package:flutter/material.dart';

import '../models/time_clock_models.dart';
import 'tc_palette.dart';

/// Small round count badge.
class TcCountBadge extends StatelessWidget {
  const TcCountBadge({super.key, required this.count, this.color = TcPalette.orange, this.size = 16});

  final int count;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: size, minHeight: size),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: count > 9 ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: count > 9 ? BorderRadius.circular(size) : null),
      child: Text(
        '$count',
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }
}

/// Horizontally scrollable underline tab bar with optional badges.
class TcTabBar extends StatelessWidget {
  const TcTabBar({
    super.key,
    required this.current,
    required this.onChanged,
    required this.badges,
  });

  final TimeClockTab current;
  final ValueChanged<TimeClockTab> onChanged;

  /// Badge count + colour per tab; absent or 0 hides the badge.
  final Map<TimeClockTab, ({int count, Color color})> badges;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: TcPalette.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            for (final tab in TimeClockTab.values)
              _TabItem(
                label: tab.label,
                selected: tab == current,
                badge: badges[tab],
                onTap: () => onChanged(tab),
              ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ({int count, Color color})? badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? TcPalette.orange : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? TcPalette.orange : TcPalette.muted,
              ),
            ),
            if (badge != null && badge!.count > 0) ...[
              const SizedBox(width: 4),
              TcCountBadge(count: badge!.count, color: badge!.color, size: 14),
            ],
          ],
        ),
      ),
    );
  }
}

/// Section title row: "Active Shifts (1)" with optional search toggle.
class TcSectionHeader extends StatelessWidget {
  const TcSectionHeader({
    super.key,
    required this.title,
    required this.count,
    this.onSearchTap,
    this.searchOpen = false,
    this.leadingIcon,
    this.countInline = false,
  });

  final String title;
  final int count;
  final VoidCallback? onSearchTap;
  final bool searchOpen;
  final IconData? leadingIcon;

  /// true → "Title (3)" text; false → orange badge next to the title.
  final bool countInline;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 18, color: TcPalette.orange),
          const SizedBox(width: 6),
        ],
        Text(
          countInline ? '$title ($count)' : title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TcPalette.text),
        ),
        if (!countInline) ...[
          const SizedBox(width: 8),
          TcCountBadge(count: count, size: 18),
        ],
        const Spacer(),
        if (onSearchTap != null)
          InkWell(
            onTap: onSearchTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: searchOpen ? TcPalette.orangeBg : TcPalette.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                searchOpen ? Icons.close : Icons.search,
                size: 18,
                color: searchOpen ? TcPalette.orange : TcPalette.muted,
              ),
            ),
          ),
      ],
    );
  }
}


/// Outlined role chip, e.g. FIELD_WORKER.
class TcRoleChip extends StatelessWidget {
  const TcRoleChip({super.key, required this.role, this.purple = false});

  final String role;
  final bool purple;

  @override
  Widget build(BuildContext context) {
    final color = purple ? TcPalette.purple : const Color(0xFF2563EB);
    final bg = purple ? TcPalette.purpleBg : const Color(0xFFEFF6FF);
    final border = purple ? TcPalette.purpleBorder : const Color(0xFFBFDBFE);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: border),
      ),
      child: Text(
        role,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

/// Icon + text info row used in every card.
class TcInfoRow extends StatelessWidget {
  const TcInfoRow({super.key, required this.icon, required this.child});

  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: TcPalette.muted),
          const SizedBox(width: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class TcInfoText extends StatelessWidget {
  const TcInfoText(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(fontSize: 11, color: TcPalette.muted));
}

/// Solid action button (Approve / Reject / Adapt).
class TcActionButton extends StatelessWidget {
  const TcActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.background,
    this.foreground = Colors.white,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final Color background;
  final Color foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14),
              const SizedBox(width: 4),
            ],
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
