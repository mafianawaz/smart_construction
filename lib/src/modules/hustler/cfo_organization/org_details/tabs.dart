import 'package:flutter/material.dart';

import '../models/cfo_org_format.dart';
import '../models/cfo_org_models.dart';
import '../widgets/cfo_org_palette.dart';
import '../widgets/cfo_org_widgets.dart';
import 'logic.dart';

/// Bodies for the Bids / Change Order / Team / CFO tabs of the Organization
/// detail screen (the Projects tab lives in `view.dart`).

Widget _emptyCard(IconData icon, String message) => CfoOrgCard(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: CfoOrgEmptyState(icon: icon, message: message),
    );

Widget _gap() => const SizedBox(height: 8);

// ---------------------------------------------------------------------------
// Bids
// ---------------------------------------------------------------------------

class CfoBidsTab extends StatelessWidget {
  const CfoBidsTab({super.key, required this.logic});

  final CfoOrgDetailLogic logic;

  @override
  Widget build(BuildContext context) {
    final bids = logic.detail.bids;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CfoOrgSectionTitle(
          'Bids',
          trailing: CfoOrgOutlineButton(
            label: 'Export CSV',
            icon: Icons.file_download_outlined,
            onPressed: logic.exportBidsCsv,
          ),
        ),
        const SizedBox(height: 10),
        if (bids.isEmpty)
          _emptyCard(Icons.gavel_outlined, 'No bids yet.')
        else
          for (final b in bids) ...[_BidTile(bid: b), _gap()],
      ],
    );
  }
}

class _BidTile extends StatelessWidget {
  const _BidTile({required this.bid});

  final CfoOrgBid bid;

  (Color, Color) get _colors {
    switch (bid.status) {
      case CfoBidStatus.awarded:
        return (CfoOrgPalette.green, CfoOrgPalette.greenSoft);
      case CfoBidStatus.open:
        return (CfoOrgPalette.blue, CfoOrgPalette.blueSoft);
      case CfoBidStatus.lost:
        return (CfoOrgPalette.red, CfoOrgPalette.redSoft);
      case CfoBidStatus.draft:
        // Solid dark pill in the reference.
        return (Colors.white, CfoOrgPalette.text);
      case CfoBidStatus.cancelled:
        return (CfoOrgPalette.slate, CfoOrgPalette.slateSoft);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = _colors;
    final amount = bid.amountLabel;
    return CfoOrgCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(bid.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: CfoOrgPalette.text)),
              ),
              const SizedBox(width: 6),
              CfoOrgPill(
                label: bid.code,
                foreground: CfoOrgPalette.muted,
                background: CfoOrgPalette.chipFill,
                fontSize: 8,
                letterSpacing: 0,
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(bid.client,
              style:
                  const TextStyle(fontSize: 10, color: CfoOrgPalette.muted)),
          const SizedBox(height: 10),
          const Divider(height: 1, color: CfoOrgPalette.border),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bid.dueLabel,
                        style: const TextStyle(
                            fontSize: 9.5, color: CfoOrgPalette.muted)),
                    if (amount != null) ...[
                      const SizedBox(height: 3),
                      Text(amount,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: CfoOrgPalette.green)),
                    ],
                  ],
                ),
              ),
              CfoOrgPill(
                  label: bid.status.label, foreground: fg, background: bg),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Change orders
// ---------------------------------------------------------------------------

class CfoChangeOrdersTab extends StatelessWidget {
  const CfoChangeOrdersTab({super.key, required this.logic});

  final CfoOrgDetailLogic logic;

  @override
  Widget build(BuildContext context) {
    final orders = logic.detail.changeOrders;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CfoOrgSectionTitle(
          'Change Order',
          trailing: CfoOrgOutlineButton(
            label: 'Export CSV',
            icon: Icons.file_download_outlined,
            onPressed: logic.exportChangeOrdersCsv,
          ),
        ),
        const SizedBox(height: 10),
        if (orders.isEmpty)
          _emptyCard(Icons.receipt_long_outlined, 'No change orders yet.')
        else
          for (final c in orders) ...[_ChangeOrderTile(order: c), _gap()],
      ],
    );
  }
}

class _ChangeOrderTile extends StatelessWidget {
  const _ChangeOrderTile({required this.order});

  final CfoOrgChangeOrder order;

  (Color, Color) get _colors {
    switch (order.status) {
      case CfoChangeOrderStatus.approved:
        return (CfoOrgPalette.green, CfoOrgPalette.greenSoft);
      case CfoChangeOrderStatus.submitted:
        return (CfoOrgPalette.blue, CfoOrgPalette.blueSoft);
      case CfoChangeOrderStatus.rejected:
        return (CfoOrgPalette.red, CfoOrgPalette.redSoft);
      case CfoChangeOrderStatus.pco:
      case CfoChangeOrderStatus.draft:
        return (CfoOrgPalette.slate, CfoOrgPalette.slateSoft);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = _colors;
    return CfoOrgCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.createdLabel(),
                    style: const TextStyle(
                        fontSize: 9.5, color: CfoOrgPalette.muted)),
                const SizedBox(height: 8),
                Text(order.amountLabel,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: CfoOrgPalette.text)),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CfoOrgPill(
                  label: order.status.label, foreground: fg, background: bg),
              const SizedBox(height: 10),
              Text(order.code,
                  style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: CfoOrgPalette.muted)),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Team
// ---------------------------------------------------------------------------

class CfoTeamTab extends StatelessWidget {
  const CfoTeamTab({super.key, required this.logic});

