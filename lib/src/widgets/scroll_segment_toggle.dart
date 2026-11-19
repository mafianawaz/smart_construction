import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

/// Segmented pill toggle that scrolls horizontally when its labels don't
/// fit (the reference cuts "Critical Path" / "Reports" off at the edge).
/// When they do fit, every segment is at least `track width / count`, so
/// a 2-way toggle renders as two equal halves.
///
/// [colored] = orange track with white labels (the Reports sub-tabs);
/// otherwise a grey track (everything else). The selected segment is a
/// white pill in both.
class ScrollSegmentToggle<T> extends StatelessWidget {
  final List<T> values;
  final String Function(T) labelOf;
  final T selected;
  final ValueChanged<T> onChanged;
  final bool colored;

  const ScrollSegmentToggle({
    super.key,
    required this.values,
    required this.labelOf,
    required this.selected,
    required this.onChanged,
    this.colored = false,
  });

  @override
  Widget build(BuildContext context) {
    final trackColor = colored ? AppColors.primaryOrange : const Color(0xFFF1F2F4);
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minSegment = constraints.maxWidth / values.length;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final v in values)
                    _Segment(
                      label: labelOf(v),
                      isSelected: v == selected,
                      minWidth: minSegment,
                      colored: colored,
                      onTap: () => onChanged(v),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final bool isSelected;
  final double minWidth;
  final bool colored;
  final VoidCallback onTap;

  const _Segment({
    required this.label,
    required this.isSelected,
    required this.minWidth,
    required this.colored,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final unselectedText = colored ? Colors.white : Colors.grey.shade600;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minWidth: minWidth),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: isSelected
              ? const [BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 1))]
              : null,
        ),
        child: Text(
          label,
          maxLines: 1,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.textDark : unselectedText,
          ),
        ),
      ),
    );
  }
}
