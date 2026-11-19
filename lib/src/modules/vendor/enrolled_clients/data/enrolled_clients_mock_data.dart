import '../models/client_organization_model.dart';

/// Mock data seam for Enrolled Clients.
///
/// TODO(API): Replace with GET /vendor/pricing/enrolled-clients
class EnrolledClientsMockData {
  static List<ClientOrganizationModel> getEnrolledClients() {
    return [
      ClientOrganizationModel(
        id: 'dso-001',
        name: 'Dev Sandbox Organization',
        code: 'D1 · DSO-001',
        status: ClientOrgStatus.active,
        autoApproveEnabled: false,
        notificationsEnabled: true,
        enrolledDate: DateTime(2026, 1, 27),
      ),
    ];
  }
}
