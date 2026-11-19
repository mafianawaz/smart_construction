import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../models/scope_item_model.dart';

/// Checkbox + description + inline Qty / Unit / Cost editors (matches
/// the "Review Scope Items" / "Confirm Scope of Work" cards in Figma).
/// Give each card `key: ValueKey(item.id)` so the text fields keep their
/// state when the list rebuilds.
class ScopeItemCard extends StatelessWidget {
  final ScopeItemModel item;
  final ValueChanged<bool> onToggleIncluded;
  final ValueChanged<ScopeItemModel> onChanged;

  const ScopeItemCard({
    super.key,
    required this.item,
    required this.onToggleIncluded,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: item.isIncluded,
              activeColor: AppColors.primaryOrange,
              onChanged: (v) => onToggleIncluded(v ?? true),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: item.isIncluded ? null : Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _InlineField(
                      label: 'Qty',
                      width: 48,
                      initial: item.quantity == item.quantity.roundToDouble()
                          ? item.quantity.toInt().toString()
                          : item.quantity.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => onChanged(
                        item.copyWith(quantity: double.tryParse(v) ?? item.quantity),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _InlineField(
                      label: 'Unit',
                      width: 56,
                      initial: item.unit,
                      onChanged: (v) =>
                          onChanged(item.copyWith(unit: v.isEmpty ? item.unit : v)),
                    ),
                    const SizedBox(width: 10),
                    _InlineField(
                      label: '\$',
                      width: 72,
                      initial: item.estimatedCost == null
                          ? ''
                          : item.estimatedCost!.toStringAsFixed(0),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => onChanged(
                        item.copyWith(estimatedCost: double.tryParse(v)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineField extends StatefulWidget {
  final String label;
  final double width;
  final String initial;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const _InlineField({
    required this.label,
    required this.width,
    required this.initial,
    required this.onChanged,
    this.keyboardType,
  });

  @override
  State<_InlineField> createState() => _InlineFieldState();
}

class _InlineFieldState extends State<_InlineField> {
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        const SizedBox(width: 4),
        SizedBox(
          width: widget.width,
          height: 30,
          child: TextField(
            controller: _ctrl,
            keyboardType: widget.keyboardType,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            onChanged: widget.onChanged,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }
}
