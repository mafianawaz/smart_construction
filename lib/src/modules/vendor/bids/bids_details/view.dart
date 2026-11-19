import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import '../../../field_worker/my_task/widget/pill_chip.dart';
import '../../../field_worker/my_work/project_details/widget/job_info_card.dart';
import '../widgets/ask_question_sheet.dart';
import '../widgets/bid_info_row.dart';
import '../widgets/bid_status_badge.dart';
import '../widgets/clarification_tile.dart';
import '../widgets/expired_banner.dart';
import 'logic.dart';


class BidDetailsView extends StatelessWidget {
  final String bidId;

  const BidDetailsView({super.key, required this.bidId});

  static final _dateFormat = DateFormat("MMMM d, yyyy 'at' h:mm a");
  static final _shortDateFormat = DateFormat('MMMM d, yyyy');

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<BidDetailsLogic>(tag: bidId);

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Bid Details',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Obx(() {
        final bid = logic.bid;
        return ListView(
          padding: const EdgeInsets.all(15),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bid.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'From ${bid.organizationName}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                BidStatusBadge(status: bid.status, isBorder: true,),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BidInfoRow(label: 'Scope of Work', value: bid.scopeOfWork),
                  const Divider(height: 1),
                  BidInfoRow(
                    label: 'Additional Description',
                    value: bid.additionalDescription,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Clarifications',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )
                        ),
                        onPressed: () async {
                          final question = await showAskQuestionSheet(context);
                          if (question != null && question.trim().isNotEmpty) {
                            logic.askQuestion(question);
                          }
                        },
                        icon: const Icon(Icons.chat_bubble_outline, size: 16,color: AppColors.textMuted),
                        label: const Text('Ask Question', style: TextStyle(fontSize: 12, color: AppColors.textMuted),),
                      ),
                    ],
                  ),
                  if (bid.clarifications.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No questions asked yet.',
                        style: TextStyle(color: Colors.black45, fontSize: 13),
                      ),
                    )
                  else
                    for (int i = 0; i < bid.clarifications.length; i++) ...[
                      if (i > 0) const Divider(height: 1),
                      ClarificationTile(clarification: bid.clarifications[i]),
                    ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Project Details',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Required Trades',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final trade in bid.requiredTrades)
                        PillChip(label: trade.toUpperCase(), color: AppColors.textMuted,),
                    ],
                  ),
                  const Divider(height: 24),
                  BidInfoRow(
                    label: 'Bid Due Date',
                    value: _dateFormat.format(bid.bidDueDate),
                    valueColor: bid.isOverdue ? AppColors.redColor : null,
                    caption:
                    bid.isOverdue ? 'This bid request has expired' : null,
                  ),
                  const Divider(height: 1),
                  BidInfoRow(
                    label: 'Project Start',
                    value: _shortDateFormat.format(bid.projectStartDate),
                  ),
                  const Divider(height: 1),
                  BidInfoRow(label: 'Location', value: bid.location),
                  if (bid.insuranceRequired) ...[
                    const SizedBox(height: 4),
                    const PillChip(label: 'Insurance Required', color: AppColors.textMuted,),
                  ],
                ],
              ),
            ),
            if (bid.isOverdue) ...[
              const SizedBox(height: 16),
              const ExpiredBanner(),
            ],
          ],
        );
      }),
    );
  }
}
