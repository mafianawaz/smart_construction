import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_icons.dart';

/// The circular white "Smart Manage AI" logo badge shown on splash and
/// login. Swap the child for an Image.asset/SvgPicture once brand assets
/// are available — kept as a styled placeholder for now.
class LogoBadge extends StatelessWidget {
  const LogoBadge({super.key, this.size = 84});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child:  CircleAvatar(
        backgroundColor: Colors.white,
        child: Image.asset(
          AppImages.appLogo,
        ),
      ),
    );
  }
}