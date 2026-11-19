import 'package:flutter/material.dart';

import '../models/report_models.dart';
import 'reports_palette.dart';

/// Bottom sheet opened by the dropdown field; returns the chosen report.
Future<ReportType?> showReportPickerSheet(
  BuildContext context, {
  required List<ReportType> reports,
  required ReportType selected,
}) {
  return showModalBottomSheet<ReportType>(
    context: context,
    backgroundColor: ReportsPalette.card,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => SafeArea(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.7),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          children: [
            const _SheetTitle('Select report'),
            for (final group in ReportGroup.values) ...[
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Text(
                  group.label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: ReportsPalette.textSecondary,
                  ),
                ),
              ),
              for (final r in reports.where((r) => r.group == group))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: Icon(
                    Icons.description,
                    size: 18,
                    color: r.id == selected.id
                        ? ReportsPalette.orange
                        : ReportsPalette.docIcon,
                  ),
                  title: Text(
                    r.label,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight:
                          r.id == selected.id ? FontWeight.w700 : FontWeight.w500,
                      color: r.id == selected.id
                          ? ReportsPalette.orange
                          : ReportsPalette.textDark,
                    ),
                  ),
                  onTap: () => Navigator.of(ctx).pop(r),
                ),
            ],
          ],
        ),
      ),
    ),
  );
}

/// "Data Filters" sheet; returns the new filters (or `const ReportFilters()`
/// when the user taps Clear). Null when dismissed.
Future<ReportFilters?> showReportFiltersSheet(
  BuildContext context, {
  required List<ReportProject> projects,
  required ReportFilters current,
}) {
  return showModalBottomSheet<ReportFilters>(
    context: context,
    backgroundColor: ReportsPalette.card,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _FiltersSheet(projects: projects, current: current),
  );
}

class _FiltersSheet extends StatefulWidget {
  final List<ReportProject> projects;
  final ReportFilters current;

  const _FiltersSheet({required this.projects, required this.current});

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late ReportFilters _draft = widget.current;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SheetTitle('Data filters'),
            const SizedBox(height: 14),
            const _Label('Project'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in widget.projects)
                  _SelectPill(
                    label: p.name,
                    selected: _draft.projectId == p.id,
                    onTap: () => setState(() => _draft = _draft.copyWith(
                          projectId: p.id,
                        )),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            const _Label('Date range'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final r in ReportDateRange.values)
                  _SelectPill(
                    label: r.label,
                    selected: _draft.range == r,
                    onTap: () =>
                        setState(() => _draft = _draft.copyWith(range: r)),
                  ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.of(context).pop(const ReportFilters()),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      foregroundColor: ReportsPalette.textDark,
                      side: const BorderSide(color: ReportsPalette.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(_draft),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      backgroundColor: ReportsPalette.orange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  final String text;
  const _SheetTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: ReportsPalette.textDark,
        ),
      );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: ReportsPalette.textSecondary,
        ),
      );
}

class _SelectPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SelectPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? ReportsPalette.orange.withOpacity(0.10)
              : ReportsPalette.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? ReportsPalette.orange : ReportsPalette.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected ? ReportsPalette.orange : ReportsPalette.textDark,
          ),
        ),
      ),
    );
  }
}
