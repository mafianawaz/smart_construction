import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import '../models/crm_models.dart';
import '../widgets/crm_form_fields.dart';
import '../widgets/crm_palette.dart';

/// Add / Edit organization form. Pushed as its own route and returns the
/// finished [OrganizationModel] via `Get.back(result: ...)`; the caller hands
/// it to `CrmLogic.saveOrganization`.
///
/// The reference only shows Edit/Delete entry points, not this form, so the
/// layout is this module's own design (see NOTES_CRM.md).
class OrganizationFormView extends StatefulWidget {
  /// For a new organization pass a blank model with a fresh id and set [isNew].
  final OrganizationModel initial;
  final bool isNew;
  final List<String> owners;

  const OrganizationFormView({
    super.key,
    required this.initial,
    required this.isNew,
    required this.owners,
  });

  @override
  State<OrganizationFormView> createState() => _OrganizationFormViewState();
}

class _OrganizationFormViewState extends State<OrganizationFormView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _ownerRole;
  late final TextEditingController _category;
  late final TextEditingController _street;
  late final TextEditingController _city;
  late final TextEditingController _state;
  late final TextEditingController _zip;
  late final TextEditingController _specialties;

  late OrgType _type;
  late OrgStatus _status;
  String? _owner;

  @override
  void initState() {
    super.initState();
    final o = widget.initial;
    _name = TextEditingController(text: o.name);
    _ownerRole = TextEditingController(text: o.ownerRole ?? '');
    _category = TextEditingController(text: o.category ?? '');
    _street = TextEditingController(text: o.street);
    _city = TextEditingController(text: o.city);
    _state = TextEditingController(text: o.state);
    _zip = TextEditingController(text: o.zip);
    _specialties = TextEditingController(text: o.specialties.join(', '));
    _type = o.type;
    _status = o.status;
    _owner = o.ownerName;
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _ownerRole,
      _category,
      _street,
      _city,
      _state,
      _zip,
      _specialties,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Dropdown values must be unique and contain the current selection.
  List<String> get _ownerOptions {
    final options = <String>[...widget.owners];
    final current = _owner;
    if (current != null && !options.contains(current)) options.add(current);
    return options;
  }

  String? _nullIfBlank(String text) {
    final trimmed = text.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final specialties = _specialties.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final result = widget.initial.copyWith(
      name: _name.text.trim(),
      type: _type,
      status: _status,
      street: _street.text.trim(),
      city: _city.text.trim(),
      state: _state.text.trim(),
      zip: _zip.text.trim(),
      ownerName: _owner,
      ownerRole: _owner == null ? null : _nullIfBlank(_ownerRole.text),
      category: _nullIfBlank(_category.text),
      specialties: specialties,
    );
    Get.back<OrganizationModel>(result: result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppPrimaryBar(
        title: widget.isNew ? 'Add Organization' : 'Edit Organization',
        subtitle: 'Contractor, subcontractor, supplier or vendor details.',
        showBackButton: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          children: [
            CrmTextField(
              label: 'Organization name',
              controller: _name,
              hint: 'e.g. Buckeye Concrete',
              isRequired: true,
            ),
            const SizedBox(height: 14),
            CrmDropdownField<OrgType>(
              label: 'Type',
              value: _type,
              items: OrgType.values,
              labelOf: (t) => t.label,
              onChanged: (v) {
                if (v != null) setState(() => _type = v);
              },
            ),
            const SizedBox(height: 14),
            CrmDropdownField<OrgStatus>(
              label: 'Status',
              value: _status,
              items: OrgStatus.values,
              labelOf: (s) => s.label,
              onChanged: (v) {
                if (v != null) setState(() => _status = v);
              },
            ),
            const SizedBox(height: 14),
            CrmDropdownField<String>(
              label: 'Owner',
              value: _owner,
              items: _ownerOptions,
              labelOf: (s) => s,
              nullLabel: 'Unassigned',
              onChanged: (v) => setState(() => _owner = v),
            ),
            if (_owner != null) ...[
              const SizedBox(height: 14),
              CrmTextField(
                label: 'Owner role (optional)',
                controller: _ownerRole,
                hint: 'e.g. Cost Estimator',
              ),
            ],
            const SizedBox(height: 14),
            CrmTextField(
              label: 'Category (optional)',
              controller: _category,
              hint: 'e.g. cement',
            ),
            const SizedBox(height: 14),
            CrmTextField(
              label: 'Specialties (comma separated)',
              controller: _specialties,
              hint: 'e.g. Concrete-Supplier, Rebar',
            ),
            const SizedBox(height: 14),
            CrmTextField(
              label: 'Street address',
              controller: _street,
              hint: '123 Main St',
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: CrmTextField(label: 'City', controller: _city),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: CrmTextField(label: 'State', controller: _state),
                ),
              ],
            ),
            const SizedBox(height: 14),
            CrmTextField(
              label: 'ZIP',
              controller: _zip,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            CrmPrimaryButton(
              text: widget.isNew ? 'Add Organization' : 'Save Changes',
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
