import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import '../models/crm_models.dart';
import '../widgets/crm_form_fields.dart';


/// Add Opportunity form. Pushed as its own route and returns the new
/// [OpportunityModel] via `Get.back(result: ...)`; the caller hands it to
/// `CrmLogic.addOpportunity`.
///
/// The reference only shows the "+ Add Opportunity" button, so this layout is
/// this module's own design (see NOTES_CRM.md).
class OpportunityFormView extends StatefulWidget {
  final String id;
  final List<String> organizationNames;
  final List<String> owners;

  const OpportunityFormView({
    super.key,
    required this.id,
    required this.organizationNames,
    required this.owners,
  });

  @override
  State<OpportunityFormView> createState() => _OpportunityFormViewState();
}

class _OpportunityFormViewState extends State<OpportunityFormView> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _value = TextEditingController();

  String? _organization;
  OpportunityStage _stage = OpportunityStage.lead;
  String? _assignee;

  @override
  void dispose() {
    _title.dispose();
    _value.dispose();
    super.dispose();
  }

  String? _validateValue(String? text) {
    final raw = (text ?? '').trim();
    if (raw.isEmpty) return 'Value is required';
    final parsed = double.tryParse(raw.replaceAll(',', ''));
    if (parsed == null || parsed < 0) return 'Enter a valid amount';
    return null;
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final value = double.parse(_value.text.trim().replaceAll(',', ''));
    Get.back<OpportunityModel>(
      result: OpportunityModel(
        id: widget.id,
        title: _title.text.trim(),
        organizationName: _organization ?? '',
        stage: _stage,
        value: value,
        assignee: _assignee,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Add Opportunity',
        subtitle: 'Track a potential job through your sales pipeline.',
        showBackButton: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
          children: [
            CrmTextField(
              label: 'Opportunity title',
              controller: _title,
              hint: 'e.g. Riverside Warehouse Slab',
              isRequired: true,
            ),
            const SizedBox(height: 14),
            CrmDropdownField<String>(
              label: 'Organization',
              value: _organization,
              items: widget.organizationNames,
              labelOf: (n) => n,
              hint: 'Select organization',
              isRequired: true,
              onChanged: (v) => setState(() => _organization = v),
            ),
            const SizedBox(height: 14),
            CrmDropdownField<OpportunityStage>(
              label: 'Stage',
              value: _stage,
              items: OpportunityStage.values,
              labelOf: (s) => s.label,
              onChanged: (v) {
                if (v != null) setState(() => _stage = v);
              },
            ),
            const SizedBox(height: 14),
            CrmTextField(
              label: 'Estimated value (\$)',
              controller: _value,
              hint: '0',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _validateValue,
            ),
            const SizedBox(height: 14),
            CrmDropdownField<String>(
              label: 'Assignee',
              value: _assignee,
              items: widget.owners,
              labelOf: (s) => s,
              nullLabel: 'Unassigned',
              onChanged: (v) => setState(() => _assignee = v),
            ),
            const SizedBox(height: 24),
            CrmPrimaryButton(text: 'Add Opportunity', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
