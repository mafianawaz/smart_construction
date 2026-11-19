import 'package:flutter/material.dart';
import '../../../models/project_enums.dart';

class RiskHeatMapLegend extends StatelessWidget {
  const RiskHeatMapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Legend', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            for (final band in RiskSeverityBand.values)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(color: band.color, borderRadius: BorderRadius.circular(3)),
                  ),
                  const SizedBox(width: 6),
                  Text('${band.label} (${band.rangeLabel})',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
