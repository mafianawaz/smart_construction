/// Models for the AI Agents hub (Today's digest tab).
///
/// Pure data — no Flutter imports, no GetX.

enum AiAgentsTab { digest, reviewQueue, flags }

enum FlagSeverity { critical, high, med, low }

/// Learning progress state of one agent.
///  - collecting: gathering data, shows progress toward the threshold
///  - active:     past the threshold, learning from the org's own data
///  - locked:     threshold not reached yet (e.g. 1 of 3 consecutive closes)
///  - paused:     learning paused by an admin
enum AgentLearningState { collecting, active, locked, paused }

class AgentLearning {
  final AgentLearningState state;

  /// Text shown inside the bordered box, e.g. "Collecting (7 of 10 closed jobs)".
  final String label;

  /// 0..1 progress toward the data threshold. Null = no progress bar.
  final double? progress;

  /// Optional caption under the bar, e.g. "1 of 3 consecutive closes".
  final String? caption;

  const AgentLearning({
    required this.state,
    required this.label,
    this.progress,
    this.caption,
  });
}

class FlagCounts {
  final int critical;
  final int high;
  final int med;
  final int low;

  const FlagCounts({
    this.critical = 0,
    this.high = 0,
    this.med = 0,
    this.low = 0,
  });

  int get total => critical + high + med + low;
  bool get isEmpty => total == 0;

  int countFor(FlagSeverity severity) {
    switch (severity) {
      case FlagSeverity.critical:
        return critical;
      case FlagSeverity.high:
        return high;
      case FlagSeverity.med:
        return med;
      case FlagSeverity.low:
        return low;
    }
  }

  /// Severities that have at least one open flag, most severe first.
  List<FlagSeverity> get nonZero => FlagSeverity.values
      .where((s) => countFor(s) > 0)
      .toList(growable: false);
}

class AiAgentModel {
  final String id;
  final int number;
  final String name;
  final bool enabled;
  final String purpose;

  /// Role codes, e.g. "ES, AD, MG" or "MG, SU, AD, FW on mobile".
  final String users;
  final AgentLearning learning;
  final String? lastRun;
  final String? nextRun;
  final FlagCounts flags;
  final int pendingReviews;

  const AiAgentModel({
    required this.id,
    required this.number,
    required this.name,
    required this.enabled,
    required this.purpose,
    required this.users,
    required this.learning,
    required this.flags,
    required this.pendingReviews,
    this.lastRun,
    this.nextRun,
  });

  String get title => 'Agent $number · $name';
}

class OrchestratorModel {
  final String name;
  final String description;
  final String users;
  final bool enabled;
  final String lastRun;
  final String nextRun;
  final FlagCounts flags;

  const OrchestratorModel({
    required this.name,
    required this.description,
    required this.users,
    required this.enabled,
    required this.lastRun,
    required this.nextRun,
    required this.flags,
  });

  String get headline => '$name — $description · Users: $users';
}

class ProjectScheduleHealth {
  final String projectName;
  final bool isStale;

  /// Days since the schedule was last updated. Only meaningful when stale.
  final int staleDays;

  const ProjectScheduleHealth({
    required this.projectName,
    this.isStale = false,
    this.staleDays = 0,
  });
}

class AiAgentsOverview {
  final String accuracyNote;
  final OrchestratorModel orchestrator;
  final List<AiAgentModel> agents;
  final List<ProjectScheduleHealth> projects;

  const AiAgentsOverview({
    required this.accuracyNote,
    required this.orchestrator,
    required this.agents,
    required this.projects,
  });

  bool get hasEnabledAgents => agents.any((a) => a.enabled);

  /// Sum of every agent's pending reviews (feeds the "Review queue" count).
  int get pendingReviews =>
      agents.fold<int>(0, (sum, a) => sum + a.pendingReviews);

  /// Orchestrator-level open flags (feeds the "Flags" count).
  int get openFlags => orchestrator.flags.total;
}
