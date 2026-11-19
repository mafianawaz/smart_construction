import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/utils/app_icons.dart';

import '../models/bid_model.dart';
import 'bid_status_chip.dart';

/// Bid Board card. Tap the card or the eye to open Bid Details; the
/// "more" button opens the card's action sheet.
class BidCard extends StatelessWidget {
  final BidModel bid;
  final VoidCallback onView;
  final VoidCallback onMore;

  const BidCard({
    super.key,
    required this.bid,
    required this.onView,
    required this.onMore,
  });

  Widget _stat(String label, String value) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500)),
            Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: AppColors.textDark, fontWeight: FontWeight.w500)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onView,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 15,
                      width: 4,
                      decoration: BoxDecoration(
                        color: BidStatusStyle.color(bid.status),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(bid.number,
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
                BidStatusChip(status: bid.status),
              ],
            ),
            const SizedBox(height: 10),
            Text(bid.title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Clients: ',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: AppColors.textMuted)),
                TextSpan(
                    text: bid.clientName,
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: AppColors.textDark)),
              ]),
            ),
            const SizedBox(height: 10),
            Divider(color: AppColors.fieldBorder),
            const SizedBox(height: 10),
            Row(
              children: [
                _stat('AMOUNT', bid.amountLabel),
                _stat('DUE DATE', bid.dueDateLabel),
                _stat('LOCATION', bid.locationLabel),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(AppIcons.workforce),
                    const SizedBox(width: 5),
                    Text(bid.ownerLabel,
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onView,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey.shade100,
                        child: SvgPicture.asset(AppIcons.visibility,
                            color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: onMore,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey.shade100,
                        child: SvgPicture.asset(AppIcons.more, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
