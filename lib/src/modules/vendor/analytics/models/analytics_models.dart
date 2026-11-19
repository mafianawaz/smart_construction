/// The four stat-card counts at the top of the Analytics screen.
class AnalyticsSummaryModel {
  final int activeClients;
  final int totalItems;
  final int approved;
  final int pendingReview;

  const AnalyticsSummaryModel({
    required this.activeClients,
    required this.totalItems,
    required this.approved,
    required this.pendingReview,
  });

  const AnalyticsSummaryModel.empty()
      : activeClients = 0,
        totalItems = 0,
        approved = 0,
        pendingReview = 0;
}

/// Lightweight preview row for "Recent Pricing Submissions". Deliberately
/// standalone rather than reusing `PricingItemModel` — see NOTES_ANALYTICS.md
/// for the reconciliation this needs once both modules are cross-checked.
class AnalyticsPricingSubmission {
  final String id;
  final String name;
  final String category;
  final double price;
  final String status;

  const AnalyticsPricingSubmission({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.status,
  });

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
}

/// Lightweight preview row for "Enrolled Clients". See NOTES_ANALYTICS.md —
/// standalone rather than reusing `ClientOrganizationModel`.
class AnalyticsClientPreview {
  final String id;
  final String organizationName;
  final String projectName;
  final bool autoApprove;
  final bool isActive;

  const AnalyticsClientPreview({
    required this.id,
    required this.organizationName,
    required this.projectName,
    required this.autoApprove,
    required this.isActive,
  });
}
