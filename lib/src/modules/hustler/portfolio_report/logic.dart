import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'data/portfolio_report_mock_data.dart';
import 'models/portfolio_benchmark.dart';
import 'models/portfolio_format.dart';
import 'models/portfolio_report_models.dart';


/// Controller for [PortfolioReportView]. Plain fields + `update()`
/// (GetBuilder), like the other recent modules.
class PortfolioReportLogic extends GetxController {
  PortfolioReport? report;
  bool isLoading = true;

  /// Organization ids whose Financial Snapshot tile is expanded.
  final Set<String> _expandedIds = {};

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    report = await PortfolioReportMockData.fetchReport();
    isLoading = false;
    update();
  }

  List<PortfolioOrgMetrics> get organizations =>
      report?.organizations ?? const [];

  PortfolioBenchmark get benchmark => PortfolioBenchmark.compute(organizations);

  bool isExpanded(PortfolioOrgMetrics org) => _expandedIds.contains(org.id);

  void toggleExpanded(PortfolioOrgMetrics org) {
    if (!_expandedIds.remove(org.id)) _expandedIds.add(org.id);
    update();
  }

  /// Export CSV. No file/share package is wired yet, so the CSV text is
  /// copied to the clipboard. Replace the clipboard call with a real
  /// save/share (or `GET /portfolio-report/export.csv`).
  Future<void> exportCsv() async {
    if (report == null) return;
    await Clipboard.setData(ClipboardData(text: buildCsv()));
    Get.snackbar(
      'Portfolio report',
      'CSV copied to clipboard.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String buildCsv() {
    String esc(String v) {
      final escaped = v.replaceAll('"', '""');
      return '"$escaped"';
    }

    final rows = <List<String>>[
      [
        'Organization',
        'Type',
        'Status',
        'Active Projects',
        'Completed',
        'Bids',
        'Tasks',
        'Staff',
        'Project Value',
        'Bid Pipeline',
        'Pending COs',
        'Efficiency (projects/emp)',
      ],
      for (final o in organizations)
        [
          o.name,
          o.typeLabel,
          o.status.label,
          '${o.activeProjects}',
          '${o.completedProjects}',
          '${o.bids}',
          '${o.tasks}',
          '${o.employees}',
          o.projectValue.toStringAsFixed(0),
          o.bidPipeline.toStringAsFixed(0),
          '${o.pendingCos}',
          o.efficiency.toStringAsFixed(2),
        ],
    ];
    return rows.map((r) => r.map(esc).join(',')).join('\n');
  }

  String get generatedLabel =>
      report == null ? '' : PortfolioFormat.date(report!.generatedAt);
}
