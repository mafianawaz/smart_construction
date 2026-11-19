import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

/// Tap-to-pick date field on the shared `CustomTextField` (read-only, tap
/// opens `showDatePicker`). Unlike `JobInfoDateField` it keeps one
/// controller for its lifetime, and takes the hint/format so it can show
/// both "Pick a date" and "dd/mm/yyyy". Relies on the same assumed
/// `readOnly` + `onClick` params on `CustomTextField` that
/// `JobInfoDateField` already uses.
class ProjectDateField extends StatefulWidget {
  final String label;
  final String hint;
  final String format;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  const ProjectDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint = 'Pick a date',
    this.format = 'MMM d, y',
  });

  @override
  State<ProjectDateField> createState() => _ProjectDateFieldState();
}

class _ProjectDateFieldState extends State<ProjectDateField> {
  late final TextEditingController _controller;

  String _text(DateTime? d) => d == null ? '' : DateFormat(widget.format).format(d);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _text(widget.value));
  }

  @override
  void didUpdateWidget(covariant ProjectDateField old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) _controller.text = _text(widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.value ?? now,
      firstDate: DateTime(now.year - 3),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) widget.onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      heading: widget.label,
      hintText: widget.hint,
      controller: _controller,
      readOnly: true,
      onClick: _pick,
    );
  }
}
