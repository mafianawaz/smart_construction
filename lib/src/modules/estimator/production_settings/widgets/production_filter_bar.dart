import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/production_models.dart';
import 'production_palette.dart';

/// Search box + "All Units" / "All Time" dropdown pills, shared by both tabs.
class ProductionFilterBar extends StatelessWidget {
  final ValueChanged<String> onSearch;
  final String? unit;
  final List<String> unitOptions;
  final ValueChanged<String?> onUnit;
  final ProductionTimeRange timeRange;
  final ValueChanged<ProductionTimeRange> onTimeRange;

  const ProductionFilterBar({
    super.key,
    required this.onSearch,
    required this.unit,
    required this.unitOptions,
    required this.onUnit,
    required this.timeRange,
    required this.onTimeRange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: onSearch,
          style: const TextStyle(fontSize: 12, color: ProductionPalette.ink),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Search scope...',
            hintStyle: TextStyle(fontSize: 12, color: AppColors.textMuted),
            prefixIcon:
                Icon(Icons.search_rounded, size: 18, color: AppColors.textMuted),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: ProductionPalette.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primaryOrange),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _Pill<String?>(
              label: unit ?? 'All Units',
              filled: true,
              items: [
                const _PillItem(value: null, label: 'All Units'),
                for (final u in unitOptions) _PillItem(value: u, label: u),
              ],
              onSelected: onUnit,
            ),
            const SizedBox(width: 8),
            _Pill<ProductionTimeRange>(
              label: timeRange.label,
              filled: false,
              items: [
                for (final r in ProductionTimeRange.values)
                  _PillItem(value: r, label: r.label),
              ],
              onSelected: onTimeRange,
            ),
          ],
        ),
      ],
    );
  }
}

class _PillItem<T> {
  final T value;
  final String label;

  const _PillItem({required this.value, required this.label});
}

/// Rounded dropdown pill: solid orange when [filled], outlined otherwise.
class _Pill<T> extends StatelessWidget {
  final String label;
  final bool filled;
  final List<_PillItem<T>> items;
  final ValueChanged<T> onSelected;

  const _Pill({
    required this.label,
    required this.filled,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final fg = filled ? Colors.white : ProductionPalette.ink;
    return PopupMenuButton<int>(
      onSelected: (i) => onSelected(items[i].value),
      offset: const Offset(0, 34),
      itemBuilder: (_) => [
        for (var i = 0; i < items.length; i++)
          PopupMenuItem<int>(
            value: i,
            height: 36,
            child: Text(items[i].label, style: const TextStyle(fontSize: 12)),
          ),
      ],
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: filled ? AppColors.primaryOrange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: filled ? AppColors.primaryOrange : ProductionPalette.cardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: fg)),
            const SizedBox(width: 6),
            Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: fg),
          ],
        ),
      ),
    );
  }
}
