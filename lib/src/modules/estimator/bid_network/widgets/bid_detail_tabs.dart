import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import '../../../../utils/app_color.dart';
import '../models/bid_network_models.dart';
import 'bid_common_widgets.dart';

final _dateFmt = DateFormat('MMMM d, y');
final _dateTimeFmt = DateFormat("MMMM d, y 'at' h:mm a");
final _shortFmt = DateFormat('MMM d');

String _money(double v) => '\$${v.toStringAsFixed(2)}';

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 3),
        child: Text(text,
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: AppColors.textMuted)),
      );
}

class _Value extends StatelessWidget {
  const _Value(this.text, {this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: TextStyle(fontSize: 12, color: color));
}

/// 2×2 stat grid: Views / Invited / Responses / Due Date.
class BidStatGrid extends StatelessWidget {
  const BidStatGrid({super.key, required this.request});

  final BidRequestModel request;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _StatTile(AppIcons.docs, kBidAmber, '${request.views}', 'Views'),
      _StatTile(AppIcons.add, kBidGreen, '${request.invitedCount}', 'Invited'),
      _StatTile(AppIcons.tickCircle, AppColors.redColor,
          '${request.responseCount}', 'Responses'),
      _StatTile(
        AppIcons.calendar,
        kBidGreen,
        request.dueDate == null ? '-' : _shortFmt.format(request.dueDate!),
        'Due Date',
      ),
    ];
    return Column(
      children: [
        Row(children: [
          Expanded(child: tiles[0]),
          const SizedBox(width: 8),
          Expanded(child: tiles[1]),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: tiles[2]),
          const SizedBox(width: 8),
          Expanded(child: tiles[3]),
        ]),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile(this.icon, this.color, this.value, this.label);

  final String icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return BidCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(child: SvgPicture.asset(icon, height: 18, color: color)),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              Text(label, style: TextStyle(fontSize: 9, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}

class BidOverviewTab extends StatelessWidget {
  const BidOverviewTab({super.key, required this.request});
   final BidRequestModel request;

  @override
  Widget build(BuildContext context) {
    final r = request;
    final hasBudget = r.showBudget && (r.budgetMin != null || r.budgetMax != null);

    return Column(
      children: [
        BidCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Scope of Work',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              SizedBox(height: 6,),
              Divider(color: kBidBorder, thickness: 1),
              SizedBox(height: 6,),
              if (r.trades.isNotEmpty) ...[
                const _Label('TRADES'),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [for (final t in r.trades) BidTradeTag(t)],
                ),
              ],
              SizedBox(height: 6,),
              if (r.scopeOfWork.isNotEmpty) ...[
                const _Label('SCOPE'),
                _Value(r.scopeOfWork),
              ],
              if (r.description.isNotEmpty) ...[
                const _Label('DESCRIPTION'),
                _Value(r.description),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        BidCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Details',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              SizedBox(height: 6,),
              Divider(color: kBidBorder, thickness: 1),
              SizedBox(height: 6,),
              if (r.trades.isNotEmpty) ...[
                const _Label('REQUIRED TRADES'),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [for (final t in r.trades) BidTradeTag(t)],
                ),
              ],
              SizedBox(height: 6,),
              if (r.dueDate != null) ...[
                const _Label('DUE DATE'),
                _Value(_dateTimeFmt.format(r.dueDate!)),
              ],
              if (r.projectStart != null) ...[
                const _Label('PROJECT START'),
                _Value(_dateFmt.format(r.projectStart!)),
              ],
              if (r.locationLabel.isNotEmpty) ...[
                const _Label('LOCATION'),
                _Value(r.locationLabel),
              ],
              if (hasBudget) ...[
                const _Label('BUDGET RANGE'),
                _Value(
                  '${_money(r.budgetMin ?? 0)} - ${_money(r.budgetMax ?? 0)}',
                  color: AppColors.primaryOrange,
                ),
                Text('Visible to subcontractors',
                    style: TextStyle(fontSize: 9, color: AppColors.textMuted)),
              ],
              if (r.requiresInsurance || r.requiresBonding) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  children: [
                    if (r.requiresInsurance) const _Requirement('Insurance Required'),
                    if (r.requiresBonding) const _Requirement('Bonding Required'),
                  ],
                ),
              ],
              if (r.specialRequirements.isNotEmpty) ...[
                const _Label('SPECIAL REQUIREMENTS'),
                _Value(r.specialRequirements),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Requirement extends StatelessWidget {
  const _Requirement(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
      );
}

class BidInvitationsTab extends StatelessWidget {
  const BidInvitationsTab({super.key, required this.invitations});

  final List<BidInvitationModel> invitations;

  static const _header = TextStyle(
      fontSize: 8, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF));

  @override
  Widget build(BuildContext context) {
    return BidCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Invitations Sent',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          if (invitations.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text('No invitations sent yet',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ),
            )
          else ...[
            const Row(
              children: [
                Expanded(flex: 5, child: Text('SUBCONTRACTOR', style: _header)),
                Expanded(flex: 3, child: Center(child: Text('STATUS', style: _header))),
                Expanded(flex: 2, child: Center(child: Text('VIEWED', style: _header))),
                Expanded(flex: 3, child: Center(child: Text('RESPONDED', style: _header))),
                Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text('INVITED', style: _header))),
              ],
            ),
            const Divider(height: 14),
            for (final inv in invitations) _InvitationRow(inv),
          ],
        ],
      ),
    );
  }
}

