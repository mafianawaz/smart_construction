import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/time_tracking_models.dart';

/// Purely presentational warning banner. Screen-agnostic: all state
/// (status, retry behavior, copy) is supplied by the caller.
class GpsStatusBanner extends StatelessWidget {
  final GpsStatus status;
  final VoidCallback onRetry;
  final String title;
  final String message;

  const GpsStatusBanner({
    super.key,
    required this.status,
    required this.onRetry,
    this.title = 'GPS Unavailable',
    this.message = 'Location access denied.',
  });

  @override
  Widget build(BuildContext context) {
    if (status != GpsStatus.unavailable) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow.withOpacity(0.10),
        border: Border.all(color: Colors.yellow.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.primaryOrangeDark, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 2),
                Text(message, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(height: 6),
                InkWell(
                  onTap: onRetry,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh, size: 14, color: AppColors.primaryOrangeDark),
                      const SizedBox(width: 4),
                      Text(
                        'Retry',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryOrangeDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
