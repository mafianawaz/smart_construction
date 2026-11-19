import '../models/ai_agent_models.dart';

/// Mock-data seam for the AI Agents hub.
///
/// Replace [fetchOverview] with the real call:
///   GET /ai-agents/overview
/// which should return the orchestrator, the six agents and per-project
/// schedule health in one payload.
class AiAgentsMockData {
  AiAgentsMockData._();

  /// true  = the populated hub from the reference design.
  /// false = every agent disabled, so the hub shows its "No agents enabled"
  ///         empty state with the Enable agents CTA.
  static const bool seedDemo = true;

  static Future<AiAgentsOverview> fetchOverview() async {
    // TODO(api): GET /ai-agents/overview
    return seedDemo ? _demo() : _allDisabled();
  }

  static const String _accuracyNote =
      'Accuracy expectation: agents start from industry baselines and learn '
      'from your data — accuracy steps up at month 6 and 12.';

  static const OrchestratorModel _orchestrator = OrchestratorModel(
    name: 'Orchestrator',
    description: 'ranks and caps one daily digest per role, resolves agent '
        'conflicts, answers in-context help',
    users: 'all internal roles',
    enabled: true,
    lastRun: 'Today 06:00',
    nextRun: 'Tomorrow 06:00',
    flags: FlagCounts(critical: 1, high: 6, med: 11, low: 5),
  );

  static const List<ProjectScheduleHealth> _projects = [
    ProjectScheduleHealth(projectName: 'Riverside Medical Office'),
    ProjectScheduleHealth(
        projectName: 'Harbor Point Lofts', isStale: true, staleDays: 12),
    ProjectScheduleHealth(projectName: 'Lakeview Elementary'),
    ProjectScheduleHealth(
        projectName: 'Route 9 Retail Pad', isStale: true, staleDays: 9),
    ProjectScheduleHealth(projectName: 'Oak St Warehouse'),
  ];

  static AiAgentsOverview _demo() {
    return const AiAgentsOverview(
      accuracyNote: _accuracyNote,
      orchestrator: _orchestrator,
      projects: _projects,
      agents: [
        AiAgentModel(
          id: 'preconstruction',
          number: 1,
          name: 'Preconstruction',
          enabled: true,
          purpose: 'bid/no-bid, scope checklist, comparables, contingency, '
              'leveling, buyout, prequal',
          users: 'ES, AD, MG',
          learning: AgentLearning(
            state: AgentLearningState.collecting,
            label: 'Collecting (7 of 10 closed jobs)',
            progress: 0.7,
          ),
          lastRun: '06:00',
          nextRun: '06:00 tomorrow',
          flags: FlagCounts(high: 1, med: 2),
          pendingReviews: 3,
        ),
        AiAgentModel(
          id: 'project_controls',
          number: 2,
          name: 'Project Controls',
          enabled: true,
          purpose: 'CPM schedule, look-ahead, scope creep & COs, RFIs, '
              'submittal, drawings, daily log, delays',
          users: 'MG, SU, AD, FW on mobile',
          learning: AgentLearning(
            state: AgentLearningState.active,
            label: 'Active',
          ),
          lastRun: '06:00',
          nextRun: '06:00 tomorrow',
          flags: FlagCounts(critical: 1, high: 2, med: 4),
          pendingReviews: 5,
        ),
        AiAgentModel(
          id: 'finance_contracts',
          number: 3,
          name: 'Finance & Contracts',
          enabled: true,
          purpose: 'WIP/EAC, pay apps, AR, retain age, cash flow, contracts, '
              'lien deadlines, COI, cost coding',
          users: 'AD, MG, HU',
          learning: AgentLearning(
            state: AgentLearningState.locked,
            label: 'Locked',
            progress: 1 / 3,
            caption: '1 of 3 consecutive closes',
          ),
          lastRun: '06:00',
          nextRun: '06:00 tomorrow',
          flags: FlagCounts(high: 2, med: 3),
          pendingReviews: 4,
        ),
        AiAgentModel(
          id: 'equipment_logistics',
          number: 4,
          name: 'Equipment & Logistics',
          enabled: true,
          purpose: 'fleet health, PM, unit economics, compliance, '
              'procurement, deliveries',
          users: 'AD, MG, SU',
          learning: AgentLearning(
            state: AgentLearningState.collecting,
            label: 'Collecting (61 of 90 days telematics)',
            progress: 61 / 90,
          ),
          lastRun: '06:00',
          nextRun: '06:00 tomorrow',
          flags: FlagCounts(high: 1, low: 1),
          pendingReviews: 0,
        ),
        AiAgentModel(
          id: 'safety_workforce',
          number: 5,
          name: 'Safety & Workforce',
          enabled: true,
          purpose: 'JHA, toolbox talks, certifications, incidents, leading '
              'indicators, OT/fatigue, productivity',
          users: 'AD, MG, SU, FW on mobile',
          learning: AgentLearning(
            state: AgentLearningState.paused,
            label: 'Paused',
          ),
          lastRun: '06:00',
          nextRun: '06:00 tomorrow',
          flags: FlagCounts(med: 2, low: 2),
          pendingReviews: 2,
        ),
        AiAgentModel(
          id: 'quality_subs',
          number: 6,
          name: 'Quality & Subcontractors',
          enabled: false,
          purpose: 'submittal compliance, inspections, punch, NCRs, closeout, '
              'sub prequal & scorecards, warranty',
          users: 'MG, AD, SU',
          learning: AgentLearning(
            state: AgentLearningState.locked,
            label: 'Locked',
          ),
          flags: FlagCounts(),
          pendingReviews: 0,
        ),
      ],
    );
  }

  /// Same shape as the demo, but with every agent (and the orchestrator)
  /// switched off — drives the "No agents enabled" empty hub.
  static AiAgentsOverview _allDisabled() {
    final demo = _demo();
    return AiAgentsOverview(
      accuracyNote: _accuracyNote,
      orchestrator: const OrchestratorModel(
        name: 'Orchestrator',
        description: 'ranks and caps one daily digest per role, resolves '
            'agent conflicts, answers in-context help',
        users: 'all internal roles',
        enabled: false,
        lastRun: '—',
        nextRun: '—',
        flags: FlagCounts(),
      ),
      projects: const [],
      agents: demo.agents
          .map((a) => AiAgentModel(
                id: a.id,
                number: a.number,
                name: a.name,
                enabled: false,
                purpose: a.purpose,
                users: a.users,
                learning: const AgentLearning(
                  state: AgentLearningState.locked,
                  label: 'Locked',
                ),
                flags: const FlagCounts(),
                pendingReviews: 0,
              ))
          .toList(growable: false),
    );
  }
}
