import 'package:flutter/material.dart';

import '../utils/app_color.dart';

/// A soft, half-clipped accent circle used to decorate splash/auth
/// backgrounds. Positioned with negative offsets so only an arc of the
/// circle is visible inside the screen bounds.
class DecorativeCircle extends StatelessWidget {
  const DecorativeCircle({
    super.key,
    required this.diameter,
    required this.alignment,
    this.offsetX = 0,
    this.offsetY = 0,
    this.color = AppColors.accentPeach,
  });

  final double diameter;
  final Alignment alignment;
  final double offsetX;
  final double offsetY;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: Offset(offsetX, offsetY),
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}