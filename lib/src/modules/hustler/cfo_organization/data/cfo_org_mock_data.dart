import '../models/cfo_org_models.dart';
import '../widgets/cfo_org_palette.dart';

/// Mock seam for the CFO organization views.
///
/// Every method marks the HTTP call that replaces it. All values are lifted
/// from the Figma reference.
class CfoOrgMockData {
  CfoOrgMockData._();

  /// GET /cfo/portfolio-summary
  static CfoPortfolioSummary portfolioSummary() => const CfoPortfolioSummary(
        organizations: 3,
        activeProjects: 521,
        openBills: 1299,
        pendingChangeOrders: 9,
        pendingTasks: 8,
        bidPipelineLabel: '\$162964K',
        bidWins: 22,
        bidLosses: 1,
      );

  /// GET /cfo/access-summary
  static CfoAccessSummary accessSummary() => const CfoAccessSummary(
        organizationName: 'Hust Concrete Comp',
        effectiveRole: 'Admin',
        permissionCount: 73,
      );

  /// GET /cfo/ai-insights
  static CfoInsights insights() => const CfoInsights(
        message: 'Your construction portfolio includes 1 organization with '
            '0 active projects and 0 bids. 3 items require your attention.',
        sortedOrgs: 0,
        flagged: 0,
        trending: 0,
      );

  /// GET /cfo/organizations
  static List<CfoOrgCardModel> organizations() => const [
        CfoOrgCardModel(
          id: 'org-hust',
          name: 'Hust Concrete Comp',
          type: 'GENERAL CONTRACTOR',
          isActive: true,
        ),
        CfoOrgCardModel(
          id: 'org-dev',
          name: 'Dev Sandbox Organization',
          type: 'REAL ESTATE DEVELOPER',
          isActive: false,
        ),
      ];

  /// GET /cfo/executives
  static List<CfoExecutive> executives() => const [];

