import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utils/app_color.dart';
import '../../../../widgets/app_appbar.dart';
import '../models/purchase_order_model.dart';
import '../widgets/po_status_pill.dart';

/// Detail screen has no interactive state of its own — the order is
/// handed in directly rather than fetched via a tagged controller, since
/// nothing here needs to be reactive. If a "refresh status" or similar
/// action is added later, promote this to its own tagged
/// `PurchaseOrderDetailsLogic` following the module's usual pattern.
class PurchaseOrderDetailsView extends StatelessWidget {
  final PurchaseOrderModel order;

  const PurchaseOrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: '\$');
    final dateFmt = DateFormat('MMMM d, yyyy');

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Purchase Orders',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Purchase Order Details',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _labeledText('# PO NUMBER', order.poNumber),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'STATUS',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                          const SizedBox(height: 2),
                          PoStatusPill(status: order.status),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _labeledText(
                          'TOTAL VALUE',
                          currency.format(order.totalValue),
                          valueSize: 18,
                        ),
                        _labeledText(
                          'LINE ITEMS',
                          '${order.lineItemsCount}',
                          valueSize: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _labeledRow(Icons.folder_outlined, 'PROJECT', order.projectName),
                  const SizedBox(height: 12),
                  _labeledRow(
                    Icons.business_outlined,
                    'CONTRACTOR',
                    order.contractorOrgName,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _labeledRow(
                          Icons.calendar_today_outlined,
                          'CREATED',
                          dateFmt.format(order.createdDate),
                        ),
                      ),
                      Expanded(
                        child: _labeledRow(
                          Icons.local_shipping_outlined,
                          'EXPECTED DELIVERY',
                          dateFmt.format(order.expectedDeliveryDate),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _labeledText(String label, String value, {double valueSize = 14}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: valueSize),
        ),
      ],
    );
  }

  Widget _labeledRow(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
