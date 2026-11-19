import 'package:flutter/material.dart';

import '../logic.dart';
import '../models/inventory_models.dart';
import 'inv_style.dart';

String _ago(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'Just now';
  if (d.inMinutes < 60) return '${d.inMinutes}m ago';
  if (d.inHours < 24) return '${d.inHours}h ago';
  return '${d.inDays}d ago';
}

String _qty(double v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);

/// "From the Field" card: latest mobile transactions + devices behind on sync.
class FromTheFieldCard extends StatelessWidget {
  final MaterialInventoryLogic logic;

  const FromTheFieldCard({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final recent = logic.recentTransactions;
    final behind = logic.devicesBehind;

    return InvCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: InvStyle.peach,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.description_outlined,
                    size: 18, color: InvStyle.orange),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('From the Field',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                      'Receive items, adjust, and view sync statuses.',
                      style: TextStyle(fontSize: 11, color: InvStyle.muted),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: logic.refreshSync,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Text(_ago(logic.lastSyncedAt),
                        style: TextStyle(fontSize: 10, color: InvStyle.muted)),
                    const SizedBox(width: 3),
                    Icon(Icons.sync, size: 12, color: InvStyle.muted),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: InvStyle.border),
          ),
          const Text('Recent mobile transactions',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (recent.isEmpty)
            const InvEmptyPanel(
              icon: Icons.smartphone,
              title: 'No mobile activity yet',
              message: "Field crews haven't posted any moves from their devices.",
            )
          else
            Column(
              children: [
                for (final t in recent) _TxnTile(txn: t, logic: logic),
              ],
            ),
          const SizedBox(height: 14),
          const Text('Devices behind on sync',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (behind.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: InvStyle.successBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 16, color: InvStyle.success),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All registered devices have synced in the last 24h.',
                      style: TextStyle(fontSize: 11, color: InvStyle.success),
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                for (final d in behind)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: InvStyle.peach,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sync_problem,
                            size: 16, color: InvStyle.warn),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(d.name,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                        Text('Last sync ${_ago(d.lastSync)}',
                            style: const TextStyle(
                                fontSize: 11, color: InvStyle.warn)),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _TxnTile extends StatelessWidget {
  final InventoryTransaction txn;
  final MaterialInventoryLogic logic;

  const _TxnTile({required this.txn, required this.logic});

  IconData get _icon {
    switch (txn.type) {
      case InventoryTxnType.receive:
        return Icons.file_download_outlined;
      case InventoryTxnType.issue:
        return Icons.file_upload_outlined;
      case InventoryTxnType.transfer:
        return Icons.swap_horiz;
      case InventoryTxnType.adjust:
        return Icons.tune;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mat = logic.materialById(txn.materialId);
    final where = logic.locationById(txn.toLocationId ?? txn.fromLocationId);
    final uom = mat?.uom ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: InvStyle.panel,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_icon, size: 16, color: InvStyle.orange),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${txn.type.label} - ${mat?.sku ?? '?'} x ${_qty(txn.qty)} $uom',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text(
                  [if (where != null) where.code, _ago(txn.createdAt)]
                      .join(' - '),
                  style: TextStyle(fontSize: 10, color: InvStyle.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Grey empty panel with an icon, title and message (also used by Stock By Location).
class InvEmptyPanel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const InvEmptyPanel({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: InvStyle.panel,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: InvStyle.muted),
          const SizedBox(height: 6),
          Text(title,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: InvStyle.muted)),
        ],
      ),
    );
  }
}
