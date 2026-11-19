import 'package:flutter/material.dart';

import '../models/cfo_models.dart';
import 'cfo_palette.dart';
import 'cfo_section.dart';
import 'cfo_stat_grid.dart';

/// One organisation: avatar, name, org type and an expand chevron; expanded it
/// shows the Projects / Change Orders / Open Bids / Accounts Receivable grids.
class CfoOrgCard extends StatelessWidget {
  const CfoOrgCard({
    super.key,
    required this.org,
    required this.expanded,
    required this.onToggle,
  });

  final CfoOrgSummary org;
  final bool expanded;
  final VoidCallback onToggle;

  /// Collection rate colouring is my own rule (the reference only shows 0.0%
  /// in red): below 50 red, below 80 orange, otherwise green.
  static Color _rateColor(double rate) {
    if (rate < 50) return CfoPalette.red;
    if (rate < 80) return CfoPalette.orange;
    return CfoPalette.green;
  }

  @override
  Widget build(BuildContext context) {
    final p = org.projects;
    final co = org.changeOrders;
    final b = org.bids;
    final ar = org.receivables;

    return Container(
      decoration: BoxDecoration(
        color: CfoPalette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CfoPalette.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  _Avatar(initials: org.initials),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          org.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: CfoPalette.text,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          org.orgType,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            letterSpacing: 0.4,
                            color: CfoPalette.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: const Icon(Icons.keyboard_arrow_down,
                        color: CfoPalette.muted),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 180),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CfoSection(
                    title: 'PROJECTS',
                    columns: 3,
                    stats: [
                      CfoStat('Total', formatCount(p.total)),
                      CfoStat('Active', formatCount(p.active),
                          valueColor: CfoPalette.green),
                      CfoStat('Completed', formatCount(p.completed)),
                      CfoStat('Planning', formatCount(p.planning),
                          valueColor: CfoPalette.blue),
                      CfoStat('Total Contract', formatMoney(p.totalContract)),
                      CfoStat('Active Contract', formatMoney(p.activeContract),
                          valueColor: CfoPalette.orange),
                    ],
                  ),
                  const SizedBox(height: 14),
                  CfoSection(
                    title: 'CHANGE ORDERS',
                    columns: 3,
                    stats: [
                      CfoStat('Pending', formatCount(co.pending),
                          valueColor: CfoPalette.orange),
                      CfoStat('Approved', formatCount(co.approved),
                          valueColor: CfoPalette.green),
                      CfoStat('Approved Value', formatMoney(co.approvedValue)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  CfoSection(
                    title: 'OPEN BIDS',
                    columns: 2,
                    stats: [
                      CfoStat('Count', formatCount(b.count)),
                      CfoStat('Pipeline Value', formatMoney(b.pipelineValue)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  CfoSection(
                    title: 'ACCOUNTS RECEIVABLE',
                    columns: 2,
                    stats: [
                      CfoStat('Outstanding AR', formatMoney(ar.outstanding)),
                      CfoStat('Overdue AR', formatMoney(ar.overdue),
                          valueColor: ar.overdue > 0 ? CfoPalette.red : null),
                      CfoStat('Collection Rate', formatRate(ar.collectionRate),
                          valueColor: _rateColor(ar.collectionRate)),
                      CfoStat('Open CO Value', formatMoney(ar.openCoValue)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: CfoPalette.orangeSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: CfoPalette.orange,
        ),
      ),
    );
  }
}
