/// Models for the Executive Digest module.
///
/// A digest is an AI-generated business-intelligence summary. It is produced
/// per organization and per period (daily / weekly / monthly), plus an optional
/// cross-organization "portfolio" digest.

enum DigestPeriod { daily, weekly, monthly }

extension DigestPeriodX on DigestPeriod {
  /// Label shown on the period tab.
  String get label {
    switch (this) {
      case DigestPeriod.daily:
        return 'Daily';
      case DigestPeriod.weekly:
        return 'Weekly';
      case DigestPeriod.monthly:
        return 'Monthly';
    }
  }

  /// Lowercase adjective used in copy ("...for the selected daily period").
  String get adjective => label.toLowerCase();

  /// Singular noun used in generated copy ("this day / week / month").
  String get noun {
    switch (this) {
      case DigestPeriod.daily:
        return 'day';
      case DigestPeriod.weekly:
        return 'week';
      case DigestPeriod.monthly:
        return 'month';
    }
  }
}

enum DigestSectionKind { financial, operational, risk, opportunity }

enum DigestActionPriority { high, medium, low }

extension DigestActionPriorityX on DigestActionPriority {
  String get label {
    switch (this) {
      case DigestActionPriority.high:
        return 'HIGH';
      case DigestActionPriority.medium:
        return 'MEDIUM';
      case DigestActionPriority.low:
        return 'LOW';
    }
  }
}

/// One tile in the "Metrics Overview" grid.
class DigestMetric {
  const DigestMetric({
    required this.label,
    required this.value,
    this.previous,
  });

  final String label;

  /// Already formatted for display (e.g. `518#`, `69%`, `$200K`, `-`).
  final String value;

  /// Already formatted previous-period value shown as "vs ...".
  /// When null the "vs" line is hidden.
  final String? previous;
}

/// One card in "Detailed Analysis" (Financial / Operational / Risk / Opportunity).
class DigestSection {
  const DigestSection({
    required this.kind,
    required this.title,
    required this.bullets,
  });

  final DigestSectionKind kind;

  /// Title text differs per report ("Financial" vs "Financial Performance"),
  /// so it is data, while [kind] drives colour and icon.
  final String title;
  final List<String> bullets;
}

class DigestActionItem {
  const DigestActionItem({
    required this.text,
    required this.priority,
    required this.dueLabel,
  });

  final String text;
  final DigestActionPriority priority;

  /// Text after "Due: " (e.g. `Today EOD`, `Within 5 business days`).
  final String dueLabel;
}

class DigestReport {
  const DigestReport({
    required this.generatedAt,
    required this.summary,
    required this.highlights,
    required this.metrics,
    required this.sections,
    required this.actionItems,
  });

  final DateTime generatedAt;
  final String summary;
  final List<String> highlights;
  final List<DigestMetric> metrics;
  final List<DigestSection> sections;
  final List<DigestActionItem> actionItems;
}

/// Raw figures an organization digest is derived from. Only used by the mock
/// generator; the real backend will return finished [DigestReport]s.
class DigestOrgStats {
  const DigestOrgStats({
    required this.totalProjects,
    required this.activeProjects,
    required this.completedProjects,
    required this.openBids,
    required this.pendingChangeOrders,
    required this.approvedChangeOrders,
    required this.contractValueK,
    required this.pendingChangeOrderValueK,
    required this.backlogValueK,
  });

  final int totalProjects;
  final int activeProjects;
  final int completedProjects;
  final int openBids;
  final int pendingChangeOrders;
  final int approvedChangeOrders;
  final int contractValueK;
  final int pendingChangeOrderValueK;
  final int backlogValueK;
}

class DigestOrganization {
  const DigestOrganization({
    required this.id,
    required this.name,
    required this.orgType,
    required this.stats,
  });

  final String id;
  final String name;

  /// Raw backend type, rendered upper-case under the name
  /// (e.g. `GENERAL_CONTRACTOR`, `ROADWAY_CONTRACTOR`).
  final String orgType;
  final DigestOrgStats stats;
}
