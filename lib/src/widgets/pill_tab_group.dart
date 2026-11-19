import 'package:flutter/material.dart';

import '../utils/app_color.dart';

/// Generic config item for [PillTabGroup]. `T` is whatever value type the
/// screen uses to represent a tab (an enum is the common case).
///
/// Screens never subclass or branch inside the widget — they just supply a
/// `List<PillTabItem<T>>` and read back the selected value via [onChanged].
class PillTabItem<T> {
  final T value;
  final String label;

  const PillTabItem({required this.value, required this.label});
}

/// Visual treatment for the tab group.
///
/// - [filled]     solid pill, orange when selected (e.g. the top-level
///                "Unit Converter / Concrete & Materials / Masonry" bar).
/// - [segmented]  light track with a white "thumb" pill for the selected
///                item (e.g. the "Length / Area / Volume" sub-switcher).
enum PillTabStyle { filled, segmented }

/// Screen-agnostic tab/category selector.
///
/// This widget contains no role, screen, or feature logic — it is driven
/// entirely by [items] + [selectedValue] and reports selection changes via
/// [onChanged]. It can be reused for any category/subcategory switcher
/// anywhere in the app (Calculator categories, filters, segmented toggles,
/// etc.) by simply passing a different `T` and item list.
class PillTabGroup<T> extends StatelessWidget {
  const PillTabGroup({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.style = PillTabStyle.filled,
    this.scrollable = true,
    this.fillWidth = false,
    this.spacing = 8,
  });

  final List<PillTabItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final PillTabStyle style;

  /// Wrap in a horizontally scrolling row. Typically true for [PillTabStyle.filled]
  /// bars with many/long labels, false for a fixed 2-4 item [PillTabStyle.segmented] switcher.
  final bool scrollable;

  /// When true (and not [scrollable]), each item expands to share width evenly.
  /// Matches the "Length | Area | Volume" segmented look.
  final bool fillWidth;

  final double spacing;

  @override
  Widget build(BuildContext context) {
    final content = style == PillTabStyle.filled ? _buildFilled() : _buildSegmented();

    if (!scrollable) return content;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: content,
    );
  }

  Widget _buildFilled() {
    return Row(
      mainAxisSize: scrollable ? MainAxisSize.min : MainAxisSize.max,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (fillWidth) Expanded(child: _filledChip(items[i])) else _filledChip(items[i]),
          if (i != items.length - 1) SizedBox(width: spacing),
        ],
      ],
    );
  }

  Widget _filledChip(PillTabItem<T> item) {
    final selected = item.value == selectedValue;
    return GestureDetector(
      onTap: () => onChanged(item.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryOrange : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Text(
          item.label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textMuted,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSegmented() {
    final row = Row(
      mainAxisSize: fillWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (fillWidth) Expanded(child: _segmentedChip(items[i])) else _segmentedChip(items[i]),
        ],
      ],
    );

    return row;
  }

  Widget _segmentedChip(PillTabItem<T> item) {
    final selected = item.value == selectedValue;
    return GestureDetector(
      onTap: () => onChanged(item.value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.grey.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          item.label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected ? AppColors.primaryOrange : Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
