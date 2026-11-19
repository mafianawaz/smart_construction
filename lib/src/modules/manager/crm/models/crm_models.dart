// CRM models. Pure Dart (no Flutter imports) so they stay API-ready.

// ─────────────────────────── Organizations ───────────────────────────

enum OrgType { vendor, subcontractor, gcContractor, ownerRep, supplier }

extension OrgTypeX on OrgType {
  String get label {
    switch (this) {
      case OrgType.vendor:
        return 'Vendor';
      case OrgType.subcontractor:
        return 'Subcontractor';
      case OrgType.gcContractor:
        return 'GC / Contractor';
      case OrgType.ownerRep:
        return 'Owner Rep';
      case OrgType.supplier:
        return 'Supplier';
    }
  }
}

enum OrgStatus { active, inactive }

extension OrgStatusX on OrgStatus {
  String get label => this == OrgStatus.active ? 'Active' : 'Inactive';
}

enum ComplianceItemState { valid, expiringSoon, expired }

class ComplianceItem {
  final String label; // e.g. "Contract", "Insurance"
  final ComplianceItemState state;

  const ComplianceItem({required this.label, required this.state});

  bool get needsAttention => state != ComplianceItemState.valid;
}

class OrganizationModel {
  final String id;
  final String name;
  final OrgType type;
  final OrgStatus status;
  final String street;
  final String city;
  final String state;
  final String zip;

  /// Display name of the owner. `null` renders as "Unassigned".
  final String? ownerName;

  /// Optional role appended to the owner line ("Site-Work - Cost Estimator").
  final String? ownerRole;

  /// Optional single category line shown on the card (e.g. "cement").
  final String? category;
  final List<String> specialties;
  final List<String> relatedProjects;
  final List<ComplianceItem> complianceItems;

  const OrganizationModel({
    required this.id,
    required this.name,
    required this.type,
    this.status = OrgStatus.active,
    this.street = '',
    this.city = '',
    this.state = '',
    this.zip = '',
    this.ownerName,
    this.ownerRole,
    this.category,
    this.specialties = const [],
    this.relatedProjects = const [],
    this.complianceItems = const [],
  });

  bool get isActive => status == OrgStatus.active;
  bool get isActiveOnProjects => relatedProjects.isNotEmpty;
  bool get hasComplianceIssue => complianceItems.any((c) => c.needsAttention);

  String get ownerLabel => ownerName ?? 'Unassigned';

  /// Owner line on the card: "Name" or "Name - Role".
  String get ownerLine {
    if (ownerName == null) return 'Unassigned';
    final role = ownerRole;
    return (role == null || role.isEmpty) ? ownerName! : '$ownerName - $role';
  }

  /// "Columbus, Ohio"
  String get locationLabel {
    final parts = [city, state].where((p) => p.trim().isNotEmpty).toList();
    return parts.isEmpty ? '—' : parts.join(', ');
  }

  /// Street on line 1, "City, State, ZIP" on line 2.
  String get addressLabel {
    final line2 =
        [city, state, zip].where((p) => p.trim().isNotEmpty).join(', ');
    final lines = [street, line2].where((p) => p.trim().isNotEmpty).toList();
    return lines.isEmpty ? '—' : lines.join('\n');
  }

  OrganizationModel copyWith({
    String? name,
    OrgType? type,
    OrgStatus? status,
    String? street,
    String? city,
    String? state,
    String? zip,
    Object? ownerName = _keep,
    Object? ownerRole = _keep,
    Object? category = _keep,
    List<String>? specialties,
    List<String>? relatedProjects,
    List<ComplianceItem>? complianceItems,
  }) {
    return OrganizationModel(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      ownerName: identical(ownerName, _keep)
          ? this.ownerName
          : ownerName as String?,
      ownerRole: identical(ownerRole, _keep)
          ? this.ownerRole
          : ownerRole as String?,
      category:
          identical(category, _keep) ? this.category : category as String?,
      specialties: specialties ?? this.specialties,
      relatedProjects: relatedProjects ?? this.relatedProjects,
      complianceItems: complianceItems ?? this.complianceItems,
    );
  }
}

/// Sentinel so copyWith can distinguish "not passed" from an explicit null.
const Object _keep = Object();

/// One row in the Compliance Alert banner.
class ComplianceAlertEntry {
  final String organizationName;
  final ComplianceItem item;

  const ComplianceAlertEntry({
    required this.organizationName,
    required this.item,
  });
}

// ───────────────────────────── Contacts ─────────────────────────────

