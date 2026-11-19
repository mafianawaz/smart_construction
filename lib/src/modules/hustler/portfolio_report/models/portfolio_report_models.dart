/// Models for the Portfolio Report module (Portfolio Report +
/// Organization Benchmarking screens).

enum PortfolioOrgStatus { idle, active }

extension PortfolioOrgStatusX on PortfolioOrgStatus {
  String get label => this == PortfolioOrgStatus.active ? 'ACTIVE' : 'IDLE';
}

/// AR aging, collection rate and open invoices for one organization.
/// All amounts are whole dollars.
class PortfolioFinancials {
  const PortfolioFinancials({
    required this.arCurrent,
    required this.ar1to30,
    required this.ar31to60,
    required this.ar61to90,
    required this.arOver90,
    required this.openInvoiceCount,
    required this.openInvoiceAmount,
    this.collectionRatePct,
  });

  static const PortfolioFinancials empty = PortfolioFinancials(
    arCurrent: 0,
    ar1to30: 0,
    ar31to60: 0,
    ar61to90: 0,
    arOver90: 0,
    openInvoiceCount: 0,
    openInvoiceAmount: 0,
  );

  final double arCurrent;
  final double ar1to30;
  final double ar31to60;
  final double ar61to90;
  final double arOver90;
  final int openInvoiceCount;
  final double openInvoiceAmount;

  /// Null when there is nothing to collect yet.
  final double? collectionRatePct;

  double get arTotal => arCurrent + ar1to30 + ar31to60 + ar61to90 + arOver90;

  bool get isEmpty => arTotal == 0 && openInvoiceCount == 0;
}

/// One linked organization's portfolio figures.
class PortfolioOrgMetrics {
  const PortfolioOrgMetrics({
    required this.id,
    required this.name,
    required this.typeLabel,
    required this.activeProjects,
    required this.completedProjects,
    required this.bids,
    required this.tasks,
    required this.employees,
    required this.projectValue,
    required this.bidPipeline,
    required this.pendingCos,
    this.financials = PortfolioFinancials.empty,
  });

  final String id;
  final String name;

  /// Display label under the name (e.g. `GENERAL CONTRACTOR`).
  final String typeLabel;
  final int activeProjects;
  final int completedProjects;
  final int bids;
  final int tasks;

  /// Shown as "Staff" on the report and "Employees" in benchmarking.
  final int employees;

  /// Dollars.
  final double projectValue;
  final double bidPipeline;
  final int pendingCos;
  final PortfolioFinancials financials;

  /// An organization with no active projects is shown as IDLE.
  PortfolioOrgStatus get status => activeProjects > 0
      ? PortfolioOrgStatus.active
      : PortfolioOrgStatus.idle;

  /// Active projects per employee (0 when there are no employees).
  double get efficiency => employees == 0 ? 0 : activeProjects / employees;
}

class PortfolioReport {
  const PortfolioReport({
    required this.generatedAt,
    required this.organizations,
  });

  final DateTime generatedAt;
  final List<PortfolioOrgMetrics> organizations;

  int get activeProjects =>
      organizations.fold(0, (a, o) => a + o.activeProjects);
  int get completedProjects =>
      organizations.fold(0, (a, o) => a + o.completedProjects);
  int get employees => organizations.fold(0, (a, o) => a + o.employees);
  int get pendingCos => organizations.fold(0, (a, o) => a + o.pendingCos);
  double get projectValue =>
      organizations.fold(0.0, (a, o) => a + o.projectValue);
  double get bidPipeline =>
      organizations.fold(0.0, (a, o) => a + o.bidPipeline);
}
