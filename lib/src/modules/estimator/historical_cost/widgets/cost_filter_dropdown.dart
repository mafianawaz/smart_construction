import 'package:flutter/material.dart';
import 'cost_colors.dart';

/// Pill dropdown whose first entry ("All Trades", ...) maps to `null`.
class CostFilterDropdown extends StatelessWidget {
  final String allLabel;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const CostFilterDropdown({
    super.key,
    required this.allLabel,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Guard: a stale selection (e.g. after a delete) must not crash the menu.
    final safeValue = options.contains(value) ? value : null;
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CostColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: safeValue,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          items: [
            DropdownMenuItem<String?>(value: null, child: Text(allLabel)),
            ...options.map(
              (o) => DropdownMenuItem<String?>(value: o, child: Text(o)),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
