import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

/// Full-width bordered select (popup menu) for fields that have no heading
/// above them — the Cost Explorer's "All Categories" / "All Modules" /
/// "By Cost Code" and Daily Notes' "Materials Usage Tracking".
/// `ProjectDropdown` always renders a heading, so this is used instead.
/// Shows [allLabel] when nothing is selected; with [allowClear] the menu's
/// first entry resets to it. [muted] greys the label for placeholder-style
/// fields.
class ProjectSelectField<T> extends StatelessWidget {
  final String allLabel;
  final T? value;
  final List<T> options;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;
  final bool allowClear;
  final bool muted;

  const ProjectSelectField({
    required this.allLabel,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onChanged,
    this.allowClear = true,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T?>(
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (context) => [
        if (allowClear) PopupMenuItem<T?>(value: null, child: Text(allLabel)),
        for (final o in options) PopupMenuItem<T?>(value: o, child: Text(labelOf(o))),
      ],
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value == null ? allLabel : labelOf(value as T),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: (muted && value == null) ? Colors.grey.shade500 : Colors.grey.shade700,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}
