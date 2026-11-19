import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'logic.dart';
import 'models/portfolio_benchmark.dart';
import 'models/portfolio_format.dart';
import 'org_benchmark/view.dart';
import 'widgets/benchmark_summary_widgets.dart';
import 'widgets/financial_snapshot_tile.dart';
import 'widgets/org_health_card.dart';
import 'widgets/report_palette.dart';
import 'widgets/report_primitives.dart';

class PortfolioReportView extends StatelessWidget {
  const PortfolioReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PortfolioReportLogic>(
      init: PortfolioReportLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Portfolio Report',
            showBackButton: true,
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: logic.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ReportPalette.primary,
                        ),
                      )
                    : _Body(logic: logic),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.logic});

  final PortfolioReportLogic logic;

  @override
  Widget build(BuildContext context) {
    final report = logic.report!;
    final orgs = logic.organizations;
    final benchmark = logic.benchmark;

    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        ReportExportButton(onPressed: logic.exportCsv),
        const SizedBox(height: 20),
        const Text(
          "Let's review your overview",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: ReportPalette.text,
          ),
        ),
        const SizedBox(height: 4),
        ReportSubtitle(
          'Generated ${logic.generatedLabel}. AI-generated business '
          'intelligence summary of construction operations.',
        ),
        const SizedBox(height: 22),
        const ReportSectionTitle('Organization Health'),
        const SizedBox(height: 10),
        if (orgs.isEmpty)
          const ReportSubtitle('No organizations linked yet.')
        else
          for (final org in orgs) ...[
            OrgHealthCard(org: org),
            const SizedBox(height: 10),
          ],
        const SizedBox(height: 12),
        const ReportSectionTitle('Financial Snapshots'),
        const SizedBox(height: 4),
        const ReportSubtitle(
          'Expand an organization to see its AR aging, collection rate, and '
          'open invoice details.',
        ),
        const SizedBox(height: 10),
        for (final org in orgs) ...[
          FinancialSnapshotTile(
            org: org,
            isExpanded: logic.isExpanded(org),
            onToggle: () => logic.toggleExpanded(org),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(child: ReportSectionTitle('Benchmarking Summary')),
            InkWell(
              onTap: () =>
                  Get.to(() => OrganizationBenchmarkingView(report: report)),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Full Benchmarking →',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ReportPalette.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CompactSummaryGrid(
          stats: [
            SummaryStat(
              label: 'Active Projects',
              value: '${report.activeProjects}',
            ),
            SummaryStat(
              label: 'Completed',
              value: '${report.completedProjects}',
            ),
            SummaryStat(
              label: 'Project Value',
              value: PortfolioFormat.moneyCompact(report.projectValue),
            ),
            SummaryStat(
              label: 'Bid Pipeline',
              value: PortfolioFormat.moneyCompact(report.bidPipeline),
            ),
            SummaryStat(label: 'Employees', value: '${report.employees}'),
            SummaryStat(label: 'Pending COs', value: '${report.pendingCos}'),
          ],
        ),
        const SizedBox(height: 12),
        for (final metric in kRankingCardMetrics) ...[
          RankingCard(metric: metric, leader: benchmark.leaders[metric]),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
