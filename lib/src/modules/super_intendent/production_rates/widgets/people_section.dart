import 'package:flutter/material.dart';
import '../logic.dart';
import '../models/company_settings_models.dart';
import 'cs_basics.dart';
import 'cs_palette.dart';
import 'new_leave_type_sheet.dart';

/// People → Leave Types.
class PeopleSection extends StatelessWidget {
  final CompanySettingsLogic logic;

  const PeopleSection({super.key, required this.logic});

  Future<void> _openAddSheet(BuildContext context) async {
    final created = await showModalBottomSheet<LeaveTypeModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewLeaveTypeSheet(existingNames: logic.leaveTypeNames),
    );
    if (created != null) await logic.addLeaveType(created);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'People',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: CsPalette.text,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            CsPill(
              label: 'Leave Types',
              icon: Icons.beach_access_outlined,
              selected: true,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leave Types',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: CsPalette.text,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Configure leave types and annual allowances for your organization',
                    style: TextStyle(fontSize: 10.5, color: CsPalette.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            CsSmallButton(
              label: '+ Add Leave Type',
              onPressed: () => _openAddSheet(context),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (logic.leaveTypes.isEmpty)
          const CsEmptyCard(
            icon: Icons.storage_outlined,
            title: 'No leave types configured yet',
            message: 'Add your first leave type above',
          )
        else
          for (final l in logic.leaveTypes) ...[
            _LeaveTypeTile(
              item: l,
              onToggle: (v) => logic.toggleLeaveActive(l.id, v),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

class _LeaveTypeTile extends StatelessWidget {
  final LeaveTypeModel item;
  final ValueChanged<bool> onToggle;

  const _LeaveTypeTile({required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
      decoration: BoxDecoration(
        color: CsPalette.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CsPalette.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: CsPalette.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.annualAllowanceDays} days per year',
                  style: const TextStyle(fontSize: 10.5, color: CsPalette.muted),
                ),
              ],
            ),
          ),
          Switch(
            value: item.active,
            onChanged: onToggle,
            activeColor: Colors.white,
            activeTrackColor: CsPalette.orange,
          ),
        ],
      ),
    );
  }
}
