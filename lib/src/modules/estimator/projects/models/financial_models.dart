import 'project_enums.dart';

/// Snapshot behind the Live Financials sub-tab.
class LiveFinancialsModel {
  final double budget;
  final Map<CostCategory, double> costs;
  final double laborHours;
  final int subcontractorCount;
  final int tmTicketCount;

  const LiveFinancialsModel({
    this.budget = 0,
    this.costs = const {},
    this.laborHours = 0,
    this.subcontractorCount = 0,
    this.tmTicketCount = 0,
  });

  double costOf(CostCategory c) => costs[c] ?? 0;

  double get totalActual => costs.values.fold(0.0, (a, b) => a + b);

  /// Share of budget spent, 0–100. Shown as 0.0% when there is no budget,
  /// as in the reference (which has $782 of cost against a $0 budget).
  double get budgetConsumedPercent => budget > 0 ? totalActual / budget * 100 : 0;

  double get overBudgetPercent => budget > 0 && totalActual > budget
      ? (totalActual - budget) / budget * 100
      : 0;

  /// The amber warning banner shows whenever actual cost exceeds budget.
  bool get isOverBudget => totalActual > budget;
}

/// One line of "Project Budget by Cost Code".
class BudgetLineModel {
  final String costCode;
  final String description;
  final String division;
  final double labor;
  final double materials;
  final double subcontractors;
  final double equipment;
  final double other;

  const BudgetLineModel({
    required this.costCode,
    required this.description,
    this.division = '',
    this.labor = 0,
    this.materials = 0,
    this.subcontractors = 0,
    this.equipment = 0,
    this.other = 0,
  });

  double get total => labor + materials + subcontractors + equipment + other;
}

/// One row of "Cost Ledger by Cost Code".
class CostLedgerRow {
  final String code;
  final String description;
  final double budget;
  final double committed;
  final double actual;
  final double etc;

  const CostLedgerRow({
    required this.code,
    this.description = '',
    this.budget = 0,
    this.committed = 0,
    this.actual = 0,
    this.etc = 0,
  });

  /// Projected variance = budget − (actual + ETC); negative is over budget.
  double get projectedVariance => budget - (actual + etc);

  /// Share of budget used, 0–1; null when there is no budget to compare to.
  double? get percentUsed => budget > 0 ? actual / budget : null;
}

class CostTransactionModel {
  final String id;
  final DateTime date;
  final String costCode;
  final CostCategory category;
  final CostModule module;
  final String description;
  final double amount;

  const CostTransactionModel({
    required this.id,
    required this.date,
    required this.costCode,
    required this.category,
    required this.module,
    required this.description,
    required this.amount,
  });
}

/// A potential change order (PCO) created from the Change Orders sub-tab.
/// Named `...Record` to stay clear of the Overview tab's `ChangeOrderModel`.
class ChangeOrderRecord {
  final String id;
  final String number;
  final double amount;
  final String? costCode;
  final String? workTypeCategory;
  final String? workType;
  final String description;
  final ChangeOrderRecordStatus status;
  final DateTime createdAt;

  const ChangeOrderRecord({
    required this.id,
    required this.number,
    required this.amount,
    this.costCode,
    this.workTypeCategory,
    this.workType,
    this.description = '',
    this.status = ChangeOrderRecordStatus.pending,
    required this.createdAt,
  });
}

class ReceiptRecord {
  final String id;
  final String vendor;
  final double amount;
  final String category;
  final String? costCode;
  final DateTime date;
  final String fileName;

  const ReceiptRecord({
    required this.id,
    required this.vendor,
    required this.amount,
    this.category = '',
    this.costCode,
    required this.date,
    required this.fileName,
  });
}

/// A Schedule of Values pay application.
class SovRecord {
  final String id;
  final String number;
  final String title;
  final String? description;
  final DateTime createdAt;

  const SovRecord({
    required this.id,
    required this.number,
    required this.title,
    this.description,
    required this.createdAt,
  });
}

class PaymentRecord {
  final String id;
  final String sovId;
  final double amount;
  final DateTime date;
  final PaymentMethod method;
  final String? reference;
  final String? notes;

  const PaymentRecord({
    required this.id,
    required this.sovId,
    required this.amount,
    required this.date,
    required this.method,
    this.reference,
    this.notes,
  });
}

class LienWaiverRecord {
  final String id;
  final String projectLabel;
  final String? sovId;
  final LienWaiverType type;
  final String recipient;
  final String? company;
  final DateTime? throughDate;
  final double amount;
  final String? notes;

  const LienWaiverRecord({
    required this.id,
    required this.projectLabel,
    this.sovId,
    required this.type,
    required this.recipient,
    this.company,
    this.throughDate,
    this.amount = 0,
    this.notes,
  });
}
