import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../models/bid_model.dart';
import 'bid_status_chip.dart';

/// Bid Inbox invitation card: number + status, title, client, due date
/// (red once the bid is expired) and a full-width "View Bid" button.
class InboxBidCard extends StatelessWidget {
  final BidModel bid;
  final VoidCallback onView;

  const InboxBidCard({super.key, required this.bid, required this.onView});

  @override
  Widget build(BuildContext context) {
    final dueColor = bid.isExpired ? AppColors.redColor : AppColors.textDark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.description_outlined,
                      size: 14, color: AppColors.primaryOrange),
                  const SizedBox(width: 6),
                  Text(bid.number,
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
              BidStatusChip(status: bid.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(bid.title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(bid.clientName,
              style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 12, color: dueColor),
                    const SizedBox(width: 4),
                    Text('Due ${bid.dueDateLabel}',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: dueColor)),
                  ],
                ),
              ),
              if (bid.isExpired) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.redColor),
                  ),
                  child: Text('Past due',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.redColor)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onView,
              icon: const Icon(Icons.visibility_outlined, size: 16),
              label: const Text('View Bid'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
