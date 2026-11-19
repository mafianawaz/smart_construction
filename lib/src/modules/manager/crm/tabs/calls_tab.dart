import 'package:flutter/material.dart';

import '../logic.dart';
import '../models/crm_activity_models.dart';
import '../widgets/call_log_card.dart';
import '../widgets/crm_blank_state.dart';
import '../widgets/crm_controls.dart';
import '../widgets/crm_date_field.dart';
import '../widgets/crm_search_field.dart';
import '../widgets/crm_section_header.dart';

/// Calls tab (reference screen 2): "Logged Calls" header, search, three
/// filter pills, a from/to date row and the call log, newest first.
///
/// The reference has no "log a call" control; `CrmLogic.logCall` is the seam
/// for wherever calls originate.
class CallsTab extends StatelessWidget {
  final CrmLogic logic;

  const CallsTab({super.key, required this.logic});

  @override
  Widget build(BuildContext context) {
    final calls = logic.filteredCalls;

    return ListView(
      children: [
        CrmSectionHeader(
          icon: Icons.phone_outlined,
          title: 'Logged Calls',
          count: calls.length,
        ),
        const SizedBox(height: 12),
        CrmSearchField(
          hint: 'Search notes, numbers, owner...',
          initialValue: logic.callQuery,
          onChanged: logic.setCallQuery,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CrmDropdownPill<CallOutcome>(
                allLabel: 'All outcomes',
                options: CallOutcome.values,
                labelOf: (o) => o.label,
                value: logic.callOutcomeFilter,
                onChanged: logic.setCallOutcomeFilter,
                compact: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CrmDropdownPill<CallDirection>(
                allLabel: 'All directions',
                options: CallDirection.values,
                labelOf: (d) => d.menuLabel,
                value: logic.callDirectionFilter,
                onChanged: logic.setCallDirectionFilter,
                compact: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CrmDropdownPill<String>(
                allLabel: 'All owners',
                options: logic.callOwners,
                labelOf: (o) => o,
                value: logic.callOwnerFilter,
                onChanged: logic.setCallOwnerFilter,
                compact: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CrmDateField(
                compact: true,
                value: logic.callFrom,
                lastDate: logic.callTo,
                pickerHelp: 'From date',
                onChanged: logic.setCallFrom,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CrmDateField(
                compact: true,
                value: logic.callTo,
                firstDate: logic.callFrom,
                pickerHelp: 'To date',
                onChanged: logic.setCallTo,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (calls.isEmpty)
          logic.calls.isEmpty
              ? const CrmBlankState(
                  icon: Icons.phone_outlined,
                  title: 'No calls logged',
                  message: 'Calls you log will appear here.',
                )
              : CrmBlankState(
                  icon: Icons.search_off,
                  title: 'No calls found',
                  message: 'Try a different search or clear your filters.',
                  buttonLabel: logic.hasCallFilters ? 'Clear filters' : null,
                  onButton: logic.hasCallFilters ? logic.clearCallFilters : null,
                )
        else
          for (final call in calls) CallLogCard(key: ValueKey(call.id), call: call),
      ],
    );
  }
}
