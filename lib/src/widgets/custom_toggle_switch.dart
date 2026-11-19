import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_construction/src/utils/app_color.dart';

// class CustomToggle extends StatelessWidget {
//   final List<String> options;
//   final int selectedIndex;
//   final ValueChanged<int> onChanged;
//   final bool isIconToggle;
//   final bool isColored;
//   final List<String> toggleIcon;
//
//   const CustomToggle({
//     super.key,
//     required this.options,
//     required this.selectedIndex,
//     required this.onChanged,
//     this.isIconToggle = false,
//     this.isColored = false,
//     this.toggleIcon = const [],
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(5),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: Colors.grey.shade100,
//       ),
//       child: Row(
//         children: List.generate(options.length, (index) {
//           final isSelected = index == selectedIndex;
//
//           final textColor = isColored
//               ? (isSelected ? Colors.white : Colors.black)
//               : (isSelected ? Colors.black : Colors.grey);
//
//           final bgColor = isColored
//               ? (isSelected ? AppColors.primaryOrange : Colors.grey.shade100)
//               : (isSelected ? AppColors.background : Colors.grey.shade100);
//
//           return Expanded(
//             child: GestureDetector(
//               onTap: () => onChanged(index),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 250),
//                 curve: Curves.easeInOut,
//                 padding: const EdgeInsets.symmetric(vertical: 13),
//                 decoration: BoxDecoration(
//                   color: bgColor,
//                   // isSelected
//                   //     ? AppColors.background
//                   //     : Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 alignment: Alignment.center,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (isIconToggle)
//                       SvgPicture.asset(
//                         toggleIcon[index],
//                         color: textColor,
//                         height: 15,
//                       ),
//                     if (isIconToggle) const SizedBox(width: 5),
//                     Text(
//                       options[index],
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: textColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

class CustomToggle extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final bool isIconToggle;
  final bool isColored;
  final List<String> toggleIcon;
  final bool scrollable;

  const CustomToggle({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    this.isIconToggle = false,
    this.isColored = false,
    this.toggleIcon = const [],
    this.scrollable = true,
  });

  double _measureTextWidth(
      String text,
      TextStyle style,
      TextDirection textDirection,
      ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: textDirection,
    )..layout();

    return painter.width;
  }

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return const SizedBox.shrink();
    }

    final textDirection = Directionality.of(context);

    const textStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
    );

    final widths = List.generate(options.length, (index) {
      final textWidth = _measureTextWidth(
        options[index],
        textStyle,
        textDirection,
      );

      final iconWidth =
      isIconToggle && index < toggleIcon.length ? 20.0 : 0.0;

      return textWidth + iconWidth + 24.0;
    });

    final minWidth = widths.reduce(
          (a, b) => a < b ? a : b,
    );

    final flexValues = widths.map((width) {
      return ((width / minWidth) * 100)
          .round()
          .clamp(1, 10000);
    }).toList();

    final useScroll = scrollable && options.length > 2;

    final items = List.generate(options.length, (index) {
      final isSelected = index == selectedIndex;

      final textColor = isColored
          ? (isSelected ? Colors.white : Colors.black)
          : (isSelected ? Colors.black : Colors.grey);

      final bgColor = isColored
          ? (isSelected
          ? AppColors.primaryOrange
          : Colors.grey.shade100)
          : (isSelected
          ? AppColors.background
          : Colors.grey.shade100);

      final item = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(
              horizontal: useScroll ? 14 : 8,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isIconToggle && index < toggleIcon.length) ...[
                  SvgPicture.asset(
                    toggleIcon[index],
                    colorFilter: ColorFilter.mode(
                      textColor,
                      BlendMode.srcIn,
                    ),
                    height: 15,
                    width: 15,
                  ),
                  const SizedBox(width: 5),
                ],
                Text(
                  options[index],
                  maxLines: 1,
                  softWrap: false,
                  style: textStyle.copyWith(color: textColor),
                ),
              ],
            ),
          ),
        ),
      );

      if (useScroll) {
        return item;
      }

      return Expanded(
        flex: flexValues[index],
        child: item,
      );
    });

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade100,
      ),
      child: useScroll
          ? SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: items,
        ),
      )
          : Row(
        children: items,
      ),
    );
  }
}

