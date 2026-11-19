import 'package:flutter/material.dart';

import '../logic.dart';
import '../models/inventory_models.dart';
import 'field_activity_cards.dart';
import 'inv_style.dart';

String _qty(double v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);

/// On-Hand tab: stock grouped by location, or the empty state.
class StockByLocationCard extends StatelessWidget {
  final MaterialInventoryLogic logic;

  const StockByLocationCard({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final rows = logic.stockRows;
    final lowIds = logic.lowStock.map((m) => m.id).toSet();

    // Group consecutive rows (already sorted by location code).
    final groups = <StockLocation, List<StockRow>>{};
    for (final r in rows) {
      groups.putIfAbsent(r.location, () => []).add(r);
    }

    return InvCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Stock By Location',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          if (rows.isEmpty)
            Center(
              child: Column(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: InvStyle.panel,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.inventory_2_outlined,
                        size: 22, color: InvStyle.muted),
                  ),
                  const SizedBox(height: 8),
                  const Text('No stock recorded',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(
                    'Add a location and material, then receive stock to populate this view.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: InvStyle.muted),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            )
          else
            for (final entry in groups.entries) ...[
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: InvStyle.panel,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 14, color: InvStyle.orange),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(entry.key.dropdownLabel,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                    Text(entry.key.type.label,
                        style: TextStyle(fontSize: 10, color: InvStyle.muted)),
                  ],
                ),
              ),
              for (final r in entry.value)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.material.sku,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                            Text(r.material.name,
                                style: TextStyle(
                                    fontSize: 11, color: InvStyle.muted)),
                          ],
                        ),
                      ),
                      Text(
                        '${_qty(r.qty)} ${r.material.uom}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: lowIds.contains(r.material.id)
                              ? InvStyle.warn
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
            ],
        ],
      ),
    );
  }
}

/// Result of the Barcode / QR lookup, shown under the search row.
class LookupResultCard extends StatelessWidget {
  final MaterialInventoryLogic logic;

  const LookupResultCard({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final m = logic.lookupMatch;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InvCard(
        child: m == null
            ? Row(
                children: [
                  Icon(Icons.search_off, size: 18, color: InvStyle.muted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'No material found for "${logic.lookupCtrl.text.trim()}".',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  _Close(onTap: logic.clearLookup),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('${m.sku} - ${m.name}',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w700)),
                      ),
                      _Close(onTap: logic.clearLookup),
                    ],
                  ),
                  if (m.barcode.isNotEmpty)
                    Text('Barcode ${m.barcode}',
                        style: TextStyle(fontSize: 11, color: InvStyle.orange)),
                  const SizedBox(height: 8),
                  Text(
                    'On hand: ${_qty(logic.totalOnHand(m.id))} ${m.uom}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  for (final s
                      in logic.stock.where((s) => s.materialId == m.id && s.qty > 0))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              logic.locationById(s.locationId)?.dropdownLabel ??
                                  s.locationId,
                              style: TextStyle(
                                  fontSize: 11, color: InvStyle.muted),
                            ),
                          ),
                          Text('${_qty(s.qty)} ${m.uom}',
                              style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _Close extends StatelessWidget {
  final VoidCallback onTap;

  const _Close({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(Icons.close, size: 16, color: InvStyle.muted),
        ),
      );
}

/// Reports tab: Low Stock Alerts + Slow-Moving Inventory.
class ReportsPanel extends StatelessWidget {
  final MaterialInventoryLogic logic;

  const ReportsPanel({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final low = logic.lowStock;
    final slow = logic.slowMoving;

    return Column(
      children: [
        InvCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InvCardTitle(
                icon: Icons.warning_amber_rounded,
                title: 'Low Stock Alerts',
                color: InvStyle.warn,
              ),
              const SizedBox(height: 10),
              if (low.isEmpty)
                const Text(
                  'All stocked items are above reorder point.',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: InvStyle.warn),
                )
              else
                for (final m in low)
                  _ReportLine(
                    title: '${m.sku} - ${m.name}',
                    detail:
                        '${_qty(logic.totalOnHand(m.id))} ${m.uom} on hand, reorder at ${_qty(m.reorderPoint)}'
                        '${m.reorderQty > 0 ? ' (order ${_qty(m.reorderQty)})' : ''}',
                    detailColor: InvStyle.warn,
                  ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        InvCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InvCardTitle(
                icon: Icons.schedule,
                title: 'Slow-Moving Inventory',
                color: InvStyle.muted,
              ),
              const SizedBox(height: 10),
              if (slow.isEmpty)
                const Text('No slow-moving stock.',
                    style: TextStyle(fontSize: 12))
              else
                for (final m in slow)
                  _ReportLine(
                    title: '${m.sku} - ${m.name}',
                    detail:
                        '${_qty(logic.totalOnHand(m.id))} ${m.uom} with no issues in 90 days',
                    detailColor: InvStyle.muted,
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReportLine extends StatelessWidget {
  final String title;
  final String detail;
  final Color detailColor;

  const _ReportLine({
    required this.title,
    required this.detail,
    required this.detailColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          Text(detail, style: TextStyle(fontSize: 11, color: detailColor)),
        ],
      ),
    );
  }
}
