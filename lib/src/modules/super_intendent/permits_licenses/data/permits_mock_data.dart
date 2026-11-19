import '../models/permit_models.dart';

/// Mock seam for Permits & Licenses.
class PermitsMockData {
  PermitsMockData._();

  static DateTime _inDays(int n) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).add(Duration(days: n));
  }

  // TODO(api): GET /permits?expiringWithinDays=30
  // Order matches the reference design (not sorted by days remaining).
  static List<PermitModel> fetchPermits() => [
        PermitModel(
          id: 'bp-001',
          name: 'Building Permit',
          number: 'BP-2024-001',
          projectName: 'Riverside Plaza',
          issuingAuthority: 'City Building Department',
          issuedDate: _inDays(-335),
          expiryDate: _inDays(5),
        ),
        PermitModel(
          id: 'ep-015',
          name: 'Electrical Permit',
          number: 'EP-2024-015',
          projectName: 'Downtown Tower',
          issuingAuthority: 'County Electrical Board',
          issuedDate: _inDays(-353),
          expiryDate: _inDays(12),
        ),
        PermitModel(
          id: 'pp-008',
          name: 'Plumbing Permit',
          number: 'PP-2024-008',
          projectName: 'Oak Street Renovation',
          issuingAuthority: 'City Building Department',
          issuedDate: _inDays(-347),
          expiryDate: _inDays(18),
        ),
        PermitModel(
          id: 'fs-003',
          name: 'Fire Safety Permit',
          number: 'FS-2024-003',
          projectName: 'Harbor View Apartments',
          issuingAuthority: 'Fire Marshal Office',
          issuedDate: _inDays(-340),
          expiryDate: _inDays(25),
        ),
        PermitModel(
          id: 'dp-012',
          name: 'Demolition Permit',
          number: 'DP-2024-012',
          projectName: 'Industrial Park Site B',
          issuingAuthority: 'City Building Department',
          issuedDate: _inDays(-362),
          expiryDate: _inDays(3),
        ),
        // Outside the 30-day window: filtered out by the logic layer.
        PermitModel(
          id: 'mp-020',
          name: 'Mechanical Permit',
          number: 'MP-2024-020',
          projectName: 'Downtown Tower',
          issuingAuthority: 'County Mechanical Board',
          issuedDate: _inDays(-200),
          expiryDate: _inDays(120),
        ),
      ];
}
