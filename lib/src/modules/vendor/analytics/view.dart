import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/modules/vendor/enrolled_clients/view.dart';
import 'package:smart_construction/src/modules/vendor/pricing/view.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/app_empty_filter.dart';
import '../../../widgets/stat_card_row.dart';
import 'logic.dart';
import 'widgets/analytics_client_tile.dart';
import 'widgets/analytics_pricing_tile.dart';


/// Vendor "Analytics" dashboard — pricing performance, client enrollment,
/// and business activity at a glance. Matches reference Section 16.
class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(AnalyticsLogic(), tag: 'analytics');

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Analytics',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Monitor your pricing performance, client enrollments, and business activity',style: TextStyle(fontSize: 12,color: AppColors.textMuted),),
            SizedBox(height: 15,),
            StatCardRow(
              items: [
                StatCardItem(
                  icon: Icons.groups_outlined,
                  label: 'Active Clients',
                  value: '${logic.summary.value.activeClients}',
                ),
                StatCardItem(
                  icon: Icons.grid_view_outlined,
                  label: 'Total Items',
                  value: '${logic.summary.value.totalItems}',
                ),
              ],
            ),
            const SizedBox(height: 12),
            StatCardRow(
              items: [
                StatCardItem(
                  icon: Icons.attach_money,
                  label: 'Approved',
                  value: '${logic.summary.value.approved}',
                ),
                StatCardItem(
                  icon: Icons.hourglass_empty,
                  label: 'Pending Review',
                  value: '${logic.summary.value.pendingReview}',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Pricing Submissions',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Your latest pricing items',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Get.to(() => PricingView());
                  },
                  icon: const Icon(Icons.add, size: 13),
                  label: const Text('Add Pricing', style: TextStyle(fontSize: 12),),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.primaryOrange,
                    // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (!logic.hasPricingSubmissions)
              const AppEmptyState(
                icon: Icons.request_quote_outlined,
                title: 'No pricing items yet',
                message: 'Add Your First Pricing',
                showButton: false,
              )
            else ...[
              ...logic.recentSubmissions.map(
                (s) => AnalyticsPricingTile(submission: s),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.to(() => PricingView());
                  },
                  child: Text(
                    'View all ${logic.totalSubmissionCount.value} items >',
                    style: TextStyle(color: AppColors.primaryOrange, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 15),
            const Text(
              'Enrolled Clients',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            Text(
              'Contractor organizations viewing your pricing',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 15),
            if (!logic.hasEnrolledClients)
              const AppEmptyState(
                icon: Icons.groups_outlined,
                title: 'No enrolled client yet',
                message: 'Contractors will invite you to add your pricing',
                showButton: false,
              )
            else ...[
              ...logic.enrolledClients.map(
                (c) => AnalyticsClientTile(
                  client: c,
                  onAutoApproveChanged: (v) =>
                      logic.toggleAutoApprove(c, v),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.to(()=> EnrolledClientsView());
                  },
                  child: Text(
                    'View all >',
                    style: TextStyle(color: AppColors.primaryOrange,  fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
