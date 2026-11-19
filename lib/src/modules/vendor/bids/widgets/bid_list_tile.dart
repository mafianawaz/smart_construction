import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import '../../../../utils/app_color.dart';
import '../../../field_worker/my_task/widget/pill_chip.dart';
import '../models/bid_model.dart';
import 'bid_status_badge.dart';

class BidListTile extends StatelessWidget {
  final BidModel bid;
  final VoidCallback onViewDetails;

  const BidListTile({
    super.key,
    required this.bid,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset(AppIcons.docs, color: AppColors.primaryOrange,),
                    SizedBox(width: 8),
                    Text(
                      bid.organizationName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              BidStatusBadge(status: bid.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            bid.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            bid.scopeOfWork,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final trade in bid.requiredTrades)
                PillChip(
                  label: trade.toUpperCase(),
                  color: AppColors.textMuted,
                  filled: false,
                ),
              if (bid.isOverdue)
              // PillChip has no icon slot — the warning glyph is baked
              // into the label text instead.
                PillChip(
                  label: '⚠ Overdue',
                  color: AppColors.primaryOrange,
                  filled: false,
                ),
            ],
          ),
          const SizedBox(height: 12),
          CustomIconButton(
              text: 'View Details',
              icon: AppIcons.vacation,
              onPressed: onViewDetails
          ),
        ],
      ),
    );
  }
}
