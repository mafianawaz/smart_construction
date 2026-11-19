/// Workforce → Workers models.
enum WorkerStatus { active, inactive }

enum EmploymentType { fullTime, partTime, contract }

extension EmploymentTypeX on EmploymentType {
  String get label {
    switch (this) {
      case EmploymentType.fullTime:
        return 'Full-time';
      case EmploymentType.partTime:
        return 'Part-time';
      case EmploymentType.contract:
        return 'Contract';
    }
  }
}

extension WorkerStatusX on WorkerStatus {
  String get label => this == WorkerStatus.active ? 'Active' : 'Inactive';
}

enum CertStatus { active, expiringSoon, expired }

extension CertStatusX on CertStatus {
  String get label {
    switch (this) {
      case CertStatus.active:
        return 'Active';
      case CertStatus.expiringSoon:
        return 'Expiring';
      case CertStatus.expired:
        return 'Expired';
    }
  }
}

class WorkerCertification {
  final String name;
  final DateTime expires;
  final CertStatus status;

  const WorkerCertification({
    required this.name,
    required this.expires,
    required this.status,
  });

  String get expiresLabel => 'Expires: ${WorkforceDates.monthYear(expires)}';
}

class WorkerModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String emergencyContact;
  final String employeeId;
  final String department;

  /// e.g. "Electrician"
  final String tradeRole;

  /// e.g. "Journeyman" / "Apprentice"
  final String level;

  /// Trade tag shown on the list card, e.g. "Electrical".
  final String trade;

  /// System role used by the "All Roles" filter, e.g. "Field Worker".
  final String roleLabel;
  final EmploymentType employmentType;
  final DateTime hireDate;
  final WorkerStatus status;
  final String currentAssignment;
  final double hoursThisWeek;
  final double totalProgramHours;
  final List<WorkerCertification> certifications;

  /// Optional. When null (or the image fails) initials are shown.
  final String? avatarUrl;

  const WorkerModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.emergencyContact,
    required this.employeeId,
    required this.department,
    required this.tradeRole,
    required this.level,
    required this.trade,
    required this.roleLabel,
    required this.employmentType,
    required this.hireDate,
    required this.status,
    required this.currentAssignment,
    required this.hoursThisWeek,
    required this.totalProgramHours,
    this.certifications = const [],
    this.avatarUrl,
  });

  /// "Electrician - Journeyman"
  String get title => '$tradeRole - $level';

  String get tradeRoleLabel => title;

  String get initials {
    final parts =
        fullName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    final list = parts.toList();
    final first = list.first[0];
    final last = list.length > 1 ? list.last[0] : '';
    return (first + last).toUpperCase();
  }

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return fullName.toLowerCase().contains(q) ||
        email.toLowerCase().contains(q) ||
        employeeId.toLowerCase().contains(q) ||
        trade.toLowerCase().contains(q);
  }
}

/// Tiny date helpers so the module doesn't depend on `intl`.
class WorkforceDates {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// "Jan 15, 2024"
  static String full(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

  /// "Dec 2026"
  static String monthYear(DateTime d) => '${_months[d.month - 1]} ${d.year}';
}
