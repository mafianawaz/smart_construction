// Models for the CRM Sequences tab (multi-step sales cadences).
// Pure Dart (no Flutter imports) so they stay API-ready.

enum SequenceStatus { draft, active, paused, archived }

extension SequenceStatusX on SequenceStatus {
  String get label {
    switch (this) {
      case SequenceStatus.draft:
        return 'Draft';
      case SequenceStatus.active:
        return 'Active';
      case SequenceStatus.paused:
        return 'Paused';
      case SequenceStatus.archived:
        return 'Archived';
    }
  }
}

enum SequenceStepType { email, call, task, text }

extension SequenceStepTypeX on SequenceStepType {
  String get label {
    switch (this) {
      case SequenceStepType.email:
        return 'Email';
      case SequenceStepType.call:
        return 'Call';
      case SequenceStepType.task:
        return 'Task';
      case SequenceStepType.text:
        return 'Text message';
    }
  }
}

/// Which list the Sequences tab shows ("Library" templates vs the user's own).
enum SequenceScope { library, mine }

class SequenceStep {
  final SequenceStepType type;
  final String title;

  /// Days to wait after the previous step (0 = same day).
  final int delayDays;

  const SequenceStep({
    required this.type,
    required this.title,
    this.delayDays = 0,
  });
}

class SequenceModel {
  final String id;
  final String name;
  final String description;
  final SequenceStatus status;
  final List<SequenceStep> steps;
  final int activeCount;
  final int totalEnrolled;
  final int repliedCount;
  final String ownerName;

  /// Library templates are read-only; "use" them to get an editable copy.
  final bool isTemplate;

  const SequenceModel({
    required this.id,
    required this.name,
    this.description = '',
    this.status = SequenceStatus.draft,
    this.steps = const [],
    this.activeCount = 0,
    this.totalEnrolled = 0,
    this.repliedCount = 0,
    this.ownerName = '',
    this.isTemplate = false,
  });

  bool get isArchived => status == SequenceStatus.archived;

  /// Total length of the cadence in days.
  int get durationDays => steps.fold(0, (sum, s) => sum + s.delayDays);

  SequenceModel copyWith({SequenceStatus? status}) {
    return SequenceModel(
      id: id,
      name: name,
      description: description,
      status: status ?? this.status,
      steps: steps,
      activeCount: activeCount,
      totalEnrolled: totalEnrolled,
      repliedCount: repliedCount,
      ownerName: ownerName,
      isTemplate: isTemplate,
    );
  }

  /// Fresh editable draft with zeroed stats.
  SequenceModel asDraftCopy({required String id, required String owner}) {
    return SequenceModel(
      id: id,
      name: name,
      description: description,
      status: SequenceStatus.draft,
      steps: steps,
      ownerName: owner,
    );
  }

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        description.toLowerCase().contains(q);
  }
}
