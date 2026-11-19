import 'package:flutter/material.dart';
import '../../../../widgets/pill_tab_group.dart';
import '../models/bid_status.dart';

class BidFilterTabs extends StatelessWidget {
  final BidFilter selected;
  final int Function(BidFilter filter) countFor;
  final ValueChanged<BidFilter> onChanged;

  const BidFilterTabs({
    super.key,
    required this.selected,
    required this.countFor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PillTabGroup<BidFilter>(
      style: PillTabStyle.filled,
      selectedValue: selected,
      onChanged: onChanged,
      items: [
        for (final filter in BidFilter.values)
          PillTabItem(
            value: filter,
            // Only the "All" tab carries a count in the reference design
            // — Pending/Declined/Responded counts already live in the
            // stat cards above, so repeating them here would be noisy.
            label: filter == BidFilter.all
                ? '${filter.label} (${countFor(filter)})'
                : filter.label,
          ),
      ],
    );
  }
}
