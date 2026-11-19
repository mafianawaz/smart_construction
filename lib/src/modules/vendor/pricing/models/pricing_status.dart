import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';

/// Approval state of a submitted pricing item. Only `approved` (green) and
/// `pending` (orange) appear in the reference screens; `rejected` is added
/// for a complete review workflow and flagged in NOTES_PRICING.md.
enum PricingStatus { pending, approved, rejected }

extension PricingStatusX on PricingStatus {
  String get label {
    switch (this) {
      case PricingStatus.pending:
        return 'Pending';
      case PricingStatus.approved:
        return 'Approved';
      case PricingStatus.rejected:
        return 'Rejected';
    }
  }

  /// approved/rejected reuse AppColors.success (still unconfirmed, see
  /// NOTES_PRICING.md) and the confirmed AppColors.redColor; pending uses
  /// the confirmed AppColors.primaryOrange.
  Color get color {
    switch (this) {
      case PricingStatus.pending:
        return AppColors.primaryOrange;
      case PricingStatus.approved:
        return AppColors.statusChip;
      case PricingStatus.rejected:
        return AppColors.redColor;
    }
  }

  /// Only a pending item can still be edited — an approved/rejected item's
  /// card hides the inline edit affordance (confirmed against the
  /// reference screens: the approved card has no pencil icon, the pending
  /// one does).
  bool get isEditable => this == PricingStatus.pending;
}
