import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../../../../widgets/scroll_segment_toggle.dart';
import '../../models/project_enums.dart';
import '../../widgets/project_empty_card.dart';
import '../risks/widgets/risk_filter_pill.dart';
import '../widgets/project_action_button.dart';
import 'logic.dart';
import '../widgets/project_format.dart';
import 'widgets/procurement_stat_tile.dart';
import 'widgets/purchase_order_tile.dart';
import 'widgets/purchase_request_tile.dart';

/// Procurement tab — Requests / Orders / Receipts / Invoices / Delivery
/// Schedule segmented toggle.
///  - Requests: "New Request", heading, search, "All Statuses" pill, list.
///  - Orders: "Purchase Orders" heading, "New PO", the three totals tiles,
///    search, "All Statuses" pill, list / empty state.
///  - Receipts: "Delivery" heading and the empty state.
///  - Invoices: search, "All Statuses" pill, "Vendor Invoice" heading, empty.
///  - Delivery Schedule: search, "All Upcoming" pill, heading, empty.
/// Receipts, Invoices and Delivery Schedule only have empty-state references,
/// so they have no model or populated row yet — see
/// NOTES_PROCUREMENT_FINANCIALS.md.
class ProcurementView extends StatelessWidget {
  final String projectId;
  const ProcurementView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProcurementLogic>(
      init: ProcurementLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => ScrollSegmentToggle<ProcurementSubTab>(
                    values: ProcurementSubTab.values,
                    labelOf: (t) => t.label,
                    selected: logic.subTab.value,
                    onChanged: logic.onSubTabChange,
                  )),
              const SizedBox(height: 14),
              Obx(() {
                switch (logic.subTab.value) {
                  case ProcurementSubTab.requests:
                    return _RequestsSection(logic: logic);
                  case ProcurementSubTab.orders:
                    return _OrdersSection(logic: logic);
                  case ProcurementSubTab.receipts:
                    return const _ReceiptsSection();
                  case ProcurementSubTab.invoices:
                    return _InvoicesSection(logic: logic);
                  case ProcurementSubTab.deliverySchedule:
                    return _DeliveryScheduleSection(logic: logic);
                }
              }),
            ],
          ),
        );
      },
    );
  }
}

class _RequestsSection extends StatelessWidget {
  final ProcurementLogic logic;
  const _RequestsSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectActionButton(
          label: 'New Request',
          icon: Icons.add,
          onPressed: logic.openNewRequest,
        ),
        const SizedBox(height: 14),
        const Text('Purchase Requests',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        CustomTextField(
          hintText: 'Search by titles or PR number...',
          leftIconPath: AppIcons.search,
          onChange: logic.onSearch,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: Obx(() => RiskFilterPill<PurchaseRequestStatus>(
                allLabel: 'All Statuses',
                value: logic.statusFilter.value,
                options: PurchaseRequestStatus.values,
                labelOf: (s) => s.label,
                onChanged: logic.setStatusFilter,
                filled: true,
              )),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final all = logic.requests.length;
          final list = logic.filteredRequests;
          if (list.isEmpty) {
            return ProjectEmptyCard(
              icon: Icons.shopping_cart_outlined,
              message: all == 0
                  ? 'No Purchase requests found'
                  : 'No purchase requests match the search or filter.',
            );
          }
          return Column(children: [for (final r in list) PurchaseRequestTile(request: r)]);
        }),
      ],
    );
  }
}


class _SectionHeading extends StatelessWidget {
  final String text;
  const _SectionHeading(this.text);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700));
}

class _OrdersSection extends StatelessWidget {
  final ProcurementLogic logic;
  const _OrdersSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading('Purchase Orders'),
        const SizedBox(height: 10),
        ProjectActionButton(
          label: 'New PO',
          icon: Icons.add,
          onPressed: logic.openNewPurchaseOrder,
        ),
        const SizedBox(height: 12),
        Obx(() => Row(
              children: [
                Expanded(
                  child: ProcurementStatTile(
                      label: 'Total Committed', value: projectMoney(logic.totalCommitted)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ProcurementStatTile(
                      label: 'Total Invoiced', value: projectMoney(logic.totalInvoiced)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ProcurementStatTile(
                    label: 'Total Paid',
                    value: projectMoney(logic.totalPaid),
                    accent: AppColors.primaryOrange,
                  ),
                ),
              ],
            )),
        const SizedBox(height: 12),
        CustomTextField(
          hintText: 'Search by PO number or vendor...',
          leftIconPath: AppIcons.search,
          onChange: logic.onOrderSearch,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: Obx(() => RiskFilterPill<PurchaseOrderStatus>(
                allLabel: 'All Statuses',
                value: logic.orderStatusFilter.value,
                options: PurchaseOrderStatus.values,
                labelOf: (s) => s.label,
                onChanged: logic.setOrderStatusFilter,
                filled: true,
              )),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final all = logic.orders.length;
          final list = logic.filteredOrders;
          if (list.isEmpty) {
            return ProjectEmptyCard(
              icon: Icons.shopping_cart_outlined,
              message: all == 0
                  ? 'No purchase orders found.'
                  : 'No purchase orders match the search or filter.',
            );
          }
          return Column(children: [for (final o in list) PurchaseOrderTile(order: o)]);
        }),
      ],
    );
  }
}

class _ReceiptsSection extends StatelessWidget {
  const _ReceiptsSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeading('Delivery'),
        SizedBox(height: 10),
        ProjectEmptyCard(icon: Icons.local_shipping_outlined, message: 'No delivery receipts'),
      ],
    );
  }
}

class _InvoicesSection extends StatelessWidget {
  final ProcurementLogic logic;
  const _InvoicesSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hintText: 'Search by invoice number...',
          leftIconPath: AppIcons.search,
          onChange: logic.onInvoiceSearch,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: Obx(() => RiskFilterPill<String>(
                allLabel: 'All Statuses',
                value: logic.invoiceStatusFilter.value,
                options: ProcurementLogic.invoiceStatuses,
                labelOf: (s) => s,
                onChanged: logic.setInvoiceStatusFilter,
                filled: true,
              )),
        ),
        const SizedBox(height: 12),
        const _SectionHeading('Vendor Invoice'),
        const SizedBox(height: 10),
        const ProjectEmptyCard(
          icon: Icons.description_outlined,
          message: 'No vendor invoice yet',
        ),
      ],
    );
  }
}

class _DeliveryScheduleSection extends StatelessWidget {
  final ProcurementLogic logic;
  const _DeliveryScheduleSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The reference's search field still reads "Search by invoice
        // number..." here, which looks copied from Invoices; the hint is
        // reworded for deliveries (flagged in the notes).
        CustomTextField(
          hintText: 'Search by PO number or vendor...',
          leftIconPath: AppIcons.search,
          onChange: logic.onDeliverySearch,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: Obx(() => RiskFilterPill<DeliveryWindow>(
                allLabel: 'All Upcoming',
                value: logic.deliveryWindow.value,
                options: DeliveryWindow.values,
                labelOf: (w) => w.label,
                onChanged: logic.setDeliveryWindow,
                filled: true,
              )),
        ),
        const SizedBox(height: 12),
        const _SectionHeading('Delivery Schedules'),
        const SizedBox(height: 10),
        const ProjectEmptyCard(
          icon: Icons.calendar_month_outlined,
          message: 'No delivery data scheduled',
        ),
      ],
    );
  }
}
