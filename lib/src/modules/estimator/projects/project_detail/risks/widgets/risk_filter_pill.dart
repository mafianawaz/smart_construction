import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

/// Dropdown pill filter, generic over any enum-like type with a
/// `.label`. Mirrors the "All Statuses" pill used on the Projects list,
/// but supports outline (unselected look) as well as filled.
class RiskFilterPill<T> extends StatelessWidget {
  final String allLabel;
  final T? value;
  final List<T> options;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;
  final bool filled;

  const RiskFilterPill({
    super.key,
    required this.allLabel,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onChanged,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = filled ? AppColors.primaryOrange : Colors.white;
    final fg = filled ? Colors.white : AppColors.textDark;
    return PopupMenuButton<T?>(
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (context) => [
        PopupMenuItem<T?>(value: null, child: Text(allLabel)),
        for (final o in options) PopupMenuItem<T?>(value: o, child: Text(labelOf(o))),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: filled ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value == null ? allLabel : labelOf(value as T),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 16, color: fg),
          ],
        ),
      ),
    );
  }
}
