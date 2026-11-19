import 'package:flutter/material.dart';

import '../../../../widgets/custom_toggle_switch.dart';


/// Sits above the existing stat cards on the Bid Inbox (`BidsView`).
/// Two independent `CustomToggle`s:
///   - "Team" / "Company" — whose bids are being viewed (plain style)
///   - "Draft" / "Active" — status filter (colored/orange style)
///
/// This widget is stateless and purely presentational; wire
/// `scopeIndex` / `statusIndex` as two `RxInt`s on the existing
/// `BidsLogic` and pass them in from `BidsView` — see
/// NOTES_CREATE_BID.md for the exact hookup, since `BidsLogic`
/// wasn't available to edit directly here.
class BidsListToggleRow extends StatelessWidget {
  final int scopeIndex;
  final ValueChanged<int> onScopeChanged;
  final int statusIndex;
  final ValueChanged<int> onStatusChanged;

  const BidsListToggleRow({
    super.key,
    required this.scopeIndex,
    required this.onScopeChanged,
    required this.statusIndex,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomToggle(
          options: const ['Team', 'Company'],
          selectedIndex: scopeIndex,
          onChanged: onScopeChanged,
        ),
        const SizedBox(height: 10),
        CustomToggle(
          options: const ['Draft', 'Active'],
          selectedIndex: statusIndex,
          onChanged: onStatusChanged,
          isColored: true,
        ),
      ],
    );
  }
}
