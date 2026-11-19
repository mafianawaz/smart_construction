import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

/// Numbered circle + connecting line stepper shown at the top of every
/// wizard screen. Takes labels + [currentIndex] (not a fixed enum) so
/// the AI flow (4 steps) and the manual flow (3 steps) both render
/// correctly. Steps before [currentIndex] show as completed.
class BidStepIndicator extends StatelessWidget {
  final List<String> stepLabels;
  final int currentIndex;

  const BidStepIndicator({
    super.key,
    required this.stepLabels,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final count = stepLabels.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(count * 2 - 1, (i) {
          if (i.isOdd) {
            final leftIndex = (i - 1) ~/ 2;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  height: 2,
                  color: leftIndex < currentIndex
                      ? AppColors.primaryOrange
                      : Colors.grey.shade300,
                ),
              ),
            );
          }

          final index = i ~/ 2;
          final isDone = index < currentIndex;
          final isCurrent = index == currentIndex;

          return SizedBox(
            width: 52,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone || isCurrent
                        ? AppColors.primaryOrange
                        : Colors.grey.shade200,
                  ),
                  alignment: Alignment.center,
                  child: isDone
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color:
                                isCurrent ? Colors.white : Colors.grey.shade600,
                          ),
                        ),
                ),
                const SizedBox(height: 4),
                Text(
                  stepLabels[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isCurrent
                        ? AppColors.primaryOrange
                        : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
