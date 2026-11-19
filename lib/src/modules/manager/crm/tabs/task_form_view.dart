import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import '../models/crm_activity_models.dart';
import '../widgets/crm_date_field.dart';
import '../widgets/crm_form_fields.dart';
import '../widgets/crm_palette.dart';

/// New Task form. Pushed as its own route and returns the finished
/// [CrmTaskModel] via `Get.back(result: ...)`; the caller hands it to
/// `CrmLogic.addTask`.
///
/// The reference only shows the "New Task" buttons, so this layout is this
/// module's own design (see NOTES_CRM.md).
class TaskFormView extends StatefulWidget {
  final String id;
  final List<String> organizationNames;
  final List<String> owners;

  const TaskFormView({
    super.key,
    required this.id,
    required this.organizationNames,
    required this.owners,
  });

  @override
  State<TaskFormView> createState() => _TaskFormViewState();
}

class _TaskFormViewState extends State<TaskFormView> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _notes = TextEditingController();

  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.medium;
  String? _organization;
  String? _assignee;

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Get.back<CrmTaskModel>(
      result: CrmTaskModel(
        id: widget.id,
        title: _title.text.trim(),
        notes: _notes.text.trim(),
        dueDate: _dueDate,
        priority: _priority,
        organizationName: _organization,
        assignee: _assignee,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'New Task',
        subtitle: 'Create a follow-up to keep deals moving.',
        showBackButton: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              CrmTextField(
                label: 'Task title',
                controller: _title,
                hint: 'e.g. Send revised bid',
                isRequired: true,
              ),
              const SizedBox(height: 14),
              CrmTextField(
                label: 'Notes (optional)',
                controller: _notes,
                maxLines: 3,
                hint: 'Anything the assignee should know',
              ),
              const SizedBox(height: 14),
              CrmDateField(
                label: 'Due date (optional)',
                value: _dueDate,
                // Back-dating is allowed so logged follow-ups can be added
                // after the fact; the picker still starts at today.
                firstDate: DateTime(today.year - 1),
                lastDate: DateTime(today.year + 5),
                pickerHelp: 'Due date',
                onChanged: (d) => setState(() => _dueDate = d),
              ),
              const SizedBox(height: 14),
              CrmDropdownField<TaskPriority>(
                label: 'Priority',
                value: _priority,
                items: TaskPriority.values,
                labelOf: (p) => p.label,
                onChanged: (v) {
                  if (v != null) setState(() => _priority = v);
                },
              ),
              const SizedBox(height: 14),
              CrmDropdownField<String>(
                label: 'Related organization',
                value: _organization,
                items: widget.organizationNames,
                labelOf: (n) => n,
                nullLabel: 'None',
                onChanged: (v) => setState(() => _organization = v),
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
              CrmPrimaryButton(text: 'Create Task', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
