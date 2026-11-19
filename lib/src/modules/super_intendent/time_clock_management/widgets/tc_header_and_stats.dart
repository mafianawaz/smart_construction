import 'package:flutter/material.dart';

import 'tc_palette.dart';

/// Back button + title + subtitle.
class TcHeader extends StatelessWidget {
  const TcHeader({super.key, required this.title, required this.subtitle, this.onBack});

  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: onBack ?? () => Navigator.of(context).maybePop(),
                customBorder: const CircleBorder(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: TcPalette.border),
                  ),
                  child: const Icon(Icons.chevron_left, size: 22, color: TcPalette.text),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: TcPalette.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: TcPalette.muted),
          ),
        ],
      ),
    );
  }
}

/// One tinted stat card (icon tile + label + value).
class TcStatCard extends StatelessWidget {
  const TcStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.background,
    required this.borderColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color background;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: color),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 2x2 grid of stat cards.
class TcStatGrid extends StatelessWidget {
  const TcStatGrid({
    super.key,
    required this.active,
    required this.pendingShifts,
    required this.pendingEntries,
    required this.totalPending,
  });

  final int active;
  final int pendingShifts;
  final int pendingEntries;
  final int totalPending;

  @override
  Widget build(BuildContext context) {
    final cards = [
      TcStatCard(
        icon: Icons.access_time,
        label: 'Active Shifts',
        value: '$active',
        color: TcPalette.orange,
        background: TcPalette.orangeBg,
        borderColor: TcPalette.orangeBorder,
      ),
      TcStatCard(
        icon: Icons.schedule,
        label: 'Pending Shifts',
        value: '$pendingShifts',
        color: TcPalette.purple,
        background: TcPalette.purpleBg,
        borderColor: TcPalette.purpleBorder,
      ),
      TcStatCard(
        icon: Icons.check_circle_outline,
        label: 'Pending Entries',
        value: '$pendingEntries',
        color: TcPalette.green,
        background: TcPalette.greenBg,
        borderColor: TcPalette.greenBorder,
      ),
      TcStatCard(
        icon: Icons.format_list_bulleted,
        label: 'Total Pending',
        value: '$totalPending',
        color: TcPalette.orange,
        background: TcPalette.orangeBg,
        borderColor: TcPalette.orangeBorder,
      ),
    ];
    return Column(
      children: [
        Row(children: [
          Expanded(child: cards[0]),
          const SizedBox(width: 10),
          Expanded(child: cards[1]),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: cards[2]),
          const SizedBox(width: 10),
          Expanded(child: cards[3]),
        ]),
      ],
    );
  }
}
