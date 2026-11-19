import 'package:flutter/material.dart';
import '../logic.dart';
import '../models/company_settings_models.dart';
import 'cs_basics.dart';
import 'cs_palette.dart';
import 'distribution_section.dart';
import 'lock_report_sheet.dart';
import 'scope_settings_section.dart';

/// Operations → Report Locks / Scope Settings / Distribution.
class OperationsSection extends StatelessWidget {
  final CompanySettingsLogic logic;

  const OperationsSection({super.key, required this.logic});

  static const _tabIcons = <OperationsTab, IconData>{
    OperationsTab.reportLocks: Icons.lock_outline,
    OperationsTab.scopeSettings: Icons.settings_outlined,
    OperationsTab.distribution: Icons.people_outline,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Operations',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: CsPalette.text,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final t in OperationsTab.values) ...[
                CsPill(
                  label: t.label,
                  icon: _tabIcons[t],
                  subtle: true,
                  selected: logic.operationsTab == t,
                  onTap: () => logic.selectOperationsTab(t),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (logic.operationsTab == OperationsTab.reportLocks)
          _ReportLocks(logic: logic)
        else if (logic.operationsTab == OperationsTab.scopeSettings)
          ScopeSettingsSection(logic: logic)
        else
          DistributionSection(logic: logic),
      ],
    );
  }
}

class _ReportLocks extends StatelessWidget {
  final CompanySettingsLogic logic;

  const _ReportLocks({required this.logic});

  Future<void> _openLockSheet(BuildContext context) async {
    final created = await showModalBottomSheet<ReportLockModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LockReportSheet(
        projectNames: logic.projectNames,
        isLocked: logic.isReportLocked,
      ),
    );
    if (created != null) await logic.addReportLock(created);
  }

  @override
  Widget build(BuildContext context) {
    final locks = logic.filteredLocks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Report Locks',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: CsPalette.text,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Lock daily reports to preserve evidence integrity',
                    style: TextStyle(fontSize: 10.5, color: CsPalette.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            CsSmallButton(
              label: '+ Lock Report',
              onPressed: () => _openLockSheet(context),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: CsStatCard(
                centered: true,
                icon: Icons.lock_open_outlined,
                iconColor: CsPalette.blue,
                label: 'Unlocked',
                value: '${logic.lockCount(ReportLockStatus.unlocked)}',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CsStatCard(
                centered: true,
                icon: Icons.lock_outline,
                iconColor: CsPalette.red,
                label: 'Locked',
                value: '${logic.lockCount(ReportLockStatus.locked)}',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CsStatCard(
                centered: true,
                icon: Icons.radio_button_unchecked,
                iconColor: CsPalette.red,
                label: 'Supervisor',
                value: '${logic.lockCount(ReportLockStatus.supervisor)}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Filter Locks',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: CsPalette.text,
          ),
        ),
        const SizedBox(height: 8),
        CsSearchField(
          hint: 'Search by project or reason...',
          onChanged: logic.setLockSearch,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CsFilterPill(
                expand: true,
                value: logic.lockStatusFilter,
                options: logic.lockStatusOptions,
                onSelected: logic.setLockStatusFilter,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CsFilterPill(
                expand: true,
                value: logic.lockProjectFilter,
                options: logic.lockProjectOptions,
                onSelected: logic.setLockProjectFilter,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (locks.isEmpty)
          const CsEmptyCard(
            icon: Icons.lock_outline,
            title: 'No daily report locks found',
            message: 'Locks will appear here once they are applied to daily reports.',
          )
        else
          for (final l in locks) ...[
            _LockTile(item: l),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

class _LockTile extends StatelessWidget {
  final ReportLockModel item;

  const _LockTile({required this.item});

  Color get _color {
    switch (item.status) {
      case ReportLockStatus.unlocked:
        return CsPalette.blue;
      case ReportLockStatus.locked:
        return CsPalette.red;
      case ReportLockStatus.supervisor:
        return CsPalette.orange;
    }
  }

  String get _date {
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${m[item.date.month - 1]} ${item.date.day}, ${item.date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CsPalette.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CsPalette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.projectName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: CsPalette.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.reason,
                  style: const TextStyle(fontSize: 10.5, color: CsPalette.muted),
                ),
                const SizedBox(height: 6),
                Text(
                  _date,
                  style: const TextStyle(fontSize: 10, color: CsPalette.hint),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: _color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item.status.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: _color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
