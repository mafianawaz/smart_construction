import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_icons.dart';

import '../../../../utils/app_color.dart';

/// Status of a bid invitation from the field worker/vendor's perspective.
enum BidStatus { pending, declined, responded }

extension BidStatusX on BidStatus {
  String get label {
    switch (this) {
      case BidStatus.pending:
        return 'Pending';
      case BidStatus.declined:
        return 'Declined';
      case BidStatus.responded:
        return 'Responded';
    }
  }

  /// Color used for the status badge and the stat card icon.
  /// NOTE: AppColors.success is assumed present alongside the existing
  /// AppColors.warning / AppColors.error fields — see NOTES_BIDS.md.
  Color get color {
    switch (this) {
      case BidStatus.pending:
        return AppColors.primaryOrangeDark;
      case BidStatus.declined:
        return AppColors.redColor;
      case BidStatus.responded:
        return AppColors.statusChip;
    }
  }

  String get icon {
    switch (this) {
      case BidStatus.pending:
        return AppIcons.progress;
      case BidStatus.declined:
        return AppIcons.complete;
      case BidStatus.responded:
        return AppIcons.complete;
    }
  }
}

/// Filter applied to the bid inbox list. Mirrors [BidStatus] plus an
/// "all" option, kept separate so the filter tabs don't have to special
/// case a null status.
enum BidFilter { all, pending, declined, responded }

extension BidFilterX on BidFilter {
  String get label {
    switch (this) {
      case BidFilter.all:
        return 'All';
      case BidFilter.pending:
        return 'Pending';
      case BidFilter.declined:
        return 'Declined';
      case BidFilter.responded:
        return 'Responded';
    }
  }

  bool matches(BidStatus status) {
    switch (this) {
      case BidFilter.all:
        return true;
      case BidFilter.pending:
        return status == BidStatus.pending;
      case BidFilter.declined:
        return status == BidStatus.declined;
      case BidFilter.responded:
        return status == BidStatus.responded;
    }
  }
}
