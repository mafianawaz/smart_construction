import '../models/cfo_models.dart';

/// Mock-data seam for the CFO Dashboard.
///
/// Replace [fetchOrganizations] with the real call. Suggested contract:
///   GET /finance/cfo-dashboard
/// returning one summary per linked organisation (id, name, orgType, and the
/// four blocks: projects, changeOrders, bids, receivables). Money as numbers,
/// collectionRate as a 0–100 percentage.
class CfoMockData {
  CfoMockData._();

  /// Flip to false to see the empty state.
  static const bool seedDemo = true;

  static Future<List<CfoOrgSummary>> fetchOrganizations() async {
    if (!seedDemo) return const [];
    return _orgs;
  }

  static const List<CfoOrgSummary> _orgs = [
    CfoOrgSummary(
      id: 'org-hust',
      name: 'Hust Concrete Comp',
      orgType: 'GENERAL_CONTRACTOR',
      projects: CfoProjectStats(
        total: 0,
        active: 0,
        completed: 0,
        planning: 0,
        totalContract: 0,
        activeContract: 0,
      ),
      changeOrders:
          CfoChangeOrderStats(pending: 0, approved: 0, approvedValue: 0),
      bids: CfoBidStats(count: 0, pipelineValue: 0),
      receivables: CfoReceivablesStats(
        outstanding: 0,
        overdue: 0,
        collectionRate: 0,
        openCoValue: 0,
      ),
    ),
    CfoOrgSummary(
      id: 'org-sandbox',
      name: 'Dev Sandbox Organization',
      orgType: 'ROADWAY_CONTRACTOR',
      projects: CfoProjectStats(
        total: 614,
        active: 521,
        completed: 5,
        planning: 87,
        totalContract: 83472981,
        activeContract: 35832467,
      ),
      changeOrders:
          CfoChangeOrderStats(pending: 8, approved: 29, approvedValue: 442855),
      bids: CfoBidStats(count: 1268, pipelineValue: 113795000),
      receivables: CfoReceivablesStats(
        outstanding: 274700,
        overdue: 162200,
        collectionRate: 0,
        openCoValue: 126500,
      ),
    ),
    CfoOrgSummary(
      id: 'org-hustler-secondary',
      name: 'Dev Hustler Secondary Org',
      orgType: 'GENERAL_CONTRACTOR',
      projects: CfoProjectStats(
        total: 0,
        active: 0,
        completed: 0,
        planning: 0,
        totalContract: 0,
        activeContract: 0,
      ),
      changeOrders:
          CfoChangeOrderStats(pending: 0, approved: 0, approvedValue: 0),
      bids: CfoBidStats(count: 0, pipelineValue: 0),
      receivables: CfoReceivablesStats(
        outstanding: 0,
        overdue: 0,
        collectionRate: 0,
        openCoValue: 0,
      ),
    ),
  ];
}
