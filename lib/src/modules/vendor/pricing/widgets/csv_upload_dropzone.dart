import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_construction/src/utils/app_icons.dart';

import '../../../../utils/app_color.dart';

/// Dashed-border drop zone shown in step 3 of the bulk upload flow.
/// Flutter has no built-in dashed border, so this paints one with a
/// CustomPainter rather than pulling in a package for a single visual.
class CsvUploadDropzone extends StatelessWidget {
  final String? fileName;
  final VoidCallback onBrowse;
  final VoidCallback? onClear;

  const CsvUploadDropzone({
    super.key,
    required this.fileName,
    required this.onBrowse,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(color: AppColors.primaryOrange),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.primaryOrange.withOpacity(0.15),
              child: SvgPicture.asset(AppIcons.docs, color: AppColors.primaryOrange),
            ),
            const SizedBox(height: 10),
            Text(
              fileName ?? 'Drag and drop your CSV file here, or click to browse',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onBrowse,
              child: Text(fileName == null ? 'Select CSV File' : 'Change File', style: TextStyle(color: AppColors.textDark),),
            ),
            if (fileName != null && onClear != null)
              TextButton(
                onPressed: onClear,
                child: const Text('Remove file', style: TextStyle(color: AppColors.textMuted),),
              ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double gap;
  final double radius;

  _DashedBorderPainter({required this.color, this.gap = 6, this.radius = 12});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final dashed = Path();

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + gap;
        dashed.addPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          Offset.zero,
        );
        distance += gap * 2;
      }
    }
    canvas.drawPath(dashed, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
