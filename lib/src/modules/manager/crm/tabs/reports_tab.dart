import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../analytics/crm_analytics.dart';
import '../logic.dart';
import '../models/crm_models.dart';
import '../widgets/crm_card.dart';
import '../widgets/crm_charts.dart';
import '../widgets/crm_palette.dart';

/// Reports tab: "Pipeline Reports" header with a date-range pill, then
/// Revenue Forecast, Win / Loss Summary, Time in Stage and Rep Performance.
class ReportsTab extends StatelessWidget {
  final CrmLogic logic;

  const ReportsTab({super.key, required this.logic});

  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// STUB: copies the CSV to the clipboard. Swap for a share/save sheet
  /// (share_plus / file_saver) once a file package is chosen.
  void _export(BuildContext context, String csv, {required bool isEmpty}) {
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    if (isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Nothing to export for this period.')),
      );
      return;
    }
    Clipboard.setData(ClipboardData(text: csv));
    messenger.showSnackBar(
      const SnackBar(content: Text('CSV copied to clipboard.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = logic.analytics;
    final range = logic.reportRange;
    final projection = a.monthlyProjection(months: 6);
    final winLoss = a.winLoss(range);
    final stageTimes = a.timeInStage(range);
    final reps = a.repPerformance(range);

    return ListView(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pipeline Reports',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: CrmPalette.text,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Win/loss analysis, stage timing, and rep breakdown',
                    style: TextStyle(fontSize: 11, color: CrmPalette.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _RangePill(value: range, onChanged: logic.setReportRange),
          ],
        ),
        const SizedBox(height: 12),

        // ── Revenue Forecast ──
        CrmCard(
          title: 'Revenue Forecast',
          trailing: InkWell(
            onTap: logic.toggleRevenueForecast,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: AnimatedRotation(
                turns: logic.revenueForecastExpanded ? 0.25 : 0,
                duration: const Duration(milliseconds: 160),
                child: const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: CrmPalette.textMuted,
                ),
              ),
            ),
          ),
          child: logic.revenueForecastExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _KpiTile(
                            label: 'WEIGHTED PIPELINE',
                            value: crmMoney(a.weightedPipeline),
                            valueColor: CrmPalette.success,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _KpiTile(
                            label: 'TOTAL PIPELINE',
                            value: crmMoney(a.openPipeline),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _KpiTile(
                            label: 'OPEN DEALS',
                            value: '${a.openDeals}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'MONTHLY PROJECTED REVENUE (NEXT 6 MONTHS)',
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 0.4,
                        fontWeight: FontWeight.w700,
                        color: CrmPalette.textMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CrmBarChart(
                      values: [for (final m in projection) m.weighted],
                      labels: [
                        for (final m in projection)
                          '${_monthNames[m.month.month - 1]} ${m.month.year}',
                      ],
                    ),
                  ],
                )
              : Text(
                  '${crmMoney(a.weightedPipeline)} weighted across ${a.openDeals} open deal${a.openDeals == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: CrmPalette.textMuted,
                  ),
                ),
        ),
        const SizedBox(height: 12),

        // ── Win / Loss Summary ──
        CrmCard(
          title: 'Win / Loss Summary',
          trailing: _ExportButton(
            onTap: () => _export(
              context,
              a.winLossCsv(range),
              isEmpty: winLoss.isEmpty,
            ),
          ),
          child: winLoss.isEmpty
              ? const CrmCardEmpty('No closed deals in this period.')
              : _WinLossBody(summary: winLoss),
        ),
        const SizedBox(height: 12),

        // ── Time in Stage ──
        CrmCard(
          title: 'Time in Stage',
          trailing: _ExportButton(
            onTap: () => _export(
              context,
              a.timeInStageCsv(range),
              isEmpty: stageTimes.isEmpty,
            ),
          ),
          child: stageTimes.isEmpty
              ? const CrmCardEmpty(
                  'Not enough stage transition data in this period.')
              : _TimeInStageBody(rows: stageTimes),
        ),
        const SizedBox(height: 12),

        // ── Rep Performance ──
        CrmCard(
          title: 'Rep Performance',
          trailing: _ExportButton(
            onTap: () => _export(
              context,
              a.repPerformanceCsv(range),
              isEmpty: reps.isEmpty,
            ),
          ),
          child: reps.isEmpty
              ? const CrmCardEmpty('No opportunities found in this period.')
              : _RepTable(rows: reps),
        ),
      ],
    );
  }
}

// ───────────────────────────── Pieces ─────────────────────────────

