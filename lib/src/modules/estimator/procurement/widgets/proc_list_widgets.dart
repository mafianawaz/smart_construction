import 'package:flutter/material.dart';

import '../models/purchase_request_models.dart';
import 'proc_inputs.dart';

/// Requests / Orders / Receipts / Invoices pill row.
class ProcTabs extends StatelessWidget {
  final ProcTab selected;
  final ValueChanged<ProcTab> onChanged;

  const ProcTabs({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final t in ProcTab.values) ...[
            GestureDetector(
              onTap: () => onChanged(t),
              child: Container(
                height: 30,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: t == selected ? ProcStyle.orange : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: t == selected
                          ? ProcStyle.orange
                          : ProcStyle.border),
                ),
                child: Text(
                  t.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: t == selected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

/// Pill that opens a popup menu (All Status / All Projects).
/// Menu values are Strings; [allKey] means "no filter".
class ProcFilterPill extends StatelessWidget {
  static const String allKey = '__all__';

  final String label;
  final bool active; // filled orange when a filter is applied
  final Map<String, String> options; // key -> menu text (must include allKey)
  final ValueChanged<String> onSelected;

  const ProcFilterPill({
    super.key,
    required this.label,
    required this.active,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final fg = active ? Colors.white : Colors.black87;
    return PopupMenuButton<String>(
      onSelected: onSelected,
      offset: const Offset(0, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (_) => [
        for (final e in options.entries)
          PopupMenuItem<String>(
            value: e.key,
            child: Text(e.value, style: const TextStyle(fontSize: 13)),
          ),
      ],
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active ? ProcStyle.orange : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: active ? ProcStyle.orange : ProcStyle.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 16, color: fg),
          ],
        ),
      ),
    );
  }
}

class PurchaseRequestCard extends StatelessWidget {
  final PurchaseRequest request;
  final VoidCallback onEdit;
  final VoidCallback onSubmit;
  final VoidCallback onDelete;

  const PurchaseRequestCard({
    super.key,
    required this.request,
    required this.onEdit,
    required this.onSubmit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final r = request;
    final isDraft = r.status == PurchaseRequestStatus.draft;
    final needed = r.neededBy == null ? '—' : formatProcDate(r.neededBy!);
    final est = r.estTotal > 0 ? formatProcMoney(r.estTotal) : '—';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProcStyle.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDraft)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _IconAction(Icons.edit_outlined, ProcStyle.muted, onEdit),
                _IconAction(Icons.send_outlined, ProcStyle.muted, onSubmit),
                _IconAction(Icons.delete_outline, ProcStyle.danger, onDelete),
              ],
            ),
          Row(
            children: [
              Expanded(
                child: Text(r.number,
                    style: TextStyle(fontSize: 11, color: ProcStyle.muted)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: r.status.bg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  r.status.badge,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: r.status.fg),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text('${r.project} · By: ${r.requestedBy}',
                        style:
                            TextStyle(fontSize: 11, color: ProcStyle.muted)),
                    const SizedBox(height: 2),
                    Text('Needed $needed · Est: $est',
                        style:
                            TextStyle(fontSize: 11, color: ProcStyle.muted)),
                  ],
                ),
              ),
              if (isDraft) ProcButton(text: 'Submit', compact: true, onPressed: onSubmit),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconAction(this.icon, this.color, this.onTap);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Icon(icon, size: 16, color: color),
        ),
      );
}
