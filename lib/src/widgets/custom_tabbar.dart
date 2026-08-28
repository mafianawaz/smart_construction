import 'package:flutter/material.dart';

import '../utils/app_color.dart';

class CustomTabItem {
  const CustomTabItem({
    this.label,
    this.icon,
    this.activeIcon,
    this.enabled = true,
  });

  final String? label;
  final IconData? icon;
  final IconData? activeIcon;
  final bool enabled;
}

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.height = 56,
    this.activeColor = AppColors.primaryOrange,
    this.inactiveColor = AppColors.textMuted,
    this.indicatorHeight = 2,
    this.indicatorWidth,
    this.iconSize = 18,
    this.gap = 6,
    this.tabPadding = const EdgeInsets.symmetric(horizontal: 14),
    this.backgroundColor = AppColors.background,
    this.borderColor = AppColors.fieldBorder,
    this.showBottomBorder = true,
    this.scrollable = true,
    this.labelStyle,
    this.activeLabelStyle,
    this.spacing = 4,
  });

  final List<CustomTabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  final double height;

  final Color activeColor;
  final Color inactiveColor;

  final double indicatorHeight;
  final double? indicatorWidth;

  final double iconSize;
  final double gap;

  final EdgeInsets tabPadding;

  final Color backgroundColor;
  final Color borderColor;
  final bool showBottomBorder;

  final bool scrollable;

  final TextStyle? labelStyle;
  final TextStyle? activeLabelStyle;

  final double spacing;

  @override
  Widget build(BuildContext context) {
    final tabsWidget = Row(
      mainAxisSize: scrollable ? MainAxisSize.min : MainAxisSize.max,
      children: List.generate(
        tabs.length,
            (index) => _buildTab(
          context,
          tabs[index],
          index,
        ),
      ),
    );

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: showBottomBorder
            ? Border(
          bottom: BorderSide(
            color: borderColor,
            width: 1,
          ),
        )
            : null,
      ),
      child: scrollable
          ? SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: tabsWidget,
      )
          : tabsWidget,
    );
  }

  Widget _buildTab(
      BuildContext context,
      CustomTabItem tab,
      int index,
      ) {
    final bool isSelected = index == selectedIndex;
    final bool isEnabled = tab.enabled;

    final Color color = !isEnabled
        ? inactiveColor.withValues(alpha: 0.45)
        : isSelected
        ? activeColor
        : inactiveColor;

    final IconData? icon = isSelected
        ? (tab.activeIcon ?? tab.icon)
        : tab.icon;

    final bool hasIcon = icon != null;
    final bool hasLabel = tab.label != null && tab.label!.isNotEmpty;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isEnabled ? () => onChanged(index) : null,
      child: Container(
        height: height,
        padding: tabPadding,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasIcon)
                  Icon(
                    icon,
                    size: iconSize,
                    color: color,
                  ),

                if (hasIcon && hasLabel)
                  SizedBox(width: gap),

                if (hasLabel)
                  Text(
                    tab.label!,
                    style: isSelected
                        ? (activeLabelStyle ??
                        labelStyle ??
                        TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ))
                        : (labelStyle ??
                        TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
              ],
            ),

            // Active indicator
            if (isSelected)
              Positioned(
                bottom: 0,
                left: indicatorWidth == null ? 0 : null,
                right: indicatorWidth == null ? 0 : null,
                child: Container(
                  width: indicatorWidth,
                  height: indicatorHeight,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(
                      indicatorHeight,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}