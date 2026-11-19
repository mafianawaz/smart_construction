import 'package:intl/intl.dart';
import 'project_enums.dart';

class RiskBreakdownItem {
  final String label;
  final double weight; // e.g. 0.25 for "25%"
  final RiskLevel level;

  const RiskBreakdownItem({
    required this.label,
    required this.weight,
    required this.level,
  });

  String get weightLabel => '${(weight * 100).round()}%';
}

/// One project on the "All Projects" board and behind Project Detail.
class ProjectModel {
  final String id;
  final String number;
  final String title;
  final ProjectStatus status;
  final String clientName;
  final String superintendent;
  final String estimator;

  /// 0.0–1.0. Not given numerically in the reference — the reference
  /// only shows a bar next to the health text, flagged as a placeholder
  /// in NOTES_PROJECTS.md.
  final double completionProgress;
  final int healthScore; // 0-100

  /// Project Information card. Whether the project *record* is active
  /// in the system — independent of [status], which is the lifecycle
  /// stage ("Planning" can still have an active record). The reference
  /// showed "Planning" on the header pill and "ACTIVE" in this card at
  /// once; treating them as two different fields resolves that,
  /// flagged in NOTES_PROJECTS.md.
  final bool isRecordActive;
  final String? contactName;

  /// The "Contact" field on the Project Information card — a role/title
  /// (e.g. "Site Super") shown separately from [contactPhone]. The
  /// reference shows both as "N/A" so this distinction is a guess,
  /// flagged in NOTES_PROJECTS.md.
  final String? contactTitle;
  final String? contactEmail;
  final String? contactPhone;
  final String? location;

  final List<RiskBreakdownItem> riskBreakdown;
  final double budget;
  final double contractAmount;
  final double marginPercent;
  final String description;
  final int dataQualityScore; // 0-100

  const ProjectModel({
    required this.id,
    required this.number,
    required this.title,
    required this.status,
    required this.clientName,
    required this.superintendent,
    required this.estimator,
    required this.completionProgress,
    required this.healthScore,
    this.isRecordActive = true,
    this.contactName,
    this.contactTitle,
    this.contactEmail,
    this.contactPhone,
    this.location,
    this.riskBreakdown = const [],
    this.budget = 0,
    this.contractAmount = 0,
    this.marginPercent = 0,
    this.description = '',
    this.dataQualityScore = 0,
  });

  static final _money = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
  String get budgetLabel => _money.format(budget);
  String get contractAmountLabel => _money.format(contractAmount);
  String get marginLabel => '${marginPercent.toStringAsFixed(1)}%';

  bool matchesQuery(String q) {
    if (q.isEmpty) return true;
    return title.toLowerCase().contains(q) ||
        clientName.toLowerCase().contains(q) ||
        number.toLowerCase().contains(q);
  }
}
