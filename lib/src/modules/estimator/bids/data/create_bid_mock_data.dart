import '../models/scope_item_model.dart';

/// Mock seam standing in for two future HTTP calls:
///   POST /bids/analyze-documents   -> AI-extracted scope items
///   POST /bids                     -> create the bid
///
/// [simulateAnalysis] takes a `forceFail` flag purely so the UI's
/// failed-state can be demoed on demand; a real implementation would
/// just let the request throw and be caught by the caller.
class CreateBidMockData {
  CreateBidMockData._();

  static Future<List<ScopeItemModel>> simulateAnalysis({
    bool forceFail = false,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    if (forceFail) {
      throw Exception('AI analysis failed');
    }

    return suggestedScopeItems();
  }

  static List<ScopeItemModel> suggestedScopeItems() {
    return const [
      ScopeItemModel(
        id: 'scope_001',
        description:
            'Excavation and site preparation for new residential '
            'foundation, including grading and compaction',
        quantity: 1,
        unit: 'lot',
        estimatedCost: 4200,
        isAiSuggested: true,
      ),
      ScopeItemModel(
        id: 'scope_002',
        description:
            'Supply and install reinforced concrete footings per '
            'engineered drawings',
        quantity: 180,
        unit: 'ft',
        estimatedCost: 6300,
        isAiSuggested: true,
      ),
      ScopeItemModel(
        id: 'scope_003',
        description: 'Framing labor for exterior load-bearing walls',
        quantity: 1,
        unit: 'lot',
        estimatedCost: 8900,
        isAiSuggested: true,
      ),
    ];
  }

  /// API: GET /crm/contacts
  static const List<String> crmContacts = [
    'Stump and Dailey',
    'Kessler Builders',
    'Brightline Mechanical',
  ];

  /// API: GET /crm/organization-statuses
  static const List<String> orgStatuses = [
    'Prospect',
    'Active Client',
    'Past Client',
  ];

  /// API: GET /crm/contacts/{id} — used by "Use saved contact" on the
  /// Details step. Returns [name, contactName, email, phone].
  static List<String> savedContact() =>
      const ['Stump and Dailey', 'Maisie Hicks', 'maisie@stumpdailey.com', '(330) 555-0142'];

  /// Simulated `POST /bids`. Returns a fake bid id.
  static Future<String> submitBid() async {
    await Future.delayed(const Duration(milliseconds: 900));
    return 'bid_${DateTime.now().millisecondsSinceEpoch}';
  }
}
