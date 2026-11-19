import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

/// LiDAR Scan tab — the reference shows a single "Feature Not Available /
/// This feature is currently disabled" card. Static on purpose: when the
/// feature ships, replace the body with the real scan list.
class LidarScanView extends StatelessWidget {
  final String projectId;
  const LidarScanView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.fieldBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Feature Not Available',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('This feature is currently disabled',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ],
          ),
        ),
      ),
    );
  }
}
