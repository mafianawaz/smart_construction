import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_construction/src/utils/app_icons.dart';

class PillChipWidget extends StatelessWidget {
  final String label;
  final String? icon;
  final Color color;
  final bool filled;



  const PillChipWidget({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.filled = false
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: filled ?
      Row(
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ):
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          filled ?
          SizedBox() :
          SvgPicture.asset(icon ?? AppIcons.ai, height: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
