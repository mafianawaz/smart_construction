import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';

class ExpiredBanner extends StatelessWidget {
  final String message;

  const ExpiredBanner({
    super.key,
    this.message = 'This bid request has expired and is no longer '
        'accepting responses.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.redColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.redColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: AppColors.redColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: AppColors.redColor, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
