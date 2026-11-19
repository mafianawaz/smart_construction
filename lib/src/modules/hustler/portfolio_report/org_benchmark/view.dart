import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import '../models/portfolio_format.dart';
import '../models/portfolio_report_models.dart';
import '../widgets/benchmark_org_card.dart';
import '../widgets/benchmark_summary_widgets.dart';
import '../widgets/report_palette.dart';
import '../widgets/report_primitives.dart';
import 'logic.dart';


/// Organization Benchmarking screen.
///
/// Pass the report from the Portfolio Report screen to skip a second fetch:
/// `Get.to(() => OrganizationBenchmarkingView(report: report))`.
class OrganizationBenchmarkingView extends StatelessWidget {
  const OrganizationBenchmarkingView({super.key, this.report});

  final PortfolioReport? report;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BenchmarkingLogic>(
      init: BenchmarkingLogic(report: report),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Organization Benchmarking',
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

  final BenchmarkingLogic logic;

  @override
  Widget build(BuildContext context) {
    final report = logic.report!;
    final benchmark = logic.benchmark;
    final top = benchmark.topResult;

    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        const Text(
          "Let's review your benchmarking",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: ReportPalette.text,
          ),
        ),
        const SizedBox(height: 4),
        const ReportSubtitle(
          'Compare performance metrics across all your organizations with '
          'live rankings.',
        ),
        const SizedBox(height: 20),
        const ReportSectionTitle('Portfolio Summary'),
        const SizedBox(height: 10),
        IconSummaryGrid(
          stats: [
            SummaryStat(
              label: 'Active Projects',
              value: '${report.activeProjects}',
              icon: Icons.content_copy_outlined,
            ),
            SummaryStat(
              label: 'Completed',
              value: '${report.completedProjects}',
              icon: Icons.format_list_bulleted_rounded,
            ),
            SummaryStat(
              label: 'Project Value',
              value: PortfolioFormat.moneyCompact(report.projectValue),
              icon: Icons.attach_money_rounded,
            ),
            SummaryStat(
              label: 'Bid Pipeline',
              value: PortfolioFormat.moneyCompact(report.bidPipeline),
              icon: Icons.description_outlined,
            ),
            SummaryStat(
              label: 'Employees',
              value: '${report.employees}',
              icon: Icons.badge_outlined,
            ),
            SummaryStat(
              label: 'Pending COs',
              value: '${report.pendingCos}',
              icon: Icons.info_outline_rounded,
            ),
          ],
        ),
        const SizedBox(height: 22),
        const ReportSectionTitle('Organization Comparison'),
        const SizedBox(height: 4),
        const ReportSubtitle(
          'Side-by-side metrics comparison with performance rankings.',
        ),
        const SizedBox(height: 12),
        if (benchmark.results.isEmpty)
          const ReportSubtitle('No organizations linked yet.')
        else
          for (final result in benchmark.results) ...[
            BenchmarkOrgCard(
              result: result,
              isLeader: identical(result, top),
            ),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}
