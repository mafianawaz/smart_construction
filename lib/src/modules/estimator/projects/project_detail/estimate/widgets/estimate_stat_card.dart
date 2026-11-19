import 'package:flutter/material.dart';

/// One of the four estimate stat tiles (TOTAL ESTIMATE / MATERIAL COST /
/// LABOR COST / PROFIT MARGIN): small caps label with a corner icon,
/// large value, muted caption.
class EstimateStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String caption;
  final IconData icon;

  const EstimateStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              Icon(icon, size: 13, color: Colors.grey.shade500),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 2),
          Text(caption, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
