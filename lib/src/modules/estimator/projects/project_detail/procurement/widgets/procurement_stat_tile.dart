import 'package:flutter/material.dart';

/// Small "label / value" tile used for the Purchase Orders totals row
/// (Total Committed / Total Invoiced / Total Paid). [accent] colors the
/// label orange for the last tile, as in the reference.
class ProcurementStatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? accent;

  const ProcurementStatTile({super.key, required this.label, required this.value, this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: accent ?? Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}