class _InvitationRow extends StatelessWidget {
  const _InvitationRow(this.inv);
  final BidInvitationModel inv;

  Color get _color => switch (inv.status) {
        InvitationStatus.pending => AppColors.primaryOrange,
        InvitationStatus.viewed => kBidGrey,
        InvitationStatus.responded => kBidGreen,
        InvitationStatus.declined => AppColors.redColor,
      };

  String _d(DateTime? d) => d == null ? '-' : _shortFmt.format(d);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(inv.subcontractor,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(inv.status.label,
                    style: TextStyle(
                        fontSize: 8, fontWeight: FontWeight.w700, color: _color)),
              ),
            ),
          ),
          Expanded(flex: 2, child: Center(child: Text(_d(inv.viewedAt), style: const TextStyle(fontSize: 10)))),
          Expanded(flex: 3, child: Center(child: Text(_d(inv.respondedAt), style: const TextStyle(fontSize: 10)))),
          Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text(_d(inv.invitedAt), style: const TextStyle(fontSize: 10)))),
        ],
      ),
    );
  }
}

class BidResponsesTab extends StatelessWidget {
  const BidResponsesTab({super.key, required this.responses});

  final List<BidResponseModel> responses;

  @override
  Widget build(BuildContext context) {
    if (responses.isEmpty) {
      return const BidEmptyPanel(
        icon: Icons.description_outlined,
        message: 'No Bid Responses received yet',
      );
    }
    return Column(
      children: [
        for (final r in responses)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: BidCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.subcontractor,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        Text('Submitted ${_shortFmt.format(r.submittedAt)}',
                            style: TextStyle(
                                fontSize: 10, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Text(_money(r.amount),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryOrange)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class BidQaTab extends StatelessWidget {
  const BidQaTab({super.key, required this.questions});

  final List<BidQuestionModel> questions;

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const BidEmptyPanel(
        icon: Icons.chat_bubble_outline,
        message: 'No Questions received yet',
      );
    }
    return Column(
      children: [
        for (final q in questions)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: BidCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${q.askedBy} · ${_shortFmt.format(q.askedAt)}',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  const SizedBox(height: 4),
                  Text(q.question,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  if (q.answer != null) ...[
                    const SizedBox(height: 6),
                    Text(q.answer!, style: const TextStyle(fontSize: 11)),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
