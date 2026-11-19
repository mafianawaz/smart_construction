import '../models/financial_models.dart';
import '../models/procurement_models.dart';
import '../models/project_enums.dart';

/// Mock-data seam for the Procurement orders and the Financials tab. Every
/// `// API:` comment marks where the real call replaces the stub. The
/// references show empty states almost everywhere, so lists start empty and
/// fill as the pushed forms create records; Live Financials is seeded to
/// match the reference ($782 labor against a $0 budget).
class FinancialsMockData {
  FinancialsMockData._();

  // API: GET /projects/{id}/purchase-orders
  static List<PurchaseOrderModel> purchaseOrders(String projectId) => const [];

  // API: GET /projects/{id}/financials/live
  static LiveFinancialsModel liveFinancials(String projectId) => const LiveFinancialsModel(
        budget: 0,
        costs: {CostCategory.labor: 782},
        laborHours: 12.64,
      );

  // API: GET /projects/{id}/budget/lines
  static List<BudgetLineModel> budgetLines(String projectId) => const [];

  // API: GET /projects/{id}/cost-ledger
  static List<CostLedgerRow> costLedger(String projectId) {
    final live = liveFinancials(projectId);
    // Labor with no cost code lands on "(Unassigned)", as in the reference.
    return [CostLedgerRow(code: '(Unassigned)', actual: live.totalActual)];
  }

  // API: GET /projects/{id}/cost-transactions
  static List<CostTransactionModel> costTransactions(String projectId) => const [];

  // API: GET /projects/{id}/change-orders
  static List<ChangeOrderRecord> changeOrders(String projectId) => const [];

  // API: GET /projects/{id}/receipts
  static List<ReceiptRecord> receipts(String projectId) => const [];

  // API: GET /projects/{id}/sovs
  static List<SovRecord> sovs(String projectId) => const [];

  // API: GET /projects/{id}/sov-payments
  static List<PaymentRecord> payments(String projectId) => const [];

  // API: GET /projects/{id}/lien-waivers
  static List<LienWaiverRecord> lienWaivers(String projectId) => const [];

  /// Guessed — the Vendor field is a "Select vendor..." dropdown with no
  /// options shown. API: GET /org/vendors
  static const List<String> vendors = [
    'ABC Building Supply',
    'Lone Star Concrete',
    'Metro Lumber & Millwork',
    'Summit Electrical Wholesale',
    'Prime Equipment Rental',
  ];

  /// Guessed — Change Order "Work Type Category" -> "Work Type" cascade
  /// (the reference shows both dropdowns closed). API: GET /org/work-types
  static const Map<String, List<String>> workTypes = {
    'Concrete': ['Footings', 'Slab on Grade', 'Elevated Slab', 'Flatwork'],
    'Framing': ['Wall Framing', 'Roof Framing', 'Floor Framing'],
    'Masonry': ['CMU Block', 'Brick Veneer', 'Stone'],
    'Finishes': ['Drywall', 'Painting', 'Tile', 'Flooring'],
    'Site Work': ['Excavation', 'Grading', 'Paving'],
  };
}
