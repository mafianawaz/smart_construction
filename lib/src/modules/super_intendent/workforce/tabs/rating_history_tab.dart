import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';
import '../logic.dart';
import '../models/kpi_model.dart';
import '../models/worker_model.dart';
import '../widgets/wf_common.dart';
import '../widgets/wf_palette.dart';

/// Performance → Rating History. No reference design: simple list of the
/// ratings submitted this session (layout is my own, see NOTES).
class RatingHistoryTab extends StatelessWidget {
  const RatingHistoryTab({super.key, required this.logic});
  final WorkforceLogic logic;

  @override
  Widget build(BuildContext context) {
    final ratings = logic.ratings;
    if (ratings.isEmpty) {
      return const AppEmptyState(
        icon: Icons.history,
        title: 'No ratings yet',
        message: 'Submitted ratings will appear here.',
        showButton: false,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: ratings.length,
      itemBuilder: (_, i) => _RatingCard(rating: ratings[i]),
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard({required this.rating});
  final KpiRating rating;

  @override
  Widget build(BuildContext context) {
    final r = rating;
    return WfSectionCard(
      title: r.period,
      trailing: WfStatusChip(
        '${r.overallPercent.round()}%',
        fg: WfPalette.orange,
        bg: WfPalette.orangeSoft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(r.roleDisplay,
              style: const TextStyle(fontSize: 10.5, color: WfPalette.muted)),
          const SizedBox(height: 6),
          for (final s in r.scores)
            WfKvRow(s.kpiName, '${s.score.toStringAsFixed(s.score % 1 == 0 ? 0 : 1)} / 10'),
          if (r.feedback.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(r.feedback, style: const TextStyle(fontSize: 11, color: WfPalette.text)),
          ],
          const SizedBox(height: 6),
          Text(
            WorkforceDates.full(r.createdAt),
            style: const TextStyle(fontSize: 9.5, color: WfPalette.hint),
          ),
        ],
      ),
    );
  }
}
