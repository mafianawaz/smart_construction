import 'project_enums.dart';

/// One estimate line item (Add Manual Line Items / Import Takeoff).
/// All cost fields are the line's own dollar amounts — they are NOT
/// multiplied by [quantity] (placeholder math, see NOTES_ESTIMATING_TABS.md).
class EstimateLineItemModel {
  final String id;
  final String description;
  final EstimateLineCategory category;
  final String unit;
  final double quantity;
  final String laborClassification;
  final double laborHours;
  final double laborCost;
  final double equipmentCost;
  final double consumablesCost;
  final double subcontractCost;
  final double overheadAllocation;
  final double profitAllocation;
  final String? notes;

  const EstimateLineItemModel({
    required this.id,
    required this.description,
    this.category = EstimateLineCategory.other,
    this.unit = '',
    this.quantity = 0,
    this.laborClassification = manualLaborClassification,
    this.laborHours = 0,
    this.laborCost = 0,
    this.equipmentCost = 0,
    this.consumablesCost = 0,
    this.subcontractCost = 0,
    this.overheadAllocation = 0,
    this.profitAllocation = 0,
    this.notes,
  });

  double get directCost => laborCost + equipmentCost + consumablesCost + subcontractCost;
  double get allocations => overheadAllocation + profitAllocation;
}

/// Roll-up shown in the four stat cards and the breakdown card.
class EstimateTotals {
  final int lineCount;
  final double total;
  final double materialCost;
  final double laborCost;
  final double profitAmount;

  /// Dollar amount each markup added, for the breakdown rows.
  final Map<MarkupKind, double> markupAmounts;

  const EstimateTotals({
    this.lineCount = 0,
    this.total = 0,
    this.materialCost = 0,
    this.laborCost = 0,
    this.profitAmount = 0,
    this.markupAmounts = const {},
  });

  double get materialShare => total <= 0 ? 0 : materialCost / total * 100;
  double get laborShare => total <= 0 ? 0 : laborCost / total * 100;
  double get profitMargin => total <= 0 ? 0 : profitAmount / total * 100;
}

/// PLACEHOLDER math — the reference only shows $0.00 values, so the
/// formula below is a guess at "markup-adjusted bid total using org-wide
/// estimating factors". Swap for the server's numbers when the estimate
/// API lands. Flagged in NOTES_ESTIMATING_TABS.md.
///
///   material  = sum(consumablesCost)
///   labor     = sum(laborCost)
///   base      = direct costs + labor burden% of labor + waste% of material
///   total     = base + smallTools/overhead/escalation% of base
///               + profit% and bond% of the running subtotal
///               + per-line overhead/profit allocations
class EstimateCalculator {
  EstimateCalculator._();

  static EstimateTotals compute(
    List<EstimateLineItemModel> items,
    double Function(MarkupKind) percentOf,
  ) {
    if (items.isEmpty) return const EstimateTotals();

    double labor = 0, material = 0, direct = 0, allocations = 0, profitAllocation = 0;
    for (final i in items) {
      labor += i.laborCost;
      material += i.consumablesCost;
      direct += i.directCost;
      allocations += i.allocations;
      profitAllocation += i.profitAllocation;
    }

    double pct(MarkupKind k) => percentOf(k) / 100;

    final burden = labor * pct(MarkupKind.laborBurden);
    final waste = material * pct(MarkupKind.waste);
    final base = direct + burden + waste;

    final smallTools = base * pct(MarkupKind.smallTools);
    final overhead = base * pct(MarkupKind.overhead);
    final escalation = base * pct(MarkupKind.escalation);
    final subtotal = base + smallTools + overhead + escalation;

    final profit = subtotal * pct(MarkupKind.profit);
    final bond = (subtotal + profit) * pct(MarkupKind.bond);

    final total = subtotal + profit + bond + allocations;

    return EstimateTotals(
      lineCount: items.length,
      total: total,
      materialCost: material,
      laborCost: labor,
      profitAmount: profit + profitAllocation,
      markupAmounts: {
        MarkupKind.laborBurden: burden,
        MarkupKind.waste: waste,
        MarkupKind.smallTools: smallTools,
        MarkupKind.overhead: overhead,
        MarkupKind.escalation: escalation,
        MarkupKind.profit: profit,
        MarkupKind.bond: bond,
      },
    );
  }
}
