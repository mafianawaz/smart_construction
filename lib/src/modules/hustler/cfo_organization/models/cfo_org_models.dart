import 'package:flutter/material.dart';

import 'cfo_org_format.dart';

/// Role choices on the Invite Executive form.
enum CfoExecRole {
  coo('COO - Chief Operating Officer'),
  cfo('CFO - Chief Financial Officer'),
  other('Other Executive');

  final String label;
  const CfoExecRole(this.label);
}

enum CfoProjectStatus {
  active('ACTIVE'),
  closed('CLOSED'),
  planning('PLANNING');

  final String label;
  const CfoProjectStatus(this.label);
}

/// Tabs on the Organization detail screen.
enum CfoDetailTab {
  projects('Projects'),
  bids('Bids'),
  changeOrder('Change Order'),
  team('Team'),
  cfo('CFO');

  final String label;
  const CfoDetailTab(this.label);
}

/// "Portfolio Summary" grid + Bid Win Rate banner on the CFO overview.
class CfoPortfolioSummary {
  final int organizations;
  final int activeProjects;
  final int openBills;
  final int pendingChangeOrders;
  final int pendingTasks;
  final String bidPipelineLabel;
  final int bidWins;
  final int bidLosses;

  const CfoPortfolioSummary({
    required this.organizations,
    required this.activeProjects,
    required this.openBills,
    required this.pendingChangeOrders,
    required this.pendingTasks,
    required this.bidPipelineLabel,
    required this.bidWins,
    required this.bidLosses,
  });

  int get bidsDecided => bidWins + bidLosses;

  /// Whole-number win rate; 0 when nothing has been decided yet.
  int get winRatePercent =>
      bidsDecided == 0 ? 0 : ((bidWins / bidsDecided) * 100).round();
}

class CfoAccessSummary {
  final String organizationName;
  final String effectiveRole;
  final int permissionCount;

  const CfoAccessSummary({
    required this.organizationName,
    required this.effectiveRole,
    required this.permissionCount,
  });
}

class CfoInsights {
  final String message;
  final int sortedOrgs;
  final int flagged;
  final int trending;

  const CfoInsights({
    required this.message,
    required this.sortedOrgs,
    required this.flagged,
    required this.trending,
  });
}

/// A card in the horizontally scrolling organization strip.
class CfoOrgCardModel {
  final String id;
  final String name;
  final String type;
  final bool isActive;

  const CfoOrgCardModel({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
  });

  CfoOrgCardModel copyWith({bool? isActive}) => CfoOrgCardModel(
        id: id,
        name: name,
        type: type,
        isActive: isActive ?? this.isActive,
      );
}

class CfoExecutive {
  final String email;
  final CfoExecRole role;

  const CfoExecutive({required this.email, required this.role});
}

class CfoChartSlice {
  final String label;
  final int value;
  final Color color;

  const CfoChartSlice({
    required this.label,
    required this.value,
    required this.color,
  });
}

class CfoBarDatum {
  final String label;
  final double value;
  final Color color;

  const CfoBarDatum({
    required this.label,
    required this.value,
    required this.color,
  });
}

class CfoOrgProject {
  final String name;
  final String client;
  final String code;
  final CfoProjectStatus status;
  final DateTime date;

  const CfoOrgProject({
    required this.name,
    required this.client,
    required this.code,
    required this.status,
    required this.date,
  });
}

/// Everything the Organization detail screen renders for one organization.
class CfoOrgDetail {
  final String name;
  final int activeProjects;
  final int planningProjects;
  final int openBids;
  final int bidsWonThisPeriod;
  final int pendingChangeOrders;
  final int teamSize;
  final String outstandingArLabel;
  final int overdueInvoices;
  final String collectedYtdLabel;
  final int collectionRatePercent;
  final List<CfoChartSlice> projectsByStatus;
  final int teamActive;
  final int teamInactive;
  final List<CfoBarDatum> changeOrdersByStatus;
  final List<CfoBarDatum> arAging;
  final List<CfoChartSlice> bidsByStatus;
  final List<CfoOrgProject> projects;
  final List<CfoOrgBid> bids;
  final List<CfoOrgChangeOrder> changeOrders;
  final List<CfoOrgMember> members;
  final List<CfoOrgReceivable> receivables;
  final String overdueArLabel;
  final String collectedSinceLabel;

