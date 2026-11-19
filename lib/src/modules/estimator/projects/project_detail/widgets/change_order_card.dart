import 'package:flutter/material.dart';
import '../../models/change_order_model.dart';
import 'detail_card.dart';

class ChangeOrderCard extends StatelessWidget {
  final List<ChangeOrderModel> changeOrders;
  final VoidCallback onView;

  const ChangeOrderCard({super.key, required this.changeOrders, required this.onView});

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Change Order',
      subtitle: 'Track status and value of the project change order.',
      trailing: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
          onPressed: onView, child: const Text('View', style: TextStyle(color: Colors.grey),)),
      children: [
        Text(
          changeOrders.isEmpty
              ? 'No change order yet'
              : '${changeOrders.length} change order(s) on file',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}