class _RangePill extends StatelessWidget {
  final ReportRange value;
  final ValueChanged<ReportRange> onChanged;

  const _RangePill({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ReportRange>(
      onSelected: onChanged,
      color: CrmPalette.surface,
      itemBuilder: (context) => [
        for (final r in ReportRange.values)
          PopupMenuItem<ReportRange>(
            value: r,
            child: Text(
              r.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: r == value ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
      ],
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: CrmPalette.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CrmPalette.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value.label,
              style: const TextStyle(fontSize: 11.5, color: CrmPalette.text),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: CrmPalette.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ExportButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.file_download_outlined, size: 15, color: CrmPalette.textMuted),
            SizedBox(width: 4),
            Text(
              'Export CSV',
              style: TextStyle(fontSize: 11, color: CrmPalette.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _KpiTile({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CrmPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 8.5,
              height: 1.25,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w700,
              color: CrmPalette.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: valueColor ?? CrmPalette.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WinLossBody extends StatelessWidget {
  final WinLossSummary summary;

  const _WinLossBody({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _OutcomeTile(
                label: 'Won',
                count: summary.won,
                value: summary.wonValue,
                color: CrmPalette.success,
                tint: CrmPalette.successTint,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _OutcomeTile(
                label: 'Lost',
                count: summary.lost,
                value: summary.lostValue,
                color: CrmPalette.danger,
                tint: CrmPalette.dangerTint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _line('Win rate', '${summary.winRatePercent}%'),
        _line('Avg won deal', crmMoney(summary.avgWonDealSize)),
        _line('Avg days to win', '${summary.avgDaysToWin ?? 0}'),
        if (summary.lostReasons.isNotEmpty) ...[
          const SizedBox(height: 10),
          const Text(
            'TOP LOST REASONS',
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w700,
              color: CrmPalette.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final r in summary.lostReasons.take(4))
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: CrmPalette.chipFill,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${r.reason} · ${r.count}',
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: CrmPalette.text,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _line(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11.5, color: CrmPalette.textMuted),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: CrmPalette.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _OutcomeTile extends StatelessWidget {
  final String label;
  final int count;
  final double value;
  final Color color;
  final Color tint;

  const _OutcomeTile({
    required this.label,
    required this.count,
    required this.value,
    required this.color,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            crmCompactMoney(value),
            style: const TextStyle(fontSize: 10.5, color: CrmPalette.textMuted),
          ),
        ],
      ),
    );
  }
}

class _TimeInStageBody extends StatelessWidget {
  final List<StageTimeRow> rows;

  const _TimeInStageBody({required this.rows});

  @override
  Widget build(BuildContext context) {
    final maxDays = rows.fold<double>(0, (m, r) => r.avgDays > m ? r.avgDays : m);
    return Column(
      children: [
        for (final r in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                SizedBox(
                  width: 86,
                  child: Text(
                    r.stage.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: CrmPalette.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor:
                          maxDays == 0 ? 0 : (r.avgDays / maxDays).clamp(0.0, 1.0),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: r.stage.color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 62,
                  child: Text(
                    '${r.avgDays.toStringAsFixed(1)}d (${r.samples})',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: CrmPalette.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _RepTable extends StatelessWidget {
  final List<RepRow> rows;

  const _RepTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    const head = TextStyle(
      fontSize: 9.5,
      fontWeight: FontWeight.w700,
      color: CrmPalette.textMuted,
    );
    const cell = TextStyle(fontSize: 11, color: CrmPalette.text);

    Widget t(String text, TextStyle style, {bool right = true}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: right ? TextAlign.right : TextAlign.left,
            style: style,
          ),
        );

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.6),
        1: FlexColumnWidth(0.9),
        2: FlexColumnWidth(0.9),
        3: FlexColumnWidth(0.9),
        4: FlexColumnWidth(1.2),
        5: FlexColumnWidth(1.5),
      },
      border: const TableBorder(
        horizontalInside: BorderSide(color: CrmPalette.border),
      ),
      children: [
        TableRow(
          children: [
            t('Rep', head, right: false),
            t('Open', head),
            t('Won', head),
            t('Lost', head),
            t('Win %', head),
            t('Won \$', head),
          ],
        ),
        for (final r in rows)
          TableRow(
            children: [
              t(r.name, cell.copyWith(fontWeight: FontWeight.w600), right: false),
              t('${r.open}', cell),
              t('${r.won}', cell),
              t('${r.lost}', cell),
              t('${r.winRatePercent}%', cell),
              t(crmCompactMoney(r.wonValue), cell.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
      ],
    );
  }
}
