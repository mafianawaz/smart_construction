import '../models/bid_network_models.dart';

/// Mock-data seam for the Bid Network feature.
/// Replace each method with the HTTP call noted in its comment.
class BidNetworkMockData {
  BidNetworkMockData._();

  /// GET /bid-network/requests
  static List<BidRequestModel> requests() => [
        BidRequestModel(
          id: 'bn-1',
          title: 'vendor testing',
          organization: 'dcec',
          description: 'Vendor testing bid',
          trades: const ['ACOUSTICAL CEILINGS', 'ASPHALT PAVING', 'CABINETRY', 'CARPENTRY'],
          status: BidRequestStatus.closed,
          createdAt: DateTime(2026, 2, 6),
          dueDate: DateTime(2026, 7, 20),
          views: 0,
        ),
        BidRequestModel(
          id: 'bn-2',
          title: 'test',
          organization: 'dcec',
          description: 'test',
          scopeOfWork: 'tests',
          trades: const ['COMMUNICATIONS/IT', 'CURB AND GUTTER', 'EARTHWORK'],
          status: BidRequestStatus.open,
          createdAt: DateTime(2026, 2, 6),
          dueDate: DateTime(2026, 2, 10, 5), // details screen is canonical (list card shows Jun 26 in Figma)
          projectStart: DateTime(2026, 2, 13),
          address: 'sfa',
          budgetMin: 10000,
          budgetMax: 20000,
          requiresInsurance: true,
          views: 5,
          invitations: [
            BidInvitationModel(
                subcontractor: 'TFR Construction',
                status: InvitationStatus.pending,
                invitedAt: DateTime(2026, 2, 4)),
            BidInvitationModel(
                subcontractor: 'RealTest Construction',
                status: InvitationStatus.pending,
                invitedAt: DateTime(2026, 2, 4)),
            BidInvitationModel(
                subcontractor: 'TEST',
                status: InvitationStatus.pending,
                invitedAt: DateTime(2026, 2, 4)),
          ],
        ),
      ];

  /// GET /bid-network/settings
  static BidNetworkSettingsModel settings() => const BidNetworkSettingsModel();
}
