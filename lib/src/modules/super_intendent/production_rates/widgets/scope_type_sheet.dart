import 'package:flutter/material.dart';

import '../models/company_settings_models.dart';
import 'cs_basics.dart';
import 'cs_dropdown_field.dart';

/// New / Edit Scope Type bottom sheet. Pops with the created or updated
/// [ScopeTypeModel]. No reference screen exists for it, so it reuses the
/// New Leave Type sheet chrome (own design, flagged in NOTES).
class ScopeTypeSheet extends StatefulWidget {
  /// Null when creating.
  final ScopeTypeModel? initial;

  /// Lower-cased names already in use (excluding [initial]'s own name).
  final List<String> existingNames;

  const ScopeTypeSheet({
    super.key,
    this.initial,
    required this.existingNames,
  });

  @override
  State<ScopeTypeSheet> createState() => _ScopeTypeSheetState();
}

class _ScopeTypeSheetState extends State<ScopeTypeSheet> {
  late final TextEditingController _name;
  String? _unit;
  String? _nameError;
  String? _unitError;

  bool get _editing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial?.name ?? '');
    _unit = widget.initial?.unit;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    String? nameError;
    if (name.isEmpty) {
      nameError = 'Name is required';
    } else if (widget.existingNames.contains(name.toLowerCase())) {
      nameError = 'A scope with this name already exists';
    }
    final unitError = _unit == null ? 'Select a unit' : null;

    if (nameError != null || unitError != null) {
      setState(() {
        _nameError = nameError;
        _unitError = unitError;
      });
      return;
    }

    Navigator.of(context).pop(
      ScopeTypeModel(
        id: widget.initial?.id ?? 'sc_${DateTime.now().microsecondsSinceEpoch}',
        name: name,
        unit: _unit!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CsSheetScaffold(
      title: _editing ? 'Edit Scope Type' : 'New Scope Type',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CsField(
            label: 'Name',
            controller: _name,
            hint: 'e.g. Excavation, Grout Fill',
            errorText: _nameError,
          ),
          const SizedBox(height: 14),
          CsDropdownField(
            label: 'Unit of Measure',
            value: _unit,
            items: kScopeUnits,
            hint: 'Select unit',
            errorText: _unitError,
            onChanged: (v) => setState(() {
              _unit = v;
              _unitError = null;
            }),
          ),
          const SizedBox(height: 18),
          CsSheetActions(
            primaryLabel: _editing ? 'Save' : 'Create',
            onPrimary: _submit,
          ),
        ],
      ),
    );
  }
}
