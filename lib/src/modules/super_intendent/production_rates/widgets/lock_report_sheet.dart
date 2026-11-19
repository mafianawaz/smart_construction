import 'package:flutter/material.dart';

import '../models/company_settings_models.dart';
import 'cs_basics.dart';
import 'cs_dropdown_field.dart';
import 'cs_palette.dart';

/// "August 6th, 2026" style date used by the Lock Daily Report sheet.
String csOrdinalDate(DateTime d) {
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  String suffix;
  if (d.day >= 11 && d.day <= 13) {
    suffix = 'th';
  } else {
    switch (d.day % 10) {
      case 1:
        suffix = 'st';
        break;
      case 2:
        suffix = 'nd';
        break;
      case 3:
        suffix = 'rd';
        break;
      default:
        suffix = 'th';
    }
  }
  return '${months[d.month - 1]} ${d.day}$suffix, ${d.year}';
}

/// "Lock Daily Report" bottom sheet. Pops with the created [ReportLockModel].
class LockReportSheet extends StatefulWidget {
  final List<String> projectNames;

  /// Returns true when the project already has a lock for that day.
  final bool Function(String project, DateTime day) isLocked;

  const LockReportSheet({
    super.key,
    required this.projectNames,
    required this.isLocked,
  });

  @override
  State<LockReportSheet> createState() => _LockReportSheetState();
}

class _LockReportSheetState extends State<LockReportSheet> {
  final _reason = TextEditingController();
  String? _project;
  DateTime _date = DateTime.now();
  String? _projectError;
  String? _reasonError;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
                primary: CsPalette.orange,
                onPrimary: Colors.white,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _submit() {
    final reason = _reason.text.trim();
    String? projectError;
    if (_project == null) {
      projectError = 'Select a project';
    } else if (widget.isLocked(_project!, _date)) {
      projectError = 'This report is already locked';
    }
    final reasonError = reason.isEmpty ? 'Lock reason is required' : null;

    if (projectError != null || reasonError != null) {
      setState(() {
        _projectError = projectError;
        _reasonError = reasonError;
      });
      return;
    }

    Navigator.of(context).pop(
      ReportLockModel(
        id: 'rl_${DateTime.now().microsecondsSinceEpoch}',
        projectName: _project!,
        reason: reason,
        status: ReportLockStatus.locked,
        date: _date,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CsSheetScaffold(
      title: 'Lock Daily Report',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lock a daily report to prevent further modifications. This '
            'preserves the report as legal evidence.',
            style: TextStyle(fontSize: 10.5, color: CsPalette.muted, height: 1.4),
          ),
          const SizedBox(height: 16),
          CsDropdownField(
            label: 'Project',
            value: _project,
            items: widget.projectNames,
            hint: 'Select project',
            errorText: _projectError,
            onChanged: (v) => setState(() {
              _project = v;
              _projectError = null;
            }),
          ),
          const SizedBox(height: 14),
          const Text(
            'Report Date',
            style: TextStyle(fontSize: 11, color: CsPalette.text),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
              decoration: BoxDecoration(
                color: CsPalette.fieldFill,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: CsPalette.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 15,
                    color: CsPalette.muted,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    csOrdinalDate(_date),
                    style: const TextStyle(fontSize: 12, color: CsPalette.text),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          CsField(
            label: 'Lock Reason',
            controller: _reason,
            hint: 'Why is this report being locked?',
            errorText: _reasonError,
            maxLines: 4,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CsPalette.text,
                    side: const BorderSide(color: CsPalette.border),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 12.5)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.lock_outline, size: 16),
                  label: const Text(
                    'Lock Report',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CsPalette.orange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
