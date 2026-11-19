import 'package:flutter/material.dart';

import '../models/report_models.dart';
import 'reports_palette.dart';

/// Populated state: report title, project/range caption and a horizontally
/// scrollable table. Not in the reference design (which only shows the empty
/// state) — layout is my own.
class ReportTableCard extends StatelessWidget {
  final String title;
  final String caption;
  final ReportTableModel table;

  const ReportTableCard({
    super.key,
    required this.title,
    required this.caption,
    required this.table,
  });

  static const double _firstColWidth = 150;
  static const double _colWidth = 100;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ReportsPalette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ReportsPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: ReportsPalette.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            caption,
            style: const TextStyle(
                fontSize: 12, color: ReportsPalette.textSecondary),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                _row(table.columns, header: true),
                for (final r in table.rows) _row(r),
                if (table.totals != null) _row(table.totals!, total: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(List<String> cells, {bool header = false, bool total = false}) {
    return Container(
      decoration: BoxDecoration(
        color: header ? ReportsPalette.fieldFill : null,
        borderRadius: header ? BorderRadius.circular(8) : null,
        border: header
            ? null
            : const Border(
                bottom: BorderSide(color: ReportsPalette.border),
              ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Row(
        children: [
          for (var i = 0; i < cells.length; i++)
            SizedBox(
              width: i == 0 ? _firstColWidth : _colWidth,
              child: Text(
                cells[i],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: header ? 11.5 : 12.5,
                  fontWeight: header || total ? FontWeight.w700 : FontWeight.w500,
                  color: header
                      ? ReportsPalette.textSecondary
                      : ReportsPalette.textDark,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