  /// POST /cfo/executives/invite  { email, role }
  static Future<CfoExecutive> inviteExecutive({
    required String email,
    required CfoExecRole role,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return CfoExecutive(email: email, role: role);
  }

  /// POST /cfo/organizations/invite  { admin_email, message? }
  static Future<CfoOrgInvite> inviteOrganizationAdmin({
    required String adminEmail,
    String? message,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return CfoOrgInvite(adminEmail: adminEmail, message: message);
  }

  /// POST /cfo/organizations/{id}/switch
  static Future<void> switchOrganization(String orgId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  /// GET /cfo/organizations/{id}
  static CfoOrgDetail organizationDetail(String orgId) => CfoOrgDetail(
        name: 'Dev Sandbox Organization',
        activeProjects: 38,
        planningProjects: 10,
        openBids: 2,
        bidsWonThisPeriod: 22,
        pendingChangeOrders: 9,
        teamSize: 22,
        outstandingArLabel: '\$275K',
        overdueInvoices: 5,
        collectedYtdLabel: '\$0',
        collectionRatePercent: 0,
        projectsByStatus: const [
          CfoChartSlice(
              label: 'ACTIVE', value: 188, color: CfoOrgPalette.teal),
          CfoChartSlice(
              label: 'PLANNING', value: 70, color: CfoOrgPalette.blue),
          CfoChartSlice(
              label: 'CLOSED', value: 12, color: CfoOrgPalette.amber),
          CfoChartSlice(
              label: 'COMPLETE', value: 1, color: CfoOrgPalette.slate),
        ],
        teamActive: 22,
        teamInactive: 2,
        changeOrdersByStatus: const [
          CfoBarDatum(
              label: 'APPROVED', value: 6, color: CfoOrgPalette.blue),
          CfoBarDatum(
              label: 'SUBMITTED', value: 4, color: CfoOrgPalette.amber),
          CfoBarDatum(label: 'PCO', value: 3, color: CfoOrgPalette.amber),
          CfoBarDatum(label: 'DRAFT', value: 1, color: CfoOrgPalette.slate),
        ],
        arAging: const [
          CfoBarDatum(
              label: 'Current', value: 40, color: CfoOrgPalette.teal),
          CfoBarDatum(label: '1-30', value: 100, color: CfoOrgPalette.amber),
          CfoBarDatum(label: '31-60', value: 0, color: CfoOrgPalette.red),
          CfoBarDatum(label: '61-90', value: 0, color: CfoOrgPalette.red),
          CfoBarDatum(label: '90+', value: 0, color: CfoOrgPalette.red),
        ],
        // Third card is clipped in the reference; shape is a guess.
        bidsByStatus: const [
          CfoChartSlice(label: 'WON', value: 22, color: CfoOrgPalette.teal),
          CfoChartSlice(label: 'OPEN', value: 2, color: CfoOrgPalette.amber),
          CfoChartSlice(label: 'LOST', value: 1, color: CfoOrgPalette.red),
        ],
        overdueArLabel: '\$162K',
        // Clipped in the reference ("Since Jan…"); exact wording is a guess.
        collectedSinceLabel: 'Since Jan 1',
        bids: [
          CfoOrgBid(
            name: 'Maisie Hicks',
            client: 'Nora Murray',
            code: '260009',
            dueDate: DateTime(2027, 1, 25),
            amount: 965311.35,
            status: CfoBidStatus.awarded,
          ),
          CfoOrgBid(
            name: 'Gahanna Civic Center',
            client: 'Test Contractor Company',
            code: '260023',
            dueDate: DateTime(2027, 2, 5),
            status: CfoBidStatus.draft,
          ),
          CfoOrgBid(
            name: 'Mock Bid',
            client: 'Test Contractor Company',
            code: '260006',
            dueDate: DateTime(2027, 1, 30),
            status: CfoBidStatus.cancelled,
          ),
        ],
        changeOrders: [
          CfoOrgChangeOrder(
            code: 'CO-101',
            amount: 47800,
            status: CfoChangeOrderStatus.approved,
            createdAt: _daysAgo(12),
          ),
          CfoOrgChangeOrder(
            code: 'CO-102',
            amount: 91500,
            status: CfoChangeOrderStatus.submitted,
            createdAt: _daysAgo(12),
          ),
          CfoOrgChangeOrder(
            code: 'CO-103',
            amount: 284000,
            status: CfoChangeOrderStatus.approved,
            createdAt: _daysAgo(12),
          ),
          CfoOrgChangeOrder(
            code: 'CO-104',
            amount: 25000,
            status: CfoChangeOrderStatus.pco,
            createdAt: _daysAgo(13),
          ),
        ],
        members: const [
          CfoOrgMember(
            name: 'Test Superintendent',
            email: 'test-superintendent@dev.test',
            role: CfoTeamRole.superintendent,
          ),
          CfoOrgMember(
            name: 'Test Estimator',
            email: 'test-estimator@dev.test',
            role: CfoTeamRole.estimator,
          ),
          CfoOrgMember(
            name: 'Test Vendor',
            email: 'test-vendor@dev.test',
            role: CfoTeamRole.vendor,
          ),
          CfoOrgMember(
            name: 'EqMaintenance Manager',
            email: 'test5@email.com',
            role: CfoTeamRole.admin,
          ),
          CfoOrgMember(
            name: 'Test Hustler',
            email: 'test-hustler@dev.test',
            role: CfoTeamRole.hustler,
          ),
        ],
        receivables: [
          CfoOrgReceivable(
            title: 'Pay App #1',
            reference: 'E3E Bid 1785642377631-679358',
            total: 54000,
            outstanding: 54000,
            dueDate: DateTime(2026, 8, 5),
          ),
          CfoOrgReceivable(
            title: 'Pay App #1',
            reference: 'E3E Bid 1785642762888-305041',
            total: 54000,
            outstanding: 54000,
            dueDate: DateTime(2026, 8, 5),
          ),
          CfoOrgReceivable(
            title: 'Pay App #1',
            reference: 'E3E Bid 1785641634788-313685',
            total: 54000,
            outstanding: 54000,
            dueDate: DateTime(2026, 8, 5),
          ),
          CfoOrgReceivable(
            title: 'Bf-40c39bfa',
            reference: 'E3E Project 1785642303689-16218',
            total: 100,
            outstanding: 100,
            dueDate: DateTime(2026, 8, 5),
          ),
        ],
        projects: [
          CfoOrgProject(
            name: 'Westside School Renovation',
            client: 'HISD Facilities',
            code: 'BS-063',
            status: CfoProjectStatus.active,
            date: DateTime(2026, 7, 7),
          ),
          CfoOrgProject(
            name: 'Old Mill Demolition',
            client: 'Urban Renewal Authority',
            code: 'DS-067',
            status: CfoProjectStatus.closed,
            date: DateTime(2026, 3, 24),
          ),
          CfoOrgProject(
            name: 'Highway 87 Bridge Retrofit',
            client: 'TxDOT District 8',
            code: 'DS-062',
            status: CfoProjectStatus.active,
            date: DateTime(2026, 7, 7),
          ),
          CfoOrgProject(
            name: 'Riverside Office Complex',
            client: 'Greenfield Investments LLC',
            code: 'BS-064',
            status: CfoProjectStatus.planning,
            date: DateTime(2026, 9, 5),
          ),
        ],
      );

  /// Mock rows are dated relative to today so "Created N days ago" matches
  /// the reference. Real data carries real timestamps.
  static DateTime _daysAgo(int days) =>
      DateTime.now().subtract(Duration(days: days));
}
