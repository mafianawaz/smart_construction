import 'project_enums.dart';

/// One entry in a project's Risk Register.
class RiskModel {
  final String id;
  final String title;
  final String? description;
  final RiskCategory category;
  final RiskStatus status;
  final int probability; // 1-5
  final int impact; // 1-5
  final String? mitigationPlan;
  final String? owner;
  final double? costImpact;
  final int? scheduleImpactDays;
  final String? linkedCostCode;
  final String? linkedMilestone;
  final DateTime createdAt;

  const RiskModel({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.status,
    required this.probability,
    required this.impact,
    this.mitigationPlan,
    this.owner,
    this.costImpact,
    this.scheduleImpactDays,
    this.linkedCostCode,
    this.linkedMilestone,
    required this.createdAt,
  });

  int get score => probability * impact;
  RiskSeverityBand get severityBand => RiskSeverityBandX.fromScore(score);

  String get probabilityLabel => '$probability - ${riskProbabilityScaleLabels[probability - 1]}';
  String get impactLabel => '$impact - ${riskRatingScaleLabels[impact - 1]}';

  bool matchesFilters({RiskCategory? category, RiskStatus? status, RiskSeverityBand? severity}) {
    if (category != null && this.category != category) return false;
    if (status != null && this.status != status) return false;
    if (severity != null && severityBand != severity) return false;
    return true;
  }
}
