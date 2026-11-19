import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'cost_colors.dart';

/// Read-only dd/mm/yyyy field used by the filter card.
class CostDateField extends StatelessWidget {
  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const CostDateField({
    super.key,
    required this.value,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.only(left: 12, right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: CostColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasValue ? DateFormat('dd/MM/yyyy').format(value!) : 'dd/mm/yyyy',
                style: TextStyle(
                  fontSize: 13,
                  color: hasValue ? Colors.black87 : Colors.grey,
                ),
              ),
            ),
            GestureDetector(
              onTap: hasValue ? onClear : onTap,
              child: Icon(
                hasValue ? Icons.close_rounded : Icons.calendar_today_outlined,
                size: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
