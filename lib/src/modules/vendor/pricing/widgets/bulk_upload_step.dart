import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';

/// One step in the bulk-upload flow: a numbered circle, title,
/// description, and optional action widget (a button or drop zone)
/// below it. [showConnector] draws the vertical line down to the next
/// step, matching the reference screen's connected-circle look.

class BulkUploadStep extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  final Widget? action;
  final bool showConnector;
  const BulkUploadStep({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    this.action,
    this.showConnector = true,
  });
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 26,
            child: Column(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryOrange,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (showConnector)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.black12,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  if (action != null) ...[const SizedBox(height: 10), action!],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
