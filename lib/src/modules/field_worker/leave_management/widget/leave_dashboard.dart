import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';

import '../logic.dart';
import 'leave_balance_card.dart';
import 'leave_request_card.dart';

class LeaveDashboard extends StatelessWidget {
  final LeaveManagementLogic logic;

  const LeaveDashboard({
    super.key,
    required this.logic,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage time-off requests and leave balances',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 14),

          LeaveBalanceGrid(balances: logic.leaveBalances,),

          const SizedBox(height: 20),

          const Text(
            'My Leave Request History',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          if (logic.requests.isEmpty)
            const AppEmptyState(
              icon: Icons.event_available_outlined,
              title:  'No leave requests yet',
              message: 'Your submitted leave requests will appear here.',
              showButton: false,
            )
          else
            ...logic.requests.map(
                  (request) => Padding(padding: const EdgeInsets.only(bottom: 10),
                child: LeaveRequestCard(
                  request: request,
                  onCancel: () {
                    logic.cancelRequest(request);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class LeaveBalanceGrid extends StatelessWidget {
  final List<LeaveBalance> balances;

  const LeaveBalanceGrid({
    super.key,
    required this.balances,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: balances.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, index) {
        final item = balances[index];

        return LeaveBalanceCard(
          balance: item,
        );
      },
    );
  }
}