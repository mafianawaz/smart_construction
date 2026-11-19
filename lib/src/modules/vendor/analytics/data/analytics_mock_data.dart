import '../models/analytics_models.dart';

/// Static mock data for the vendor Analytics dashboard.
class AnalyticsMockData {
  AnalyticsMockData._();

  /// Populated summary — matches the second reference frame.
  // TODO(api): GET /api/vendor/analytics/summary
  static AnalyticsSummaryModel populatedSummary() {
    return const AnalyticsSummaryModel(
      activeClients: 1,
      totalItems: 8,
      approved: 8,
      pendingReview: 0,
    );
  }

  /// Empty-state summary — matches the first reference frame (all zeros).
  static AnalyticsSummaryModel emptySummary() =>
      const AnalyticsSummaryModel.empty();

  /// Top 3 most recent pricing submissions shown on the dashboard, newest
  /// first. Full list lives in the Pricing feature — this is a preview.
  // TODO(api): GET /api/vendor/pricing?limit=3&sort=-updated_at
  static List<AnalyticsPricingSubmission> recentPricingSubmissions() {
    return const [
      AnalyticsPricingSubmission(
        id: 'p1',
        name: 'Recessed LED Can Light',
        category: 'Thermal',
        price: 70.00,
        status: 'Approved',
      ),
      AnalyticsPricingSubmission(
        id: 'p2',
        name: 'Ready Mix Concrete 4500 PSI',
        category: 'Masonry',
        price: 148.00,
        status: 'Approved',
      ),
      AnalyticsPricingSubmission(
        id: 'p3',
        name: 'Recessed LED Can Light',
        category: 'Electrical',
        price: 20.00,
        status: 'Approved',
      ),
    ];
  }

  /// Total count backing "View all N items >" — kept separate from the
  /// preview list length since the two can diverge once real data lands.
  static int totalPricingSubmissionCount() => 8;

  /// Enrolled client organizations viewing this vendor's pricing.
  // TODO(api): GET /api/vendor/enrolled-clients?limit=3
  static List<AnalyticsClientPreview> enrolledClientsPreview() {
    return const [
      AnalyticsClientPreview(
        id: 'c1',
        organizationName: 'Dev Sandbox Organization',
        projectName: 'Dev Sand Project',
        autoApprove: true,
        isActive: true,
      ),
    ];
  }
}
