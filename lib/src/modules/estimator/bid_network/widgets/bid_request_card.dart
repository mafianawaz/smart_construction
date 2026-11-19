import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import '../../../../utils/app_color.dart';
import '../models/bid_network_models.dart';
import 'bid_common_widgets.dart';

/// One row in the Bid Network list. Screen-agnostic: all actions are callbacks.
class BidRequestCard extends StatelessWidget {
  const BidRequestCard({
    super.key,
    required this.request,
    required this.onTap,
    this.onCloseBidding,
  });

  final BidRequestModel request;
  final VoidCallback onTap;
  final VoidCallback? onCloseBidding;

  static const int _maxTags = 3;

  @override
  Widget build(BuildContext context) {
    final extra = request.trades.length - _maxTags;
    final canClose = request.status == BidRequestStatus.open && onCloseBidding != null;

    return GestureDetector(
      onTap: onTap,
      child: BidCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(request.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
                BidStatusPill(status: request.status),
              ],
            ),
            const SizedBox(height: 2),
            Text(request.organization,
                style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
            if (request.trades.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (final t in request.trades.take(_maxTags)) BidTradeTag(t),
                  if (extra > 0) BidTradeTag('+$extra'),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Divider(color: kBidBorder, thickness: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                _Stat(AppIcons.visibility, '${request.views} views'),
                const SizedBox(width: 14),
                _Stat(AppIcons.send, '${request.invitedCount} invited'),
                const SizedBox(width: 14),
                _Stat(AppIcons.docs, '${request.responseCount} responses'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (request.dueDate != null)
                  Expanded(
                    child: _Stat(AppIcons.calendar,
                        'Due: ${DateFormat('MMM d, y').format(request.dueDate!)}'),
                  )
                else
                  const Spacer(),
                if (canClose)
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: onCloseBidding,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text('Close Bidding',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.label);

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(icon, height: 15, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Flexible(
          child: Text(label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ),
      ],
    );
  }
}
