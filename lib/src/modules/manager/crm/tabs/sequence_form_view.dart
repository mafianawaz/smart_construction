import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import '../models/crm_sequence_models.dart';
import '../widgets/crm_form_fields.dart';
import '../widgets/crm_palette.dart';

/// New Sequence form. Pushed as its own route and returns the finished
/// [SequenceModel] (as a draft) via `Get.back(result: ...)`; the caller hands
/// it to `CrmLogic.addSequence`.
///
/// The reference only shows the "+ New sequence" button, so this layout is
/// this module's own design.
class SequenceFormView extends StatefulWidget {
  final String id;
  final List<String> owners;
  final String defaultOwner;

  const SequenceFormView({
    super.key,
    required this.id,
    required this.owners,
    required this.defaultOwner,
  });

  @override
  State<SequenceFormView> createState() => _SequenceFormViewState();
}

class _StepDraft {
  SequenceStepType type = SequenceStepType.email;
  final title = TextEditingController();
  final delay = TextEditingController(text: '0');

  void dispose() {
    title.dispose();
    delay.dispose();
  }
}

class _SequenceFormViewState extends State<SequenceFormView> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final List<_StepDraft> _steps = [];
  late String _owner = widget.defaultOwner;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    for (final s in _steps) {
      s.dispose();
    }
    super.dispose();
  }

  void _addStep() {
    final step = _StepDraft();
    // Sensible default cadence: first step same day, later ones 2 days apart.
    if (_steps.isNotEmpty) step.delay.text = '2';
    setState(() => _steps.add(step));
  }

  void _removeStep(int index) {
    setState(() => _steps.removeAt(index).dispose());
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Get.back<SequenceModel>(
      result: SequenceModel(
        id: widget.id,
        name: _name.text.trim(),
        description: _description.text.trim(),
        ownerName: _owner,
        steps: [
          for (final s in _steps)
            SequenceStep(
              type: s.type,
              title: s.title.text.trim(),
              delayDays: int.parse(s.delay.text.trim()),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final owners = widget.owners.contains(_owner)
        ? widget.owners
        : [_owner, ...widget.owners];

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'New Sequence',
        subtitle: 'Build a multi-step cadence. It starts as a draft.',
        showBackButton: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              CrmTextField(
                label: 'Sequence name',
                controller: _name,
                hint: 'e.g. Bid follow-up',
                isRequired: true,
              ),
              const SizedBox(height: 14),
              CrmTextField(
                label: 'Description (optional)',
                controller: _description,
                maxLines: 2,
                hint: 'What is this cadence for?',
              ),
              const SizedBox(height: 14),
              CrmDropdownField<String>(
                label: 'Owner',
                value: _owner,
                items: owners,
                labelOf: (o) => o,
                onChanged: (v) {
                  if (v != null) setState(() => _owner = v);
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Steps',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: CrmPalette.text,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addStep,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add step'),
                    style: TextButton.styleFrom(
                      foregroundColor: CrmPalette.orange,
                    ),
                  ),
                ],
              ),
              if (_steps.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'No steps yet. You can save as a draft now and add steps later, but a sequence needs at least one step to be activated.',
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.35,
                      color: CrmPalette.textMuted,
                    ),
                  ),
                ),
              for (var i = 0; i < _steps.length; i++)
                _StepEditor(
                  key: ObjectKey(_steps[i]),
                  index: i,
                  draft: _steps[i],
                  onTypeChanged: (t) => setState(() => _steps[i].type = t),
                  onRemove: () => _removeStep(i),
                ),
              const SizedBox(height: 20),
              CrmPrimaryButton(text: 'Create Sequence', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepEditor extends StatelessWidget {
  final int index;
  final _StepDraft draft;
  final ValueChanged<SequenceStepType> onTypeChanged;
  final VoidCallback onRemove;

  const _StepEditor({
    super.key,
    required this.index,
    required this.draft,
    required this.onTypeChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CrmPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Step ${index + 1}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: CrmPalette.text,
                  ),
                ),
              ),
              InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, size: 18, color: CrmPalette.textMuted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CrmDropdownField<SequenceStepType>(
            label: 'Type',
            value: draft.type,
            items: SequenceStepType.values,
            labelOf: (t) => t.label,
            onChanged: (v) {
              if (v != null) onTypeChanged(v);
            },
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CrmTextField(
                  label: 'Subject / title',
                  controller: draft.title,
                  hint: 'e.g. Quick intro',
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 96,
                child: CrmTextField(
                  label: index == 0 ? 'Start (days)' : 'Wait (days)',
                  controller: draft.delay,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    return (n == null || n < 0) ? '0 or more' : null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
