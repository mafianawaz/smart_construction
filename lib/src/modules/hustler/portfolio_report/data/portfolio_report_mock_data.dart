import '../models/portfolio_report_models.dart';

/// Mock-data seam for the Portfolio Report module.
class PortfolioReportMockData {
  PortfolioReportMockData._();

  // GET /portfolio-report
  // Returns every linked organization with its project / bid / task / staff
  // counts, values and financial snapshot. Benchmark rankings and the
  // Relative Performance Index are computed client-side from this payload
  // (see logic/portfolio_benchmark.dart); move them server-side if the
  // backend already ranks organizations.
  static Future<PortfolioReport> fetchReport() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return PortfolioReport(
      generatedAt: DateTime(2026, 8, 17),
      organizations: const [
        PortfolioOrgMetrics(
          id: 'hust_concrete_comp',
          name: 'Hust Concrete Comp',
          typeLabel: 'GENERAL CONTRACTOR',
          activeProjects: 0,
          completedProjects: 0,
          bids: 0,
          tasks: 0,
          employees: 0,
          projectValue: 0,
          bidPipeline: 0,
          pendingCos: 0,
        ),
        PortfolioOrgMetrics(
          id: 'dev_sandbox',
          name: 'Dev Sandbox Organization',
          typeLabel: 'ROADWAY CONSTRUCTION',
          activeProjects: 521,
          completedProjects: 5,
          bids: 1299,
          tasks: 6,
          employees: 16,
          projectValue: 83500000,
          bidPipeline: 192964000,
          pendingCos: 9,
          // Placeholder figures: the reference does not show the expanded
          // Financial Snapshots content.
          financials: PortfolioFinancials(
            arCurrent: 412500,
            ar1to30: 186200,
            ar31to60: 94750,
            ar61to90: 41300,
            arOver90: 18900,
            openInvoiceCount: 14,
            openInvoiceAmount: 753650,
            collectionRatePct: 87.5,
          ),
        ),
        PortfolioOrgMetrics(
          id: 'dev_hustler_secondary',
          name: 'Dev Hustler Secondary Org',
          typeLabel: 'GENERAL CONTRACTOR',
          activeProjects: 0,
          completedProjects: 0,
          bids: 0,
          tasks: 0,
          employees: 0,
          projectValue: 0,
          bidPipeline: 0,
          pendingCos: 0,
        ),
      ],
    );
  }
}
