import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/executive_digest_models.dart';
import 'digest_palette.dart';

/// Full body of one generated digest: summary box, metrics, detailed
/// analysis and action items. Shared by organization cards and the portfolio
/// card, so it carries no screen- or role-specific logic.
class DigestReportBody extends StatelessWidget {
  const DigestReportBody({super.key, required this.report});

  final DigestReport report;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigestSummaryBox(report: report),
        const SizedBox(height: 20),
        const _BlockTitle('Metrics Overview'),
        const SizedBox(height: 12),
        DigestMetricsGrid(metrics: report.metrics),
        const SizedBox(height: 20),
        const _BlockTitle('Detailed Analysis'),
        const SizedBox(height: 12),
        for (final section in report.sections) ...[
          DigestAnalysisCard(section: section),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 4),
        const _BlockTitle('Action Items'),
        const SizedBox(height: 2),
        const Text(
          'Items requiring attention',
          style: TextStyle(fontSize: 11, color: DigestPalette.muted),
        ),
        const SizedBox(height: 12),
        for (final item in report.actionItems) ...[
          DigestActionItemTile(item: item),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _BlockTitle extends StatelessWidget {
  const _BlockTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: DigestPalette.text,
      ),
    );
  }
}

/// Peach "Executive Summary" box with timestamp and blue highlight chips.
class DigestSummaryBox extends StatelessWidget {
  const DigestSummaryBox({super.key, required this.report});

  final DigestReport report;

  static final DateFormat _stamp = DateFormat('dd/MM/yyyy, HH:mm:ss');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DigestPalette.summaryFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DigestPalette.summaryBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Executive Summary',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: DigestPalette.primary,
                  ),
                ),
              ),
              Text(
                _stamp.format(report.generatedAt),
                style: const TextStyle(
                  fontSize: 11,
                  color: DigestPalette.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            report.summary,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: DigestPalette.text,
            ),
          ),
          const SizedBox(height: 12),
          for (final h in report.highlights) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: DigestPalette.highlightFill,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                h,
                style: const TextStyle(
                  fontSize: 11.5,
                  height: 1.4,
                  color: DigestPalette.highlightText,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

/// Two-column grid of metric tiles.
class DigestMetricsGrid extends StatelessWidget {
  const DigestMetricsGrid({super.key, required this.metrics});

  final List<DigestMetric> metrics;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < metrics.length; i += 2) {
      final left = metrics[i];
      final right = i + 1 < metrics.length ? metrics[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _MetricTile(metric: left)),
              const SizedBox(width: 12),
              Expanded(
                child: right == null
                    ? const SizedBox.shrink()
                    : _MetricTile(metric: right),
              ),
            ],
          ),
        ),
      );
      if (i + 2 < metrics.length) rows.add(const SizedBox(height: 12));
    }
    return Column(children: rows);
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric});

  final DigestMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DigestPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: DigestPalette.body),
          ),
          const SizedBox(height: 8),
          Text(
            metric.value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: DigestPalette.text,
            ),
          ),
          if (metric.previous != null) ...[
            const SizedBox(height: 4),
            Text(
              'vs ${metric.previous}',
              style: const TextStyle(fontSize: 11, color: DigestPalette.muted),
            ),
          ],
        ],
      ),
    );
  }
}

/// One "Detailed Analysis" card: coloured icon chip, title and bullets.
class DigestAnalysisCard extends StatelessWidget {
  const DigestAnalysisCard({super.key, required this.section});

  final DigestSection section;

  @override
  Widget build(BuildContext context) {
    final color = DigestPalette.sectionColor(section.kind);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DigestPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: DigestPalette.sectionFill(section.kind),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(
                  DigestPalette.sectionIcon(section.kind),
                  size: 16,
                  color: color,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  section.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final bullet in section.bullets)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6, right: 8),
                    child: CircleAvatar(
                      radius: 2.5,
                      backgroundColor: DigestPalette.muted,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      bullet,
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.45,
                        color: DigestPalette.body,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Action item card: text, priority badge and "Due: ..." line.
class DigestActionItemTile extends StatelessWidget {
  const DigestActionItemTile({super.key, required this.item});

  final DigestActionItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DigestPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.text,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: DigestPalette.text,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: DigestPalette.priorityFill(item.priority),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  item.priority.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: DigestPalette.priorityColor(item.priority),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: DigestPalette.muted,
              ),
              const SizedBox(width: 6),
              Text(
                'Due: ${item.dueLabel}',
                style: const TextStyle(
                  fontSize: 11,
                  color: DigestPalette.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
