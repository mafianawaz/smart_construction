import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/modules/estimator/projects/models/project_enums.dart';

import '../../../models/portal_models.dart';
import '../../../widgets/project_badge.dart';
import '../../../widgets/project_empty_card.dart';
import '../../widgets/project_record_tile.dart';

/// The generated-reports list, or the "No Reports Yet" card. Shared by
/// the Reports tab and the Reports Settings screen (both end with it in
/// the references). Wraps its own `Obx`.
class ReportList extends StatelessWidget {
  final RxList<ProgressReportModel> reports;
  final ValueChanged<ProgressReportModel> onTap;

  const ReportList({super.key, required this.reports, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (reports.isEmpty) {
        return const ProjectEmptyCard(
          icon: Icons.description_outlined,
          title: 'No Reports Yet',
          message: 'Generate your first progress report to track project '
              'performance over time.',
        );
      }
      final day = DateFormat('MMM d, y');
      return Column(
        children: [
          for (final r in reports)
            ProjectRecordTile(
              title: r.type.label,
              lines: [
                '${day.format(r.rangeStart)} - ${day.format(r.rangeEnd)}',
                'Generated ${DateFormat('MMM d, y · h:mm a').format(r.generatedAt)}',
              ],
              badges: [
                ProjectBadge(
                    label: r.type.shortLabel,
                    background: r.type.background,
                    foreground: r.type.foreground),
              ],
              onTap: () => onTap(r),
            ),
        ],
      );
    });
  }
}
