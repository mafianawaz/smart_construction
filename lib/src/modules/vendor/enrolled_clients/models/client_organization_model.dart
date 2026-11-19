/// Enrollment status of a contractor organization.
enum ClientOrgStatus { active, pending }

extension ClientOrgStatusX on ClientOrgStatus {
  String get label => this == ClientOrgStatus.active ? 'Active' : 'Pending';
}

/// A contractor organization that has enrolled to receive this vendor's
/// pricing submissions.
class ClientOrganizationModel {
  final String id;
  final String name;
  final String code; // e.g. "D1 · DSO-001"
  final ClientOrgStatus status;
  final bool autoApproveEnabled;
  final bool notificationsEnabled;
  final DateTime enrolledDate;

  const ClientOrganizationModel({
    required this.id,
    required this.name,
    required this.code,
    required this.status,
    required this.autoApproveEnabled,
    required this.notificationsEnabled,
    required this.enrolledDate,
  });

  ClientOrganizationModel copyWith({
    ClientOrgStatus? status,
    bool? autoApproveEnabled,
    bool? notificationsEnabled,
  }) {
    return ClientOrganizationModel(
      id: id,
      name: name,
      code: code,
      status: status ?? this.status,
      autoApproveEnabled: autoApproveEnabled ?? this.autoApproveEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      enrolledDate: enrolledDate,
    );
  }

  String get formattedEnrolledDate {
    final d = enrolledDate;
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }
}
