import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import '../../../widgets/pill_tab_group.dart';
import 'logic.dart';
import 'models/purchase_request_models.dart';
import 'widgets/proc_inputs.dart';
import 'widgets/proc_list_widgets.dart';
import 'widgets/proc_tab_bodies.dart';

class ProcurementView extends StatelessWidget {
  const ProcurementView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProcurementLogic>(
      init: ProcurementLogic(),
      builder: (logic) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppPrimaryBar(
            title: 'Procurement',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manage purchase requests, orders, delivery receipts, and vendor invoices.',
                    style: TextStyle(fontSize: 12, color: ProcStyle.muted),
                  ),
                  const SizedBox(height: 12),
                  PillTabGroup<ProcTab>(
                    items: ProcTab.values.map((tab) => PillTabItem<ProcTab>(
                      value: tab,
                      label: tab.label,
                    ),
                    ).toList(),
                    selectedValue: logic.tab,
                    onChanged: logic.selectTab,
                    style: PillTabStyle.filled,
                  ),
                  const SizedBox(height: 16),
                  _TabBody(logic: logic),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RequestsTab extends StatelessWidget {
  final ProcurementLogic logic;

  const _RequestsTab({required this.logic});

  @override
  Widget build(BuildContext context) {
    final list = logic.filtered;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Purchase Requests',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ),
            ProcButton(
              text: '+ New Request',
              compact: true,
              outlined: true,
              onPressed: logic.newRequest,
            ),
          ],
        ),
        const SizedBox(height: 12),
        ProcField(
          hint: 'Search by title, PR number, or project...',
          controller: logic.searchCtrl,
          onChanged: logic.onSearchChanged,
          textInputAction: TextInputAction.search,
          prefix: Icon(Icons.search, size: 18, color: ProcStyle.muted),
        ),
        Row(
          children: [
            ProcFilterPill(
              label: logic.statusLabel,
              active: true, // Figma always shows the status pill filled
              options: logic.statusOptions,
              onSelected: logic.setStatusFilter,
            ),
            const SizedBox(width: 8),
            ProcFilterPill(
              label: logic.projectLabel,
              active: logic.projectActive,
              options: logic.projectOptions,
              onSelected: logic.setProjectFilter,
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text('Equipment', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        if (list.isEmpty)
          _EmptyRequests(logic: logic)
        else
          for (final r in list)
            PurchaseRequestCard(
              request: r,
              onEdit: () => logic.editRequest(r),
              onSubmit: () => logic.submitRequest(r),
              onDelete: () => logic.deleteRequest(r),
            ),
      ],
    );
  }
}

class _EmptyRequests extends StatelessWidget {
  final ProcurementLogic logic;

  const _EmptyRequests({required this.logic});

  @override
  Widget build(BuildContext context) {
    final filtered = logic.hasActiveFilters;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: ProcStyle.panel,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 28, color: ProcStyle.muted),
          const SizedBox(height: 8),
          Text(
            filtered ? 'No requests match your filters' : 'No purchase requests yet',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            filtered
                ? 'Try a different search or clear the filters.'
                : 'Tap "+ New Request" to create your first one.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: ProcStyle.muted),
          ),
          if (filtered) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: logic.clearFilters,
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

class _TabBody extends StatelessWidget {
  final ProcurementLogic logic;

  const _TabBody({required this.logic});

  @override
  Widget build(BuildContext context) {
    switch (logic.tab) {
      case ProcTab.requests:
        return _RequestsTab(logic: logic);
      case ProcTab.orders:
        return OrdersTab(logic: logic);
      case ProcTab.receipts:
        return ReceiptsTab(logic: logic);
      case ProcTab.invoices:
        return InvoicesTab(logic: logic);
      case ProcTab.deliverySchedule:
        return DeliveryScheduleTab(logic: logic);
    }
  }
}
