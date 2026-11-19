import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import '../../../../utils/app_color.dart';
import '../models/cost_record_model.dart';
import 'cost_colors.dart';
import 'cost_stat_cell.dart';
import 'cost_tag.dart';

final _money = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

/// Detailed-tab card: one line item with delete action.
class CostRecordCard extends StatelessWidget {
  final CostRecordModel record;
  final VoidCallback onDelete;

  const CostRecordCard({super.key, required this.record, required this.onDelete});

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
                child: Text(record.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
              ),
              GestureDetector(
                onTap: onDelete,
                child: Icon(Icons.delete_outline_rounded,
                    size: 20, color: AppColors.redColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: [
            CostTag(label: record.scopeCategory.toUpperCase()),
            CostTag(label: record.trade, style: CostTagStyle.orange),
          ]),
          const SizedBox(height: 10),
          const Divider(height: 1, color: CostColors.border),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: CostStatCell(
                  label: 'QTY',
                  value:
                      '${record.quantity.toStringAsFixed(2)} ${record.unit}'),
            ),
            Expanded(
              child: CostStatCell(
                  label: '\$/UNIT', value: _money.format(record.unitCost)),
            ),
            Expanded(
              child: CostStatCell(
                  label: 'TOTAL',
                  value: _money.format(record.totalCost),
                  valueColor: AppColors.primaryOrange),
            ),
          ]),
          if (record.projectName.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: CostColors.border),
            const SizedBox(height: 10),
            Row(children: [
              SvgPicture.asset(AppIcons.calendar, height: 13, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Expanded(
                child: Text(record.projectName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
              ),
            ]),
          ],
        ],
      ),
    );
  }
}
