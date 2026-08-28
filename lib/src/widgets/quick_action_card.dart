import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_construction/src/utils/app_color.dart';

class QuickActionItem {
  const QuickActionItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.iconColor = const Color(0xFFFF6B00),
  });

  final String label;
  final String icon;
  final VoidCallback onTap;

  final Color iconColor;
}

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    super.key,
    required this.items,
    this.spacing = 15,
    this.backgroundColor = Colors.white,
  });

  final List<QuickActionItem> items;

  final double spacing;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: Colors.black.withOpacity(0.08),
          ),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(6, 0),
            color: Colors.black.withOpacity(0.08),
          ),
        ]
      ),
      child: Row(
        children: List.generate(
          items.length,
              (index) {
            final item = items[index];

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == items.length - 1 ? 0 : spacing,
                ),
                child: _QuickActionItemView(
                  item: item,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuickActionItemView extends StatelessWidget {
  const _QuickActionItemView({
    required this.item,
  });

  final QuickActionItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: item.iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: item.iconColor,
                      borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            offset: const Offset(7, 0),
                            color: Colors.black.withOpacity(0.07),
                          ),
                        ]
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        item.icon,
                        color: Colors.white,
                        // height: 20,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}