  const CfoOrgDetail({
    required this.name,
    required this.activeProjects,
    required this.planningProjects,
    required this.openBids,
    required this.bidsWonThisPeriod,
    required this.pendingChangeOrders,
    required this.teamSize,
    required this.outstandingArLabel,
    required this.overdueInvoices,
    required this.collectedYtdLabel,
    required this.collectionRatePercent,
    required this.projectsByStatus,
    required this.teamActive,
    required this.teamInactive,
    required this.changeOrdersByStatus,
    required this.arAging,
    required this.bidsByStatus,
    required this.projects,
    required this.bids,
    required this.changeOrders,
    required this.members,
    required this.receivables,
    required this.overdueArLabel,
    required this.collectedSinceLabel,
  });
}

// ---------------------------------------------------------------------------
// Bids tab
// ---------------------------------------------------------------------------

enum CfoBidStatus {
  open('OPEN'),
  draft('DRAFT'),
  awarded('AWARDED'),
  lost('LOST'),
  cancelled('CANCELLED');

  final String label;
  const CfoBidStatus(this.label);
}

class CfoOrgBid {
  final String name;
  final String client;
  final String code;
  final DateTime dueDate;

  /// Null while the bid has no priced amount (drafts, cancelled bids).
  final double? amount;
  final CfoBidStatus status;

  const CfoOrgBid({
    required this.name,
    required this.client,
    required this.code,
    required this.dueDate,
    required this.status,
    this.amount,
  });

  String get dueLabel => 'Due ${cfoShortDate(dueDate)}';
  String? get amountLabel =>
      amount == null ? null : cfoMoney(amount!, decimals: 2);
}

// ---------------------------------------------------------------------------
// Change Order tab
// ---------------------------------------------------------------------------

enum CfoChangeOrderStatus {
  draft('DRAFT'),
  pco('PCO'),
  submitted('SUBMITTED'),
  approved('APPROVED'),
  rejected('REJECTED');

  final String label;
  const CfoChangeOrderStatus(this.label);
}

class CfoOrgChangeOrder {
  final String code;
  final double amount;
  final CfoChangeOrderStatus status;
  final DateTime createdAt;

  const CfoOrgChangeOrder({
    required this.code,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  String get amountLabel => cfoMoney(amount);

  /// "Created 12 days ago" — relative to [now] (injectable for tests).
  String createdLabel([DateTime? now]) {
    final days = cfoDaysBetween(createdAt, now ?? DateTime.now());
    if (days <= 0) return 'Created today';
    if (days == 1) return 'Created 1 day ago';
    return 'Created $days days ago';
  }
}

// ---------------------------------------------------------------------------
// Team tab
// ---------------------------------------------------------------------------

enum CfoTeamRole {
  superintendent('SUPERINTENDENT'),
  estimator('ESTIMATOR'),
  vendor('VENDOR'),
  admin('ADMIN'),
  hustler('HUSTLER');

  final String label;
  const CfoTeamRole(this.label);
}

class CfoOrgMember {
  final String name;
  final String email;
  final CfoTeamRole role;
  final bool isActive;

  const CfoOrgMember({
    required this.name,
    required this.email,
    required this.role,
    this.isActive = true,
  });
}

// ---------------------------------------------------------------------------
// CFO tab (receivables)
// ---------------------------------------------------------------------------

class CfoOrgReceivable {
  final String title;
  final String reference;
  final double total;
  final double outstanding;
  final DateTime dueDate;

  const CfoOrgReceivable({
    required this.title,
    required this.reference,
    required this.total,
    required this.outstanding,
    required this.dueDate,
  });

  /// Whole days past [dueDate]; 0 when not yet due or nothing outstanding.
  int daysOverdue([DateTime? now]) {
    if (outstanding <= 0) return 0;
    final days = cfoDaysBetween(dueDate, now ?? DateTime.now());
    return days > 0 ? days : 0;
  }

  bool isOverdue([DateTime? now]) => daysOverdue(now) > 0;

  String get amountsLabel => '${cfoMoney(total)} / ${cfoMoney(outstanding)}';
}

// ---------------------------------------------------------------------------
// Add Organization
// ---------------------------------------------------------------------------

/// A pending invitation sent to another organization's admin.
class CfoOrgInvite {
  final String adminEmail;
  final String? message;

  const CfoOrgInvite({required this.adminEmail, this.message});
}
