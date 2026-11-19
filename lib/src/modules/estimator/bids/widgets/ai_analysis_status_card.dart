import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'dashed_border_box.dart';

/// "Analyzing" spinner state or "AI Analysis Failed" state on the AI
/// Scan step. Which one renders is controller-driven ([AiAnalysisStatus]).
class AiAnalysisStatusCard extends StatelessWidget {
  final bool isFailed;
  final VoidCallback? onRetry;
  final VoidCallback? onManualEntry;
  final VoidCallback? onSkipToScope;

  const AiAnalysisStatusCard.analyzing({super.key})
      : isFailed = false,
        onRetry = null,
        onManualEntry = null,
        onSkipToScope = null;

  const AiAnalysisStatusCard.failed({
    super.key,
    required this.onRetry,
    required this.onManualEntry,
    required this.onSkipToScope,
  }) : isFailed = true;

  @override
  Widget build(BuildContext context) {
    if (!isFailed) {
      return DashedBorderBox(
        color: AppColors.primaryOrange.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 56),
          child: Column(
            children: [
              CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.primaryOrange,
              ),
              const SizedBox(height: 16),
              const Text(
                'Analyzing your documents…',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'This usually takes a few seconds',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        DashedBorderBox(
          color: AppColors.primaryOrange.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.redColor.withOpacity(0.08),
                  child: Icon(Icons.warning_amber_rounded,
                      color: AppColors.redColor, size: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  'AI Analysis Failed',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.redColor,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.error_outline,
                          size: 16, color: AppColors.primaryOrange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "We couldn't read the uploaded document. It may be "
                          'corrupted or in an unsupported format.',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.primaryOrange),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'You can try again with a clearer scan, or enter the scope '
                  'of work manually instead.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onRetry,
                        child: const Text('Retry Analysis'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onManualEntry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Manual Entry'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onSkipToScope,
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Skip To Scope'),
          ),
        ),
      ],
    );
  }
}
