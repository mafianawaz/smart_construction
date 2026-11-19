import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_icons.dart';
import '../models/cost_record_model.dart';
import 'cost_colors.dart';
import 'cost_stat_cell.dart';
import 'cost_tag.dart';

final _money = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
final _iso = DateFormat('yyyy-MM-dd');

/// Summary-tab card: aggregated min/max/avg for one scope + trade + code.
class CostSummaryCard extends StatelessWidget {
  final CostSummaryGroup group;
  const CostSummaryCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CostColors.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.scopeCategory,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text('Trade: ${group.trade}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700)),
                  ],
                ),
              ),
              CostTag(label: 'Code ${group.costCode}', style: CostTagStyle.orange),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: CostColors.border),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: CostStatCell(
                  label: 'AVG \$/UNIT',
                  value: _money.format(group.avgUnitCost),
                  valueColor: AppColors.primaryOrange),
            ),
            Expanded(
              child: CostStatCell(
                  label: 'MIN \$/UNIT',
                  value: _money.format(group.minUnitCost),
                  valueColor: CostColors.min),
            ),
            Expanded(
              child: CostStatCell(
                  label: 'MAX \$/UNIT',
                  value: _money.format(group.maxUnitCost),
                  valueColor: AppColors.redColor),
            ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: CostStatCell(
                  label: 'TOTAL QTY',
                  value:
                      '${group.totalQty.toStringAsFixed(2)} ${group.unit}'),
            ),
            Expanded(
              child: CostStatCell(
                  label: 'TOTAL COST', value: _money.format(group.totalCost)),
            ),
            Expanded(
              child: CostStatCell(
                  label: 'RECORDS', value: '${group.recordCount}'),
            ),
          ]),
          const SizedBox(height: 12),
          const Divider(height: 1, color: CostColors.border),
          const SizedBox(height: 10),
          Row(children: [
            SvgPicture.asset(AppIcons.calendar, height: 13, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              '${_iso.format(group.firstDate)} — ${_iso.format(group.lastDate)}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
            ),
          ]),
        ],
      ),
    );
  }
}
