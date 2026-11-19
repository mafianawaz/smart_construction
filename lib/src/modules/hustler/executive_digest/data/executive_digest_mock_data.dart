import '../models/executive_digest_models.dart';

/// Mock-data seam for the Executive Digest module.
///
/// Every method below marks the HTTP call that replaces it.
class ExecutiveDigestMockData {
  ExecutiveDigestMockData._();

  /// When true, the Daily tab opens with two digests already generated
  /// (Host Concrete Camp and Dev Sandbox Organization) and Dev Hustler
  /// Secondary Org empty, matching the reference screens. Set to false to
  /// see the "No digest available for this period" state first.
  static const bool seedDemo = true;

  static const Duration _latency = Duration(milliseconds: 900);

  // GET /executive-digest/organizations
  static Future<List<DigestOrganization>> fetchOrganizations() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _organizations;
  }

  // GET /executive-digest?period=daily  -> already generated digests
  static Map<String, DigestReport> seededDailyReports() {
    if (!seedDemo) return const {};
    return {
      'host_concrete_camp': _build(
        _organizations[0],
        DigestPeriod.daily,
        DateTime(2026, 8, 17, 14, 17, 58),
      ),
      'dev_sandbox': _devSandboxSeed,
    };
  }

  // POST /executive-digest/generate  { organizationId, period }
  static Future<DigestReport> generate(
    DigestOrganization org,
    DigestPeriod period,
  ) async {
    await Future<void>.delayed(_latency);
    return _build(org, period, DateTime.now());
  }

  // POST /executive-digest/portfolio  { period }
  static Future<DigestReport> generatePortfolio(
    List<DigestOrganization> orgs,
    DigestPeriod period,
  ) async {
    await Future<void>.delayed(_latency + const Duration(milliseconds: 400));
    int sum(int Function(DigestOrgStats s) pick) =>
        orgs.fold<int>(0, (a, o) => a + pick(o.stats));
    final combined = DigestOrganization(
      id: 'portfolio',
      name: 'Your portfolio',
      orgType: 'PORTFOLIO',
      stats: DigestOrgStats(
        totalProjects: sum((s) => s.totalProjects),
        activeProjects: sum((s) => s.activeProjects),
        completedProjects: sum((s) => s.completedProjects),
        openBids: sum((s) => s.openBids),
        pendingChangeOrders: sum((s) => s.pendingChangeOrders),
        approvedChangeOrders: sum((s) => s.approvedChangeOrders),
        contractValueK: sum((s) => s.contractValueK),
        pendingChangeOrderValueK: sum((s) => s.pendingChangeOrderValueK),
        backlogValueK: sum((s) => s.backlogValueK),
      ),
    );
    return _build(combined, period, DateTime.now());
  }

  // ---------------------------------------------------------------------------
  // Fixtures
  // ---------------------------------------------------------------------------

  static const List<DigestOrganization> _organizations = [
    DigestOrganization(
      id: 'host_concrete_camp',
      name: 'Host Concrete Camp',
      orgType: 'GENERAL_CONTRACTOR',
      stats: DigestOrgStats(
        totalProjects: 0,
        activeProjects: 0,
        completedProjects: 0,
        openBids: 0,
        pendingChangeOrders: 0,
        approvedChangeOrders: 0,
        contractValueK: 0,
        pendingChangeOrderValueK: 0,
        backlogValueK: 0,
      ),
    ),
    DigestOrganization(
      id: 'dev_sandbox',
      name: 'Dev Sandbox Organization',
      orgType: 'ROADWAY_CONTRACTOR',
      stats: DigestOrgStats(
        totalProjects: 607,
        activeProjects: 518,
        completedProjects: 4,
        openBids: 1268,
        pendingChangeOrders: 8,
        approvedChangeOrders: 18,
        contractValueK: 200,
        pendingChangeOrderValueK: 2600,
        backlogValueK: 128000,
      ),
    ),
    DigestOrganization(
      id: 'dev_hustler_secondary',
      name: 'Dev Hustler Secondary Org',
      orgType: 'GENERAL_CONTRACTOR',
      stats: DigestOrgStats(
        totalProjects: 24,
        activeProjects: 11,
        completedProjects: 9,
        openBids: 37,
        pendingChangeOrders: 5,
        approvedChangeOrders: 12,
        contractValueK: 840,
        pendingChangeOrderValueK: 190,
        backlogValueK: 1250,
      ),
    ),
  ];

  /// Hand-written seed copied from the reference screen.
  static final DigestReport _devSandboxSeed = DigestReport(
    generatedAt: DateTime(2026, 8, 8, 11, 33, 48),
    summary:
        'Dev Sandbox Organization maintains a robust portfolio of 607 projects '
        'with 85% actively in progress. Despite strong project pipeline '
        'activity, only 4 completed projects and significant bid backlog of '
        '1,268 open items signal potential execution bottlenecks requiring '
        'immediate attention.',
    highlights: const [
      '518 active projects represent \$200K in contracted work with 85% '
          'portfolio utilization',
      'Critical completion rate alert: Only 0.7% project completion versus '
          '85% active pipeline',
      '28 change orders in flight (\$2.6M estimated value) with 69% approval '
          'rate',
      '1,268 open bids requiring action represent significant revenue '
          'opportunity backlog',
    ],
    metrics: const [
      DigestMetric(label: 'Active Projects', value: '518#', previous: '607#'),
      DigestMetric(
          label: 'Project Completion Rate', value: '0.7%', previous: '1.2%'),
      DigestMetric(
          label: 'Change Order Approval Rate', value: '69%', previous: '85%'),
      DigestMetric(
          label: 'Open Bid Backlog', value: '1268#', previous: '1300#'),
      DigestMetric(
          label: 'Documented Contract Value',
          value: '\$200K',
          previous: '\$210K'),
      DigestMetric(
          label: 'Pending Change Orders Value',
          value: '\$2600K',
          previous: '\$2700K'),
    ],
    sections: const [
      DigestSection(
        kind: DigestSectionKind.financial,
        title: 'Financial Performance',
        bullets: [
          'Contract value pipeline remains strong with identified projects '
              'totaling \$200K, though 70% of active projects lack contract '
              'documentation.',
          'Documented contracts: 2 recent E2E projects at \$100K each.',
          'Majority of active pipeline (7 of 10 recent projects) missing '
              'contract values.',
          'Change order activity: \$2.6M pending approval across 8 orders.',
          'Revenue recognition risk: Low completion rate may impact cash flow '
              'projections.',
        ],
      ),
      DigestSection(
        kind: DigestSectionKind.operational,
        title: 'Operational Efficiency',
        bullets: [
          'Project initiation strong but execution pipeline shows concerning '
              'bottlenecks with 99.3% of portfolio incomplete.',
          'Active project ratio at 85% demonstrates healthy resource '
              'deployment.',
          'Completion rate critically low: 4 projects completed from 607 '
              'total.',
          'Recent activity dominated by E2E test projects suggesting '
              'testing/validation phase.',
          'Single project (Cadence Editor) in planning stage requires '
              'advancement to active status.',
        ],
      ),
      DigestSection(
        kind: DigestSectionKind.risk,
        title: 'Risk Management',
        bullets: [
          'Multiple risk indicators present across project documentation, '
              'completion velocity, and task management processes.',
          'Contract documentation gap: 70% of sampled active projects lack '
              'contract values.',
          'Project completion velocity well below industry standards (0.7% '
              'vs. 15-20% benchmark).',
          '1,268 open bids create resource allocation uncertainty and '
              'planning challenges.',
          'Change order backlog of 8 pending approvals may indicate scope '
              'control issues.',
        ],
      ),
      DigestSection(
        kind: DigestSectionKind.opportunity,
        title: 'Growth Opportunities',
        bullets: [
          'Substantial untapped revenue potential exists in bid portfolio and '
              'change order pipeline conversion.',
          '1,268 open bids represent \$128M+ potential revenue opportunity at '
              'industry averages.',
          '69% change order approval rate indicates strong client '
              'relationships for upsell.',
          'Large active portfolio (518 projects) positions company for scaled '
              'operations improvements.',
          'Testing infrastructure evident in E2E projects enables quality '
              'scaling.',
        ],
      ),
    ],
    actionItems: const [
      DigestActionItem(
        text: 'Conduct immediate audit of 518 active projects to document '
            'missing contract values and formalize agreements.',
        priority: DigestActionPriority.high,
        dueLabel: 'Within 5 business days',
      ),
      DigestActionItem(
        text: 'Establish project completion task force to accelerate '
            'close-out of stalled projects and improve 0.7% completion rate.',
        priority: DigestActionPriority.high,
        dueLabel: 'Within 5 business days',
      ),
      DigestActionItem(
        text: 'Implement bid management triage process to reduce 1,268 open '
            'bid backlog by 30% within 30 days.',
        priority: DigestActionPriority.high,
        dueLabel: '30 days',
      ),
      DigestActionItem(
        text: 'Expedite approval of 8 pending change orders (\$2.6M value) to '
            'improve cash flow and client sign-off.',
        priority: DigestActionPriority.medium,
        dueLabel: '30 days',
      ),
    ],
  );

  // ---------------------------------------------------------------------------
  // Template generator (stands in for the AI backend)
  // ---------------------------------------------------------------------------

  static DigestReport _build(
    DigestOrganization org,
    DigestPeriod period,
    DateTime now,
  ) {
    final s = org.stats;
    final p = period.adjective;

    if (s.totalProjects == 0) {
      return DigestReport(
        generatedAt: now,
        summary: '${org.name} shows no active, completed, or in-progress '
            'projects for the current $p period, with no bids or change '
            'orders in the pipeline. Operational activity appears paused, '
            'creating near-term revenue risk but also an opportunity to reset '
            'forecasting, backlog, and business development cadence.',
        highlights: const [
          'Project portfolio is at zero: 0 total, 0 active',
          'No change order activity: 0 pending',
          'No commercial pipelines recorded',
          'Data suggests either a framework stoppage or late entry',
        ],
        metrics: const [
          DigestMetric(label: 'Active Projects', value: '0', previous: '0#'),
          DigestMetric(label: 'Open/Draft Bids', value: '0', previous: '0#'),
          DigestMetric(
              label: 'Pending Change Orders', value: '0', previous: '0#'),
          DigestMetric(
              label: 'Approved Change Orders', value: '0', previous: '0#'),
          DigestMetric(
              label: 'Estimated Backlog Value',
              value: '\$0K',
              previous: '\$0K'),
          DigestMetric(label: 'Extended Backlog Value', value: '-'),
        ],
        sections: const [
          DigestSection(
            kind: DigestSectionKind.financial,
            title: 'Financial',
            bullets: [
              'With no active projects or bid pipeline recorded, expected '
                  'near-term revenue and cash inflows are effectively at \$0 '
                  'unless work is occurring outside the system.',
              'Backlog value cannot be established from the provided data due '
                  'to 0 active/total projects.',
              'Revenue risk elevated; no bids in progress and no change '
                  'orders to supplement existing work.',
            ],
          ),
          DigestSection(
            kind: DigestSectionKind.operational,
            title: 'Operational',
            bullets: [
              'Operations show no scheduled or executing work based on the '
                  'project list and statistics provided.',
              'Workload indicator: 0 active projects suggests no crews '
                  'deployed or projects logged.',
              'Recent Projects list is empty — no new starts, completions, or '
                  'progress updates captured.',
            ],
          ),
          DigestSection(
            kind: DigestSectionKind.risk,
            title: 'Risk',
            bullets: [
              'The primary risks are revenue interruption and potential '
                  'reporting gaps if projects/bids exist but are not being '
                  'tracked in the system.',
              'Pipeline risk: 0 open/draft bids indicates no near-term '
                  'replenishment of backlog.',
              'Governance risk: empty project and recent activity records may '
                  'indicate data entry/process breakdown.',
            ],
          ),
          DigestSection(
            kind: DigestSectionKind.opportunity,
            title: 'Opportunity',
            bullets: [
              'This is an opportunity to reestablish a measurable pipeline '
                  'quickly and tighten data discipline to support forecasting '
                  'and execution.',
              'Launch immediate business development sprint to create/enter '
                  'bids and rebuild backlog visibility.',
              'Implement a daily project/bid check-in routine to ensure all '
                  'work and potential work are captured.',
            ],
          ),
        ],
        actionItems: const [
          DigestActionItem(
            text: 'Validate whether projects are truly at zero or if active '
                'work is not being entered; reconcile field schedule, '
                'invoices, and job logs against the system.',
            priority: DigestActionPriority.high,
            dueLabel: 'Today EOD',
          ),
          DigestActionItem(
            text: 'Create and enter at least 3 qualified bids/opportunities '
                'into the system (including values, estimated start dates, '
                'and probability) to restore pipeline visibility.',
            priority: DigestActionPriority.high,
            dueLabel: 'Next business day',
          ),
          DigestActionItem(
            text: 'Confirm with operations whether any change order '
                'discussions exist; if yes, draft and log COs for approval '
                'workflow to avoid revenue leakage.',
            priority: DigestActionPriority.medium,
            dueLabel: 'This week',
          ),
        ],
      );
    }

    final activePct = (s.activeProjects / s.totalProjects * 100).round();
    final completionPct =
        (s.completedProjects / s.totalProjects * 100).toStringAsFixed(1);
    final coTotal = s.approvedChangeOrders + s.pendingChangeOrders;
    final coApprovalPct =
        coTotal == 0 ? 0 : (s.approvedChangeOrders / coTotal * 100).round();

    return DigestReport(
      generatedAt: now,
      summary: '${org.name} has ${s.activeProjects} of ${s.totalProjects} '
          'projects active this ${period.noun}, with ${s.openBids} open bids '
          'and ${s.pendingChangeOrders} change orders pending approval. '
          'Execution is progressing, but bid backlog and change order '
          'turnaround need attention.',
      highlights: [
        '${s.activeProjects} active projects represent \$${s.contractValueK}K '
            'in contracted work with $activePct% portfolio utilization',
        'Completion rate sits at $completionPct% across '
            '${s.totalProjects} total projects',
        '${s.pendingChangeOrders} change orders pending '
            '(\$${s.pendingChangeOrderValueK}K) with $coApprovalPct% approval '
            'rate',
        '${s.openBids} open bids awaiting action',
      ],
      metrics: [
        DigestMetric(label: 'Active Projects', value: '${s.activeProjects}#'),
        DigestMetric(label: 'Project Completion Rate', value: '$completionPct%'),
        DigestMetric(
            label: 'Change Order Approval Rate', value: '$coApprovalPct%'),
        DigestMetric(label: 'Open Bid Backlog', value: '${s.openBids}#'),
        DigestMetric(
            label: 'Documented Contract Value',
            value: '\$${s.contractValueK}K'),
        DigestMetric(
            label: 'Pending Change Orders Value',
            value: '\$${s.pendingChangeOrderValueK}K'),
      ],
      sections: [
        DigestSection(
          kind: DigestSectionKind.financial,
          title: 'Financial Performance',
          bullets: [
            'Contracted work totals \$${s.contractValueK}K across '
                '${s.activeProjects} active projects.',
            'Pending change orders carry \$${s.pendingChangeOrderValueK}K '
                'awaiting approval.',
            'Estimated backlog stands at \$${s.backlogValueK}K.',
          ],
        ),
        DigestSection(
          kind: DigestSectionKind.operational,
          title: 'Operational Efficiency',
          bullets: [
            '${s.activeProjects} of ${s.totalProjects} projects are active '
                '($activePct% utilization).',
            '${s.completedProjects} projects completed, a $completionPct% '
                'completion rate.',
          ],
        ),
        DigestSection(
          kind: DigestSectionKind.risk,
          title: 'Risk Management',
          bullets: [
            '${s.openBids} open bids need triage to avoid resource-allocation '
                'conflicts.',
            '${s.pendingChangeOrders} pending change orders may signal scope '
                'control issues.',
          ],
        ),
        DigestSection(
          kind: DigestSectionKind.opportunity,
          title: 'Growth Opportunities',
          bullets: [
            'The open bid backlog is the main near-term pipeline opportunity.',
            'A $coApprovalPct% change order approval rate suggests room for '
                'upsell conversations.',
          ],
        ),
      ],
      actionItems: [
        DigestActionItem(
          text: 'Triage the ${s.openBids} open bids and prioritize by value '
              'and win probability.',
          priority: DigestActionPriority.high,
          dueLabel: 'Within 5 business days',
        ),
        DigestActionItem(
          text: 'Review the ${s.pendingChangeOrders} pending change orders and '
              'expedite client sign-off.',
          priority: DigestActionPriority.high,
          dueLabel: 'This week',
        ),
        const DigestActionItem(
          text: 'Document contract values for active projects that are '
              'missing agreements.',
          priority: DigestActionPriority.medium,
          dueLabel: '30 days',
        ),
      ],
    );
  }
}
