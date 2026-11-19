/// Models for the AI Agents → Daily Digest screen.
///
/// Pure data — no Flutter imports, no GetX.

enum DigestSeverity { critical, high, med, low }

class DigestDelivery {
  /// e.g. "06:00"
  final String inAppTime;

  /// e.g. "08:01"
  final String emailTime;
  final String email;

  const DigestDelivery({
    required this.inAppTime,
    required this.emailTime,
    required this.email,
  });
}

/// Shown when a project's schedule is stale; schedule-dependent items for
/// that project are held until progress is updated.
class DigestStaleBanner {
  final String projectName;
  final int staleDays;

  const DigestStaleBanner({required this.projectName, required this.staleDays});

  String get message =>
      'Schedule for $projectName is stale ($staleDays days since last '
      'update). Schedule-dependent items for this project are held until '
      'progress is updated.';
}

/// Two agents recommending opposite actions on the same project.
class DigestConflict {
  final String id;
  final String project;

  /// e.g. "accelerate steel vs hold overtime"
  final String summary;

  final String positionAAgent;
  final String positionAText;
  final String impactA;

  final String positionBAgent;
  final String positionBText;
  final String impactB;

  /// e.g. "Legal deadline > margin → A2 position leads"
  final String hierarchyApplied;

  const DigestConflict({
    required this.id,
    required this.project,
    required this.summary,
    required this.positionAAgent,
    required this.positionAText,
    required this.impactA,
    required this.positionBAgent,
    required this.positionBText,
    required this.impactB,
    required this.hierarchyApplied,
  });
}

class DigestItem {
  final String id;

  /// Agent code, e.g. "A3".
  final String agentCode;
  final String title;

  /// How many raw flags were merged into this one. Null = not deduped.
  final int? dedupedFrom;
  final String project;

  /// Null renders as "—" (e.g. a safety item with no recoverable amount).
  final double? recoverable;
  final DigestSeverity severity;

  /// e.g. "Oct 16" or "Oct 19 (notice window)".
  final String deadline;
  final String whyRanked;

  /// Citation for the flag, e.g. "NU Lien Law §24:4AA-6".
  final String basis;

  const DigestItem({
    required this.id,
    required this.agentCode,
    required this.title,
    required this.project,
    required this.severity,
    required this.deadline,
    required this.whyRanked,
    required this.basis,
    this.dedupedFrom,
    this.recoverable,
  });
}

class DailyDigest {
  final DateTime date;

  /// Per-role cap set in AI Agents Settings (the "10" in "Top 10 of 37").
  final int roleCap;

  /// Every open item for this role before the cap (the "37").
  final int totalCount;
  final DigestDelivery delivery;
  final DigestStaleBanner? staleBanner;
  final List<DigestConflict> conflicts;
  final List<DigestItem> items;

  const DailyDigest({
    required this.date,
    required this.roleCap,
    required this.totalCount,
    required this.delivery,
    required this.conflicts,
    required this.items,
    this.staleBanner,
  });
}
