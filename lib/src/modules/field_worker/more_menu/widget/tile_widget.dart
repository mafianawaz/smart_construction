import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/utils/app_icons.dart';

import '../model/model.dart';


/// Renders a single row of a [MoreMenuList].
///
/// Swap in your project's `AppColors` for the hardcoded colors below to
/// match the rest of the app (e.g. `AppColors.textPrimary`,
/// `AppColors.divider`, `AppColors.error` for the destructive/logout
/// color, per NOTES.md).
class MoreMenuTile extends StatelessWidget {
  const MoreMenuTile({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.onExpandToggle,
    this.isChild = false,
    this.showDivider = true,
  });

  final MoreMenuItem item;
  final bool isExpanded;
  final ValueChanged<String> onExpandToggle;

  /// True when this tile is being rendered as a sub-item of an
  /// expanded parent (adds indent + muted styling, no icon chip gap).
  final bool isChild;

  final bool showDivider;

  bool get _isExpandable => item.type == MoreMenuItemType.expandable;

  @override
  Widget build(BuildContext context) {
    final Color textColor = item.isDestructive
        ? Colors.red
        : (isChild ? Colors.black54 : Colors.black87);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (_isExpandable) {
              onExpandToggle(item.id);
            } else {
              item.onTap?.call();
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: item.iconBackgroundColor ?? Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(6, 0),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(item.icon ?? AppIcons.clock, height: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                ],
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: isChild ? 13 : 14,
                      fontWeight: isChild ? FontWeight.w400 : FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                Icon(
                  _isExpandable
                      ? (isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down)
                      : Icons.chevron_right,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
        if (_isExpandable)
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Column(
              children: item.children
                  .map(
                    (child) => MoreMenuTile(
                  item: child,
                  isExpanded: false,
                  onExpandToggle: onExpandToggle,
                  isChild: true,
                ),
              )
                  .toList(),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
          ),
        if (showDivider)
          Divider(height: 1, indent: isChild ? 56 : 16, endIndent: 16, color: Colors.grey.shade200),
      ],
    );
  }
}

/// Reusable, screen-agnostic "More" menu card.
///
/// Pass it a flat [items] list and it correctly renders either layout
/// from the designs:
///  - every item `MoreMenuItemType.direct` -> flat list, chevron-right
///    on every row (the Manage Time Clock / Calendar / Tasks screen).
///  - a mix of `MoreMenuItemType.expandable` (Home, Finance, Reports,
///    Calculator) and `MoreMenuItemType.direct` (Account Settings) ->
///    accordion behavior, matching the second screenshot.
///
/// Expansion state is tracked internally (plain `setState`, no GetX
/// controller needed) so screens don't have to manage it — same
/// "caller passes data, widget owns its own presentation state"
/// approach as elsewhere in the app.
///
/// For the red "Logout" row, put it in its own `MoreMenuList` with a
/// single `MoreMenuItem(isDestructive: true, ...)` and a `SizedBox`
/// gap above it, matching the separate card in both screenshots.
class MoreMenuList extends StatefulWidget {
  const MoreMenuList({
    super.key,
    required this.items,
    this.initiallyExpandedIds = const {},
    this.borderRadius = 16,
    this.backgroundColor = Colors.white,
  });

  final List<MoreMenuItem> items;

  /// IDs of items that should start expanded (e.g. {'home'} to match
  /// the second screenshot, where Home is expanded by default).
  final Set<String> initiallyExpandedIds;

  final double borderRadius;
  final Color backgroundColor;

  @override
  State<MoreMenuList> createState() => _MoreMenuListState();
}

class _MoreMenuListState extends State<MoreMenuList> {
  late final Set<String> _expandedIds = {...widget.initiallyExpandedIds};

  void _toggle(String id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(5, 0),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < widget.items.length; i++)
            MoreMenuTile(
              item: widget.items[i],
              isExpanded: _expandedIds.contains(widget.items[i].id),
              onExpandToggle: _toggle,
              showDivider: i != widget.items.length - 1,
            ),
        ],
      ),
    );
  }
}