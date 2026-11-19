import '../models/bid_model.dart';
import '../models/bid_status.dart';
import '../models/clarification_model.dart';

/// Static stand-in for the bids API. Mirrors MessagesMockData.forRole() —
/// swap BidsMockData.getAll() for a real GET /api/bids call once the
/// backend is ready; the shape of BidModel is already response-ready.
class BidsMockData {
  static List<BidModel> getAll() {
    final now = DateTime.now();
    return [
      BidModel(
        id: 'bid-001',
        organizationName: 'Dev Sandbox Organization',
        title: 'test',
        scopeOfWork: 'tests',
        additionalDescription: 'test',
        requiredTrades: const ['General Contractor'],
        status: BidStatus.declined,
        bidDueDate: DateTime(2026, 2, 10, 5, 0),
        projectStartDate: DateTime(2026, 2, 13),
        location: 'ste',
        insuranceRequired: true,
        clarifications: [
          ClarificationModel(
            id: 'clar-001',
            question: 'Can you confirm the scope covers site prep?',
            askedAt: DateTime(2026, 6, 29),
          ),
        ],
      ),
      BidModel(
        id: 'bid-002',
        organizationName: 'Riverside Builders',
        title: 'Foundation pour — Block C',
        scopeOfWork: 'Excavate and pour foundation for Block C, per attached drawings.',
        additionalDescription: 'Access via the north gate only; site closes at 6pm.',
        requiredTrades: const ['Concrete', 'Excavation'],
        status: BidStatus.pending,
        bidDueDate: now.add(const Duration(days: 5)),
        projectStartDate: now.add(const Duration(days: 20)),
        location: '4500 Riverside Dr',
        insuranceRequired: true,
        clarifications: const [],
      ),
      BidModel(
        id: 'bid-003',
        organizationName: 'Harborview Construction',
        title: 'Electrical rough-in — Unit 4',
        scopeOfWork: 'Rough-in electrical for a 3-bed unit per code, panel included.',
        additionalDescription: 'Inspection scheduled two weeks after rough-in completion.',
        requiredTrades: const ['Electrical'],
        status: BidStatus.responded,
        bidDueDate: now.add(const Duration(days: 10)),
        projectStartDate: now.add(const Duration(days: 25)),
        location: '12 Harbor Way',
        insuranceRequired: false,
        clarifications: [
          ClarificationModel(
            id: 'clar-002',
            question: 'Is the panel upgrade in scope or by others?',
            askedAt: now.subtract(const Duration(days: 3)),
            response: 'Panel upgrade is by others — rough-in only.',
            respondedAt: now.subtract(const Duration(days: 2)),
          ),
        ],
      ),
    ];
  }
}
