import 'package:flutter/material.dart';

import '../models/company_settings_models.dart';
import 'cs_basics.dart';
import 'cs_palette.dart';

/// "New Leave Type" bottom sheet. Pops with the created [LeaveTypeModel].
class NewLeaveTypeSheet extends StatefulWidget {
  /// Lower-cased names already in use, for duplicate detection.
  final List<String> existingNames;

  const NewLeaveTypeSheet({super.key, required this.existingNames});

  @override
  State<NewLeaveTypeSheet> createState() => _NewLeaveTypeSheetState();
}

class _NewLeaveTypeSheetState extends State<NewLeaveTypeSheet> {
  final _name = TextEditingController();
  final _allowance = TextEditingController(text: '0');
  bool _active = true;
  String? _nameError;
  String? _allowanceError;

  @override
  void dispose() {
    _name.dispose();
    _allowance.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    final days = int.tryParse(_allowance.text.trim());

    String? nameError;
    String? allowanceError;
    if (name.isEmpty) {
      nameError = 'Name is required';
    } else if (widget.existingNames.contains(name.toLowerCase())) {
      nameError = 'A leave type with this name already exists';
    }
    if (days == null || days < 0) {
      allowanceError = 'Enter a valid number of days';
    }

    if (nameError != null || allowanceError != null) {
      setState(() {
        _nameError = nameError;
        _allowanceError = allowanceError;
      });
      return;
    }

    Navigator.of(context).pop(
      LeaveTypeModel(
        id: 'lt_${DateTime.now().microsecondsSinceEpoch}',
        name: name,
        annualAllowanceDays: days!,
        active: _active,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CsSheetScaffold(
      title: 'New Leave Type',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CsField(
            label: 'Name',
            controller: _name,
            hint: 'e.g. Vacation, Sick, Personal',
            errorText: _nameError,
          ),
          const SizedBox(height: 14),
          CsField(
            label: 'Annual Allowance (days)',
            controller: _allowance,
            keyboardType: TextInputType.number,
            errorText: _allowanceError,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Active',
                  style: TextStyle(fontSize: 11, color: CsPalette.text),
                ),
              ),
              Switch(
                value: _active,
                onChanged: (v) => setState(() => _active = v),
                activeColor: Colors.white,
                activeTrackColor: CsPalette.orange,
              ),
            ],
          ),
          const SizedBox(height: 10),
          CsSheetActions(primaryLabel: 'Create', onPrimary: _submit),
        ],
      ),
    );
  }
}
