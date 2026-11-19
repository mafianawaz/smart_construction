import 'package:flutter/material.dart';

/// Small caption + bold value pair ("AVG $/UNIT" / "$56.00").
class CostStatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const CostStatCell({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 10,
                letterSpacing: 0.3,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: valueColor ?? Colors.black87)),
      ],
    );
  }
}
