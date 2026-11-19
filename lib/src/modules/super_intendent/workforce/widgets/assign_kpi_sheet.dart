import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_textfield.dart';
import '../models/kpi_model.dart';
import 'wf_common.dart';
import 'wf_palette.dart';

/// Bottom sheet behind the "Assign KPI" button. Pops the new [KpiAssignment].
/// No reference design — layout is my own (see NOTES).
class AssignKpiSheet extends StatefulWidget {
  const AssignKpiSheet({
    super.key,
    required this.employees,
    required this.templates,
    required this.periods,
  });

  final List<KpiEmployee> employees;
  final List<KpiTemplate> templates;
  final List<String> periods;

  @override
  State<AssignKpiSheet> createState() => _AssignKpiSheetState();
}

class _AssignKpiSheetState extends State<AssignKpiSheet> {
  late KpiEmployee _employee = widget.employees.first;
  late KpiTemplate _template = widget.templates.first;
  late String _period = widget.periods.first;
  late final TextEditingController _target = TextEditingController(
    text: _template.target == null ? '' : wfNum(_template.target!),
  );

  @override
  void dispose() {
    _target.dispose();
    super.dispose();
  }

  void _submit() {
    final raw = _target.text.trim();
    final target = raw.isEmpty ? null : double.tryParse(raw);
    if (raw.isNotEmpty && target == null) {
      Get.snackbar('Invalid target', 'Enter a number, e.g. 10.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    Get.back(
      result: KpiAssignment(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        employeeId: _employee.id,
        employeeName: _employee.name,
        roleCode: _employee.roleCode,
        kpiId: _template.id,
        kpiName: _template.name,
        category: _template.category,
        unit: _template.unit,
        target: target,
        period: _period,
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          t,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: WfPalette.text,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: WfPalette.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assign KPI',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: WfPalette.text),
            ),
            const SizedBox(height: 2),
            const Text(
              'Pick an employee, a KPI template and a period.',
              style: TextStyle(fontSize: 11, color: WfPalette.muted),
            ),
            const SizedBox(height: 14),
            _label('Employee'),
            CustomDropdown<KpiEmployee>(
              value: _employee,
              items: widget.employees,
              itemLabel: (e) => '${e.name} (${e.roleCode})',
              onChanged: (v) {
                if (v != null) setState(() => _employee = v);
              },
            ),
            const SizedBox(height: 12),
            _label('KPI'),
            CustomDropdown<KpiTemplate>(
              value: _template,
              items: widget.templates,
              itemLabel: (t) => t.name,
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  _template = v;
                  _target.text = v.target == null ? '' : wfNum(v.target!);
                });
              },
            ),
            const SizedBox(height: 12),
            _label('Period'),
            CustomDropdown<String>(
              value: _period,
              items: widget.periods,
              itemLabel: (p) => p,
              onChanged: (v) {
                if (v != null) setState(() => _period = v);
              },
            ),
            const SizedBox(height: 12),
            CustomTextField(
              heading: 'Target (${_template.unit})',
              hintText: 'e.g. 10',
              controller: _target,
              keyboardType: TextInputType.number,
              isFilled: true,
            ),
            const SizedBox(height: 16),
            CustomButton(text: 'Assign KPI', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
