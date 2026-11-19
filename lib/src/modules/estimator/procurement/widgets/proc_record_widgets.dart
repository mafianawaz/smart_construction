import 'package:flutter/material.dart';

import '../models/procurement_orders_models.dart';
import '../models/purchase_request_models.dart';
import 'proc_inputs.dart';

/// One figure in the Total Committed / Invoiced / Paid row.
class ProcStat {
  final String label;
  final String value;

  const ProcStat(this.label, this.value);
}

class ProcStatRow extends StatelessWidget {
  final List<ProcStat> stats;

  const ProcStatRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ProcStyle.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stats[i].label,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(stats[i].value,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Icon + title on the left, optional action on the right.
class ProcSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? action;

  const ProcSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: ProcStyle.orange),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        ),
        if (action != null) action!,
      ],
    );
  }
}

/// Outlined dropdown showing the current choice (All Statuses / All Projects /
/// All Upcoming). [options] maps key -> menu text.
class ProcFilterField extends StatelessWidget {
  final String label;
  final Map<String, String> options;
  final ValueChanged<String> onSelected;
  final bool expanded;

  const ProcFilterField({
    super.key,
    required this.label,
    required this.options,
    required this.onSelected,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final field = Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ProcStyle.border),
      ),
      child: Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (expanded)
            Expanded(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12)),
            )
          else
            Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 6),
          Icon(Icons.keyboard_arrow_down, size: 18, color: ProcStyle.muted),
        ],
      ),
    );
    return PopupMenuButton<String>(
      onSelected: onSelected,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (_) => [
        for (final e in options.entries)
          PopupMenuItem<String>(
            value: e.key,
            child: Text(e.value, style: const TextStyle(fontSize: 13)),
          ),
      ],
      child: field,
    );
  }
}

/// Small coloured status badge (APPROVED, PAID, ...).
class ProcBadge extends StatelessWidget {
  final String text;
  final Color fg;
  final Color bg;

  const ProcBadge({
    super.key,
    required this.text,
    required this.fg,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(5)),
        child: Text(text,
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w700, color: fg)),
      );
}

/// Card used by Purchase Orders, Delivery Receipts and Vendor Invoices:
/// badge, bold number, muted detail lines, edit + bookmark icons on the right.
class ProcRecordCard extends StatelessWidget {
  final ProcBadge badge;
  final String title;
  final List<String> lines;
  final bool bookmarked;
  final VoidCallback onEdit;
  final VoidCallback onBookmark;

  const ProcRecordCard({
    super.key,
    required this.badge,
    required this.title,
    required this.lines,
    required this.bookmarked,
    required this.onEdit,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProcStyle.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                badge,
                const SizedBox(height: 6),
                Text(title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                for (final l in lines)
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(l,
                        style:
                            TextStyle(fontSize: 11, color: ProcStyle.muted)),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _SquareIcon(icon: Icons.edit_outlined, onTap: onEdit),
          const SizedBox(width: 6),
          _SquareIcon(
            icon: bookmarked ? Icons.bookmark : Icons.bookmark_border,
            onTap: onBookmark,
            active: bookmarked,
          ),
        ],
      ),
    );
  }
}

class _SquareIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  const _SquareIcon({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? ProcStyle.orange : ProcStyle.border),
        ),
        child: Icon(icon,
            size: 16, color: active ? ProcStyle.orange : Colors.black87),
      ),
    );
  }
}

/// Delivery Schedule card: dated badge, title, PO / vendor / project lines.
class DeliveryEventCard extends StatelessWidget {
  final DeliveryEvent event;
  final bool soon; // orange badge when the delivery is near

  const DeliveryEventCard({super.key, required this.event, required this.soon});

  @override
  Widget build(BuildContext context) {
    final fg = soon ? const Color(0xFFEA580C) : const Color(0xFF6B7280);
    final bg = soon ? const Color(0xFFFFE8D9) : const Color(0xFFF3F4F6);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProcStyle.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProcBadge(text: formatBadgeDate(event.date), fg: fg, bg: bg),
          const SizedBox(height: 6),
          Text(event.title,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text('PO: ${event.poNumber} · Vendor: ${event.vendor}',
              style: TextStyle(fontSize: 11, color: ProcStyle.muted)),
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
                'Project: ${event.project} · ${event.itemsLabel}',
                style: TextStyle(fontSize: 11, color: ProcStyle.muted)),
          ),
        ],
      ),
    );
  }
}

/// Grey empty / no-match panel.
class ProcEmptyPanel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onClear; // shows "Clear filters" when set

  const ProcEmptyPanel({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: ProcStyle.panel,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: ProcStyle.muted),
          const SizedBox(height: 8),
          Text(title,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: ProcStyle.muted)),
          if (onClear != null) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: onClear,
              child: Text('Clear filters',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ProcStyle.orange)),
            ),
          ],
        ],
      ),
    );
  }
}
