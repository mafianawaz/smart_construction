import '../models/bid_model.dart';
import '../models/clarification_model.dart';

/// Mock seam for the Bids list + details.
///
///   API: GET /bids?view=board   -> [boardBids]
///   API: GET /bids?view=inbox   -> [inboxBids]
///   API: POST /bids/{id}/clarifications -> see BidDetailsLogic.addQuestion
class BidsMockData {
  BidsMockData._();

  static List<BidModel> boardBids() {
    return [
      const BidModel(
        id: 'bid_260760',
        number: '260760',
        title: 'ODNR Boat Ramp To be Demod and Rebuilt at Berlin Lake',
        clientName: 'Stump and Dailey',
        status: BidStatus.awarded,
        scopeOfWork:
            'Demolition of the existing boat ramp and reconstruction of a '
            'new concrete ramp, including site prep and shoreline work.',
        additionalDescription: 'Work window limited to off-season months.',
        requiredTrades: ['Concrete', 'Excavation'],
      ),
      const BidModel(
        id: 'bid_260762',
        number: '260762',
        title: 'Lakeview Marina Dock Replacement',
        clientName: 'Stump and Dailey',
        status: BidStatus.draft,
        scopeOfWork: 'Replace 240 ft of floating dock and anchor system.',
        requiredTrades: ['Marine', 'Carpentry'],
      ),
    ];
  }

  static List<BidModel> inboxBids() {
    return [
      BidModel(
        id: 'bid_260755',
        number: '260755',
        title: 'HVAC Replacement - Northside Elementary',
        clientName: 'Brightline Mechanical',
        status: BidStatus.expired,
        dueDate: DateTime(2026, 2, 18, 5, 0),
        projectStart: DateTime(2026, 3, 2),
        location: 'Columbus, OH',
        scopeOfWork:
            'Replace rooftop HVAC units and associated ductwork across '
            'the north wing.',
        additionalDescription:
            'Pre-bid walkthrough was held; addenda 1-2 are attached.',
        requiredTrades: ['HVAC', 'Electrical'],
        clarifications: [
          ClarificationModel(
            id: 'clar_1',
            question: 'Is union labor required for this project?',
            askedBy: 'You',
            askedAt: DateTime(2026, 2, 5),
            answer: 'Prevailing wage applies; union labor is not required.',
          ),
        ],
      ),
      BidModel(
        id: 'bid_260758',
        number: '260758',
        title: 'Riverside Community Center Roof Repair',
        clientName: 'Kessler Builders',
        status: BidStatus.active,
        dueDate: DateTime(2026, 11, 20, 17, 0),
        projectStart: DateTime(2027, 1, 12),
        location: 'Dayton, OH',
        scopeOfWork: 'Tear-off and replacement of 14,000 sq ft membrane roof.',
        requiredTrades: ['Roofing'],
      ),
      BidModel(
        id: 'bid_260759',
        number: '260759',
        title: 'Municipal Parking Structure Restriping',
        clientName: 'City of Springfield',
        status: BidStatus.awarded,
        dueDate: DateTime(2026, 8, 30, 12, 0),
        projectStart: DateTime(2026, 9, 15),
        location: 'Springfield, OH',
        scopeOfWork: 'Restriping and signage for three parking levels.',
        requiredTrades: ['Paving', 'Signage'],
      ),
    ];
  }
}
