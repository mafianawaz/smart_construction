import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/modules/vendor/pricing/models/pricing_status.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import '../../../../utils/app_color.dart';
import '../../../field_worker/my_task/widget/pill_chip.dart';
import '../models/pricing_item_model.dart';

class PricingItemCard extends StatelessWidget {
  final PricingItemModel item;
  final VoidCallback? onEdit;

  const PricingItemCard({super.key, required this.item, this.onEdit});

  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static final _currencyFormat = NumberFormat.currency(symbol: '\$');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.fieldBorder)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                _currencyFormat.format(item.unitPrice),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // Only a pending item can still be edited — see
              // PricingStatus.isEditable.
              if (item.status.isEditable && onEdit != null) ...[
                const SizedBox(width: 6),
                InkWell(
                  onTap: onEdit,
                  child: const Icon(Icons.edit_outlined, size: 16),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          _row('Code', item.code),
          _row('Category', item.subCategory),
          _row('Unit', item.unit),
          const SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset(AppIcons.complete,height: 16, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                _dateFormat.format(item.submittedAt),
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const Spacer(),
              WhitePillChip(label: item.status.label.toUpperCase(), color: item.status.color,),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
