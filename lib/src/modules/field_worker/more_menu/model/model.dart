import 'package:flutter/material.dart';

/// Defines how a [MoreMenuItem] behaves when tapped.
enum MoreMenuItemType {
  /// Tapping navigates directly to another screen (chevron-right).
  direct,

  /// Tapping expands/collapses [children] inline (chevron-down/up).
  expandable,
}

/// Data model for a single row in a reusable "More" style menu.
///
/// This is intentionally screen-agnostic: it carries only display data
/// and callbacks, no business logic. The same [MoreMenuList] /
/// [MoreMenuTile] pair can therefore render:
///  - a flat list where every row navigates directly (e.g. Manage Time
///    Clock, Calendar, Tasks, ... each with a leading icon), and
///  - a mixed list where some rows (Finance, Reports, Calculator, Home)
///    expand inline to show sub-items (Executive Digest, Bulletins),
///    while others (Account Settings) still navigate directly.
class MoreMenuItem {
  const MoreMenuItem({
    required this.id,
    required this.label,
    this.icon,
    this.iconBackgroundColor,
    this.type = MoreMenuItemType.direct,
    this.onTap,
    this.children = const [],
    this.isDestructive = false,
  }) : assert(
  type != MoreMenuItemType.expandable || children.length > 0,
  'Expandable items must provide at least one child in `children`.',
  );

  /// Stable identifier, used internally to track expansion state.
  /// Must be unique within a single [MoreMenuList].
  final String id;

  final String label;

  /// Optional leading icon shown inside a rounded color chip.
  /// Leave null for rows without an icon (e.g. "Executive Digest",
  /// "Bulletins" in the expandable-menu screenshot).
  final String? icon;

  /// Background color of the icon chip. Ignored if [icon] is null.
  final Color? iconBackgroundColor;

  final MoreMenuItemType type;

  /// Called when this is a [MoreMenuItemType.direct] row and it's tapped.
  /// Not used for [MoreMenuItemType.expandable] rows (tapping those
  /// toggles expansion instead).
  final VoidCallback? onTap;

  /// Sub-rows revealed when an [MoreMenuItemType.expandable] row is
  /// expanded. Each child is itself a [MoreMenuItem], so children can
  /// have their own icon or even nested behavior if ever needed.
  final List<MoreMenuItem> children;

  /// Styles the row in a destructive color (used for "Logout").
  final bool isDestructive;
}