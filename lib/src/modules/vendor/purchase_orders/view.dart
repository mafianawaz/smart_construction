import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/app_empty_filter.dart';
import '../../../widgets/stat_card_row.dart';
import 'logic.dart';
import 'order_details/view.dart';
import 'widgets/purchase_order_card.dart';

class PurchaseOrdersView extends StatelessWidget {
  const PurchaseOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(PurchaseOrdersLogic(), tag: 'purchase_orders');

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Purchase Orders',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Obx(() {
        final currency = NumberFormat.currency(symbol: '\$');
        final orders = logic.orders;

        final statItems = [
          StatCardItem(
            icon: Icons.shopping_cart,
            label: 'Active',
            value: '${logic.activeCount}',
          ),
          StatCardItem(
            icon: Icons.attach_money,
            label: 'Value',
            value: currency.format(logic.totalValue),
          ),
          StatCardItem(
            icon: Icons.check_circle,
            label: 'Delivered',
            value: '${logic.deliveredCount}',
          ),
        ];

        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'View and track purchase orders from contractors for '
                'your materials and services.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 12),
              StatCardRow(items: statItems),
              const SizedBox(height: 16),
              const Text(
                'All Purchase Orders',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const Text(
                'Purchase orders issued to you by contractor organizations',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: orders.isEmpty
                    ? const AppEmptyState(
                        icon: Icons.shopping_cart_outlined,
                        title: 'No purchase orders yet',
                        message: 'Purchase orders from contractors will appear '
                            'here when they order your materials or '
                            'services.',
                        showButton: false,
                      )
                    : ListView.separated(
                        itemCount: orders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return PurchaseOrderCard(
                            order: order,
                            onTap: () {
                              Get.to(
                                () => PurchaseOrderDetailsView(order: order),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
