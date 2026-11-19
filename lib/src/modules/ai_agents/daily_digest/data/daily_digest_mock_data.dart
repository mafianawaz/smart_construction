import '../models/daily_digest_models.dart';

/// Mock-data seam for the Daily Digest.
///
/// Replace [fetchDigest] with the real call:
///   GET /ai-agents/digest?date=YYYY-MM-DD&role=<code>
/// `role` is only honoured for admins ("View as role (AD only)").
class DailyDigestMockData {
  DailyDigestMockData._();

  /// Fixed "today" so the demo matches the reference (Mon 12 Oct 2026).
  /// TODO: use DateTime.now() once real data is wired.
  static final DateTime today = DateTime(2026, 10, 12);

  /// How far back the date picker may go ("90-day history").
  static const int historyDays = 90;

  /// TODO(auth): replace with MockSession.currentRole == UserRole.admin
  /// (or the real auth check). The role selector only renders for admins.
  static const bool isAdmin = true;

  static const String ownRoleLabel = 'Admin (own role)';

  static const List<String> roleOptions = [
    ownRoleLabel,
    'Manager',
    'Superintendent',
    'Estimator',
    'Field worker',
    'Hustler',
  ];

  /// 0 items + 0 conflicts triggers the "Nothing needs you today" state.
  static const bool seedDemo = true;

  static Future<DailyDigest> fetchDigest({
    required DateTime date,
    required String role,
  }) async {
    // TODO(api): GET /ai-agents/digest?date=...&role=...
    // The demo returns the same content for any date / role.
    return DailyDigest(
      date: date,
      roleCap: 10,
      totalCount: seedDemo ? 37 : 0,
      delivery: const DigestDelivery(
        inAppTime: '06:00',
        emailTime: '08:01',
        email: 'admin@acmebuilders.com',
      ),
      staleBanner: seedDemo
          ? const DigestStaleBanner(
              projectName: 'Route 9 Retail Pad',
              staleDays: 12,
            )
          : null,
      conflicts: seedDemo ? _conflicts : const [],
      items: seedDemo ? _items : const [],
    );
  }

  static const List<DigestConflict> _conflicts = [
    DigestConflict(
      id: 'c1',
      project: 'Riverside Medical',
      summary: 'accelerate steel vs hold overtime',
      positionAAgent: 'A2',
      positionAText: 'Accelerate steel erection to protect substantial '
          'completion',
      impactA: 'Avoids \$38,000 LDs (19 d × \$2,000)',
      positionBAgent: 'A3',
      positionBText: 'Hold OT — margin fade on 05-1200',
      impactB: '\$14,200 OT premium',
      hierarchyApplied: 'Legal deadline > margin → A2 position leads',
    ),
  ];

  static const List<DigestItem> _items = [
    DigestItem(
      id: 'i1',
      agentCode: 'A3',
      title: 'Lien notice deadline in 4 days — preliminary notice not sent',
      dedupedFrom: 2,
      project: 'Route 9 Retail Pad',
      recoverable: 212400,
      severity: DigestSeverity.critical,
      deadline: 'Oct 16',
      whyRanked: 'Legal deadline; full contract value at risk',
      basis: 'NU Lien Law §24:4AA-6',
    ),
    DigestItem(
      id: 'i2',
      agentCode: 'A2',
      title: 'Unpriced extra work — 3 log entries outside contracted scope',
      project: 'Riverside Medical',
      recoverable: 46800,
      severity: DigestSeverity.high,
      deadline: 'Oct 19 (notice window)',
      whyRanked: 'Notice window closes in 7 d',
      basis: 'Daily logs 10/02–10/08',
    ),
    DigestItem(
      id: 'i3',
      agentCode: 'A3',
      title: 'Underbilled \$31,500 — pay app 7 missing approved CO #12',
      project: 'Lakeview Elementary',
      recoverable: 31500,
      severity: DigestSeverity.high,
      deadline: 'Oct 25 (billing cutoff)',
      whyRanked: 'Cash; cutoff in 13 d',
      basis: 'WIP Sep-26',
    ),
    DigestItem(
      id: 'i4',
      agentCode: 'A4',
      title: 'Order-by date passed for RTU-2 (lead 14 wks)',
      dedupedFrom: 3,
      project: 'Oak St Warehouse',
      recoverable: 19000,
      severity: DigestSeverity.med,
      deadline: 'Oct 14',
      whyRanked: 'Storage delays 2 critical activities',
      basis: 'Submittal 23-7413',
    ),
    DigestItem(
      id: 'i5',
      agentCode: 'A5',
      title: 'Crane operator cert expires before scheduled pick',
      project: 'Riverside Medical',
      severity: DigestSeverity.med,
      deadline: 'Oct 21',
      whyRanked: 'Safety; assignment will be blocked',
      basis: 'NCCCO record',
    ),
  ];
}
