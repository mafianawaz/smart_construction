/// Workforce → Performance models (KPI templates + ratings).
enum KpiCategory { financial, safety, quality, productivity, schedule, custom }

extension KpiCategoryX on KpiCategory {
  String get label {
    switch (this) {
      case KpiCategory.financial:
        return 'Financial';
      case KpiCategory.safety:
        return 'Safety';
      case KpiCategory.quality:
        return 'Quality';
      case KpiCategory.productivity:
        return 'Productivity';
      case KpiCategory.schedule:
        return 'Schedule';
      case KpiCategory.custom:
        return 'Custom';
    }
  }
}

enum KpiDirection { higherIsBetter, lowerIsBetter }

extension KpiDirectionX on KpiDirection {
  String get label =>
      this == KpiDirection.higherIsBetter ? 'Higher is Better' : 'Lower is Better';
  String get shortLabel => this == KpiDirection.higherIsBetter ? 'Higher' : 'Lower';
}

enum KpiStatus { active, inactive }

extension KpiStatusX on KpiStatus {
  String get label => this == KpiStatus.active ? 'Active' : 'Inactive';
}

/// A role a KPI can be assigned to / rated against.
class RatingRole {
  final String label; // "Field Worker"
  final String code; // "FIELD_WORKER"
  const RatingRole(this.label, this.code);

  String get display => '$label - $code';
}

class KpiTemplate {
  final String id;
  final String name;
  final String description;
  final KpiCategory category;
  final String unit;
  final KpiDirection direction;
  final KpiStatus status;

  /// Optional numeric target. Quick Stats "With Targets" counts non-null.
  final double? target;

  /// Role codes this KPI is scored for in Rate Employee.
  final List<String> assignedRoleCodes;

  const KpiTemplate({
    required this.id,
    required this.name,
    this.description = '',
    required this.category,
    required this.unit,
    required this.direction,
    this.status = KpiStatus.active,
    this.target,
    this.assignedRoleCodes = const [],
  });

  KpiTemplate copyWith({
    String? name,
    String? description,
    KpiCategory? category,
    String? unit,
    KpiDirection? direction,
    KpiStatus? status,
    double? target,
    List<String>? assignedRoleCodes,
  }) {
    return KpiTemplate(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      direction: direction ?? this.direction,
      status: status ?? this.status,
      target: target ?? this.target,
      assignedRoleCodes: assignedRoleCodes ?? this.assignedRoleCodes,
    );
  }

  bool get isActive => status == KpiStatus.active;

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        description.toLowerCase().contains(q) ||
        category.label.toLowerCase().contains(q);
  }
}

class KpiScore {
  final String kpiName;
  final double score; // 0..10
  const KpiScore(this.kpiName, this.score);
}

class KpiRating {
  final String id;
  final String roleDisplay;
  final String period;
  final String feedback;
  final List<KpiScore> scores;
  final DateTime createdAt;

  const KpiRating({
    required this.id,
    required this.roleDisplay,
    required this.period,
    required this.feedback,
    required this.scores,
    required this.createdAt,
  });

  /// Average score as a 0..100 percentage.
  double get overallPercent {
    if (scores.isEmpty) return 0;
    final sum = scores.fold<double>(0, (a, b) => a + b.score);
    return (sum / scores.length) / 10 * 100;
  }
}

// ── Assignments / results ─────────────────────────────────────────────

/// An employee a KPI can be assigned to / reviewed for.
class KpiEmployee {
  final String id;
  final String name;
  final String roleCode; // "SUPERINTENDENT"

  const KpiEmployee({required this.id, required this.name, required this.roleCode});

  /// "Test SUPERINTENDENT" — as shown in the Performance dropdown.
  String get label => '$name $roleCode';
}

enum KpiAssignmentStatus { active, pending }

extension KpiAssignmentStatusX on KpiAssignmentStatus {
  String get label => this == KpiAssignmentStatus.active ? 'Active' : 'Pending';
}

class KpiAssignment {
  final String id;
  final String employeeId;
  final String employeeName;
  final String roleCode;
  final String kpiId;
  final String kpiName;
  final KpiCategory category;
  final String unit;
  final double? target;
  final String period; // "Q1 2026"
  final KpiAssignmentStatus status;

  /// 0..1
  final double progress;

  const KpiAssignment({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.roleCode,
    required this.kpiId,
    required this.kpiName,
    required this.category,
    required this.unit,
    this.target,
    required this.period,
    this.status = KpiAssignmentStatus.pending,
    this.progress = 0,
  });
}

/// One KPI's target vs actual for an employee in a period.
class KpiResult {
  final String id;
  final String employeeId;
  final String kpiId;
  final String kpiName;
  final KpiCategory category;
  final String unit;
  final KpiDirection direction;
  final double target;

  /// null while the result is still pending.
  final double? actual;
  final String period;

  const KpiResult({
    required this.id,
    required this.employeeId,
    required this.kpiId,
    required this.kpiName,
    required this.category,
    required this.unit,
    this.direction = KpiDirection.higherIsBetter,
    required this.target,
    this.actual,
    required this.period,
  });

  bool get isCompleted => actual != null;

  /// 0..100. Placeholder maths: higher-is-better = actual / target;
  /// lower-is-better = 100% when at or under target, else target / actual.
  double get scorePercent {
    final a = actual;
    if (a == null) return 0;
    double v;
    if (direction == KpiDirection.higherIsBetter) {
      v = target == 0 ? (a > 0 ? 100 : 0) : a / target * 100;
    } else {
      v = a <= target ? 100 : (a == 0 ? 100 : target / a * 100);
    }
    return v.clamp(0, 100).toDouble();
  }
}