  final CfoOrgDetailLogic logic;

  @override
  Widget build(BuildContext context) {
    final members = logic.detail.members;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CfoOrgSectionTitle(
          'Team',
          trailing: CfoOrgOutlineButton(
            label: 'Export CSV',
            icon: Icons.file_download_outlined,
            onPressed: logic.exportTeamCsv,
          ),
        ),
        const SizedBox(height: 10),
        if (members.isEmpty)
          _emptyCard(Icons.group_outlined, 'No team members yet.')
        else
          for (final m in members) ...[_MemberTile(member: m), _gap()],
      ],
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member});

  final CfoOrgMember member;

  Widget _rolePill() {
    switch (member.role) {
      case CfoTeamRole.superintendent:
      case CfoTeamRole.estimator:
        return CfoOrgPill(
          label: member.role.label,
          foreground: CfoOrgPalette.text,
          background: CfoOrgPalette.chipFill,
          fontSize: 7.5,
          letterSpacing: 0,
        );
      case CfoTeamRole.vendor:
        return CfoOrgPill(
          label: member.role.label,
          foreground: CfoOrgPalette.orange,
          background: Colors.white,
          borderColor: CfoOrgPalette.orange,
          fontSize: 7.5,
          letterSpacing: 0,
        );
      case CfoTeamRole.admin:
      case CfoTeamRole.hustler:
        return CfoOrgPill(
          label: member.role.label,
          foreground: CfoOrgPalette.orange,
          background: CfoOrgPalette.orangeSoft,
          fontSize: 7.5,
          letterSpacing: 0,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CfoOrgCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: CfoOrgPalette.text)),
                const SizedBox(height: 2),
                Text(member.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 9, color: CfoOrgPalette.muted)),
              ],
            ),
          ),
          const SizedBox(width: 6),
          _rolePill(),
          const SizedBox(width: 6),
          member.isActive
              ? const CfoOrgPill(
                  label: 'Active',
                  foreground: Colors.white,
                  background: CfoOrgPalette.orange,
                  letterSpacing: 0,
                )
              : const CfoOrgPill(
                  label: 'Inactive',
                  foreground: CfoOrgPalette.slate,
                  background: CfoOrgPalette.slateSoft,
                  letterSpacing: 0,
                ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CFO (receivables)
// ---------------------------------------------------------------------------

class CfoReceivablesTab extends StatelessWidget {
  const CfoReceivablesTab({super.key, required this.logic});

  final CfoOrgDetailLogic logic;

  @override
  Widget build(BuildContext context) {
    final d = logic.detail;
    // The reference shows the third tile clipped, so the row scrolls.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ArTile(
                dot: CfoOrgPalette.green,
                label: 'Total Outstanding',
                value: d.outstandingArLabel,
                caption: 'Unpaid receivables',
              ),
              const SizedBox(width: 8),
              _ArTile(
                dot: CfoOrgPalette.red,
                label: 'Overdue',
                value: d.overdueArLabel,
                caption: '${d.overdueInvoices} invoices overdue',
              ),
              const SizedBox(width: 8),
              _ArTile(
                dot: CfoOrgPalette.amber,
                label: 'Collected',
                value: d.collectedYtdLabel,
                caption: d.collectedSinceLabel,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        CfoOrgSectionTitle(
          'CFO',
          trailing: CfoOrgOutlineButton(
            label: 'Export CSV',
            icon: Icons.file_download_outlined,
            onPressed: logic.exportReceivablesCsv,
          ),
        ),
        const SizedBox(height: 10),
        if (d.receivables.isEmpty)
          _emptyCard(Icons.payments_outlined, 'No receivables yet.')
        else ...[
          for (final r in d.receivables) ...[_ReceivableTile(item: r), _gap()],
        ],
      ],
    );
  }
}

class _ArTile extends StatelessWidget {
  const _ArTile({
    required this.dot,
    required this.label,
    required this.value,
    required this.caption,
  });

  final Color dot;
  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      child: CfoOrgCard(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 8.5, color: CfoOrgPalette.muted)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: CfoOrgPalette.text)),
            const SizedBox(height: 2),
            Text(caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 8, color: CfoOrgPalette.muted)),
          ],
        ),
      ),
    );
  }
}

class _ReceivableTile extends StatelessWidget {
  const _ReceivableTile({required this.item});

  final CfoOrgReceivable item;

  @override
  Widget build(BuildContext context) {
    final overdueDays = item.daysOverdue();
    final overdue = overdueDays > 0;
    return CfoOrgCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: CfoOrgPalette.text)),
                    const SizedBox(height: 2),
                    Text(item.reference,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 9, color: CfoOrgPalette.muted)),
                  ],
                ),
              ),
              if (overdue) ...[
                const SizedBox(width: 6),
                CfoOrgPill(
                  label: '${overdueDays}d overdue',
                  foreground: CfoOrgPalette.red,
                  background: CfoOrgPalette.redSoft,
                  fontSize: 8,
                  letterSpacing: 0,
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: CfoOrgPalette.border),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total / Outstanding',
                        style: TextStyle(
                            fontSize: 8.5, color: CfoOrgPalette.muted)),
                    const SizedBox(height: 3),
                    Text(item.amountsLabel,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: CfoOrgPalette.text)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Due Date',
                      style:
                          TextStyle(fontSize: 8.5, color: CfoOrgPalette.muted)),
                  const SizedBox(height: 3),
                  Text(cfoLongDate(item.dueDate),
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: overdue
                              ? CfoOrgPalette.red
                              : CfoOrgPalette.text)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
