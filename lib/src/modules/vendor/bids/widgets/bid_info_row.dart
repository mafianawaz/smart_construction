import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

class BidInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final String? caption;

  const BidInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.w600,),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: valueColor,
            ),
          ),
          if (caption != null) ...[
            const SizedBox(height: 2),
            Text(
              caption!,
              style: TextStyle(
                fontSize: 12,
                color: valueColor ?? AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