class ContactModel {
  final String id;
  final String name;
  final bool isPrimary;
  final String role;
  final String organizationName;
  final String? ownerName;
  final String email;
  final String phone;
  final DateTime? birthday;

  const ContactModel({
    required this.id,
    required this.name,
    this.isPrimary = false,
    this.role = '',
    this.organizationName = '',
    this.ownerName,
    this.email = '',
    this.phone = '',
    this.birthday,
  });

  String get ownerLabel => ownerName ?? 'Unassigned';
  String get phoneLabel => phone.trim().isEmpty ? '—' : phone;

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        email.toLowerCase().contains(q) ||
        organizationName.toLowerCase().contains(q);
  }
}

// ───────────────────────────── Pipeline ─────────────────────────────

enum OpportunityStage {
  lead,
  qualified,
  estimating,
  bidSubmitted,
  negotiation,
  won,
  lost,
}

extension OpportunityStageX on OpportunityStage {
  String get label {
    switch (this) {
      case OpportunityStage.lead:
        return 'Lead';
      case OpportunityStage.qualified:
        return 'Qualified';
      case OpportunityStage.estimating:
        return 'Estimating';
      case OpportunityStage.bidSubmitted:
        return 'Bid Submitted';
      case OpportunityStage.negotiation:
        return 'Negotiation';
      case OpportunityStage.won:
        return 'Won';
      case OpportunityStage.lost:
        return 'Lost';
    }
  }

  /// PLACEHOLDER win probabilities used for "Weighted Value".
  /// Replace with the backend's per-stage probability when available.
  double get probability {
    switch (this) {
      case OpportunityStage.lead:
        return 0.10;
      case OpportunityStage.qualified:
        return 0.25;
      case OpportunityStage.estimating:
        return 0.40;
      case OpportunityStage.bidSubmitted:
        return 0.60;
      case OpportunityStage.negotiation:
        return 0.80;
      case OpportunityStage.won:
        return 1.0;
      case OpportunityStage.lost:
        return 0.0;
    }
  }

  bool get isOpen =>
      this != OpportunityStage.won && this != OpportunityStage.lost;
}

/// One entry in an opportunity's stage history ("moved into [stage] at ...").
/// Powers the Time in Stage report.
class StageTransition {
  final OpportunityStage stage;
  final DateTime enteredAt;

  const StageTransition({required this.stage, required this.enteredAt});
}

class OpportunityModel {
  final String id;
  final String title;
  final String organizationName;
  final OpportunityStage stage;
  final double value;
  final String? assignee;

  // ── Analytics / Reports fields (all optional so existing code keeps working) ──

  /// Lead source, e.g. "web_form". `null` is reported as "UNKNOWN".
  final String? source;
  final DateTime? expectedCloseDate;

  /// Why the deal was lost (only meaningful when stage == lost).
  final String? lostReason;
  final DateTime? createdAt;

  /// When the deal reached Won / Lost.
  final DateTime? closedAt;
  final List<StageTransition> stageHistory;

  const OpportunityModel({
    required this.id,
    required this.title,
    required this.organizationName,
    this.stage = OpportunityStage.lead,
    this.value = 0,
    this.assignee,
    this.source,
    this.expectedCloseDate,
    this.lostReason,
    this.createdAt,
    this.closedAt,
    this.stageHistory = const [],
  });

  String get assigneeLabel => assignee ?? 'Unassigned';

  /// "WEB_FORM"-style label used by Source Effectiveness.
  String get sourceLabel {
    final s = (source ?? '').trim();
    if (s.isEmpty) return 'UNKNOWN';
    return s.toUpperCase().replaceAll(RegExp(r'\s+'), '_');
  }

  double get weightedValue => value * stage.probability;

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return title.toLowerCase().contains(q) ||
        organizationName.toLowerCase().contains(q);
  }
}

// ─────────────────────────────── Tabs ───────────────────────────────

enum CrmTab {
  organizations,
  contacts,
  analytics,
  reports,
  sequences,
  pipeline,
  tasks,
  calls,
  quotes,
}

extension CrmTabX on CrmTab {
  String get label {
    switch (this) {
      case CrmTab.organizations:
        return 'Organizations';
      case CrmTab.contacts:
        return 'Contacts';
      case CrmTab.analytics:
        return 'Analytics';
      case CrmTab.reports:
        return 'Reports';
      case CrmTab.sequences:
        return 'Sequences';
      case CrmTab.pipeline:
        return 'Pipeline';
      case CrmTab.tasks:
        return 'Tasks';
      case CrmTab.calls:
        return 'Calls';
      case CrmTab.quotes:
        return 'Quotes';
    }
  }
}

enum PipelineViewMode { board, list }
