import 'package:flutter/material.dart';

import '../logic.dart';
import '../logic_orders.dart';
import '../models/procurement_orders_models.dart';
import '../models/purchase_request_models.dart';
import 'proc_inputs.dart';
import 'proc_record_widgets.dart';

/// Shared layout for the Orders / Receipts / Invoices tabs:
/// stat row, section header + action, search, status/project filters, list.
class _RecordListTab extends StatelessWidget {
  final ProcurementLogic logic;
  final ProcTab tab;
  final IconData icon;
  final String title;
  final String actionText;
  final VoidCallback onAction;
  final String searchHint;
  final List<Widget> cards;
  final String emptyTitle;
  final String emptyMessage;

  const _RecordListTab({
    required this.logic,
    required this.tab,
    required this.icon,
    required this.title,
    required this.actionText,
    required this.onAction,
    required this.searchHint,
    required this.cards,
    required this.emptyTitle,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = logic.hasFiltersFor(tab);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProcStatRow(stats: [
          ProcStat('Total Committed', formatProcMoney(logic.totalCommitted)),
          ProcStat('Total Invoiced', formatProcMoney(logic.totalInvoiced)),
          ProcStat('Total Paid', formatProcMoney(logic.totalPaid)),
        ]),
        const SizedBox(height: 16),
        ProcSectionHeader(
          icon: icon,
          title: title,
          action: ProcButton(text: actionText, compact: true, onPressed: onAction),
        ),
        const SizedBox(height: 12),
        ProcField(
          hint: searchHint,
          controller: logic.searchByTab[tab]!,
          onChanged: (_) => logic.update(),
          textInputAction: TextInputAction.search,
          prefix: Icon(Icons.search, size: 18, color: ProcStyle.muted),
        ),
        Row(
          children: [
            Expanded(
              child: ProcFilterField(
                label: logic.statusLabelFor(tab),
                options: logic.statusOptionsFor(tab),
                onSelected: (k) => logic.setStatusFor(tab, k),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ProcFilterField(
                label: logic.projectLabelFor(tab),
                options: logic.projectOptionsFor(tab),
                onSelected: (k) => logic.setProjectFor(tab, k),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (cards.isEmpty)
          ProcEmptyPanel(
            icon: icon,
            title: filtered ? 'Nothing matches your filters' : emptyTitle,
            message: filtered
                ? 'Try a different search or clear the filters.'
                : emptyMessage,
            onClear: filtered ? () => logic.clearFiltersFor(tab) : null,
          )
        else
          ...cards,
      ],
    );
  }
}

class OrdersTab extends StatelessWidget {
  final ProcurementLogic logic;

  const OrdersTab({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return _RecordListTab(
      logic: logic,
      tab: ProcTab.orders,
      icon: Icons.shopping_cart_outlined,
      title: 'Purchase Orders',
      actionText: '+ New PO',
      onAction: logic.newOrder,
      searchHint: 'Search by PO number, vendor, or project...',
      emptyTitle: 'No purchase orders yet',
      emptyMessage: 'Tap "+ New PO" to create one.',
      cards: [
        for (final o in logic.filteredOrders)
          ProcRecordCard(
            badge: ProcBadge(text: o.status.badge, fg: o.status.fg, bg: o.status.bg),
            title: o.number,
            lines: [
              'Vendor: ${o.vendor} · Project: ${o.project} · Est: ${formatProcMoney(o.estimate)}',
            ],
            bookmarked: o.bookmarked,
            onEdit: () => logic.editOrder(o),
            onBookmark: () => logic.toggleOrderBookmark(o),
          ),
      ],
    );
  }
}

class ReceiptsTab extends StatelessWidget {
  final ProcurementLogic logic;

  const ReceiptsTab({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return _RecordListTab(
      logic: logic,
      tab: ProcTab.receipts,
      icon: Icons.local_shipping_outlined,
      title: 'Delivery Receipts',
      actionText: '+ New DR',
      onAction: logic.newReceipt,
      searchHint: 'Search by PO number or notes...',
      emptyTitle: 'No delivery receipts yet',
      emptyMessage: 'Tap "+ New DR" when a delivery arrives.',
      cards: [
        for (final r in logic.filteredReceipts)
          ProcRecordCard(
            badge: ProcBadge(text: r.status.badge, fg: r.status.fg, bg: r.status.bg),
            title: r.number,
            lines: [
              'PO: ${r.poNumber} · Vendor: ${r.vendor} · Received: ${formatShortDate(r.receivedOn)}',
              [
                r.status == ReceiptStatus.partial && r.itemsExpected > 0
                    ? '${r.itemsReceived} of ${r.itemsExpected} items received'
                    : '${r.itemsReceived} items received',
                if (r.inspectedBy.isNotEmpty) 'Inspected by: ${r.inspectedBy}',
              ].join(' · '),
            ],
            bookmarked: r.bookmarked,
            onEdit: () => logic.editReceipt(r),
            onBookmark: () => logic.toggleReceiptBookmark(r),
          ),
      ],
    );
  }
}

class InvoicesTab extends StatelessWidget {
  final ProcurementLogic logic;

  const InvoicesTab({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    return _RecordListTab(
      logic: logic,
      tab: ProcTab.invoices,
      icon: Icons.description_outlined,
      title: 'Vendor Invoices',
      actionText: '+ New Invoice',
      onAction: logic.newInvoice,
      searchHint: 'Search by invoice number or vendor...',
      emptyTitle: 'No vendor invoices yet',
      emptyMessage: 'Tap "+ New Invoice" to log one.',
      cards: [
        for (final i in logic.filteredInvoices)
          ProcRecordCard(
            badge: ProcBadge(text: i.status.badge, fg: i.status.fg, bg: i.status.bg),
            title: i.number,
            lines: [
              'Vendor: ${i.vendor} · PO: ${i.poNumber}',
              [
                'Amount: ${formatProcMoney(i.amount)}',
                if (i.dueDate != null) 'Due: ${formatShortDate(i.dueDate!)}',
                if (i.paidDate != null) 'Paid: ${formatShortDate(i.paidDate!)}',
              ].join(' · '),
            ],
            bookmarked: i.bookmarked,
            onEdit: () => logic.editInvoice(i),
            onBookmark: () => logic.toggleInvoiceBookmark(i),
          ),
      ],
    );
  }
}

class DeliveryScheduleTab extends StatelessWidget {
  final ProcurementLogic logic;

  const DeliveryScheduleTab({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final list = logic.filteredDeliveries;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProcSectionHeader(
          icon: Icons.calendar_month_outlined,
          title: 'Delivery Schedule',
          action: ProcFilterField(
            expanded: false,
            label: logic.scheduleRange.label,
            options: {for (final r in ScheduleRange.values) r.name: r.label},
            onSelected: logic.setScheduleRange,
          ),
        ),
        const SizedBox(height: 14),
        if (list.isEmpty)
          const ProcEmptyPanel(
            icon: Icons.calendar_month_outlined,
            title: 'No deliveries in this range',
            message: 'Pick a longer range or schedule a delivery on a PO.',
          )
        else
          for (final d in list)
            DeliveryEventCard(event: d, soon: logic.isSoon(d)),
      ],
    );
  }
}
