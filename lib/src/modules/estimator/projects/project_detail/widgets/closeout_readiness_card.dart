import 'package:flutter/material.dart';
import '../../models/closeout_readiness_model.dart';
import 'detail_card.dart';

class CloseoutReadinessCard extends StatelessWidget {
  final CloseoutReadinessModel readiness;
  const CloseoutReadinessCard({super.key, required this.readiness});

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Closeout Readiness',
      subtitle: 'Submittals, punch list, and closeout package status at a glance.',
      children: [
        _row('Submittals', '${readiness.submittalsComplete} of ${readiness.submittalsTotal} complete'),
        _row('Punch List', '${readiness.punchListResolved} of ${readiness.punchListTotal} resolved'),
        _row('Closeout Package', readiness.packageStatus),
      ],
    );
  }
}
