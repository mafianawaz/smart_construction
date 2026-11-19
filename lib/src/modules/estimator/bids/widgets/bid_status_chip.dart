import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import '../models/bid_model.dart';
import 'chip_widget.dart';

/// Colour per [BidStatus] — one place so cards, inbox and details agree.
class BidStatusStyle {
  BidStatusStyle._();

  static Color color(BidStatus s) {
    switch (s) {
      case BidStatus.awarded:
        return Colors.green;
      case BidStatus.draft:
        return AppColors.primaryOrange;
      case BidStatus.active:
        return Colors.blue;
      case BidStatus.expired:
        return AppColors.redColor;
    }
  }
}

/// Uppercase text chip (`PillChipWidget` with `filled: true`, i.e. no
/// icon — the Figma status chips have none).
class BidStatusChip extends StatelessWidget {
  final BidStatus status;
  const BidStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return PillChipWidget(
      label: status.label,
      color: BidStatusStyle.color(status),
      filled: true,
    );
  }
}
