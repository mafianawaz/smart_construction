import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/custom_dropdown_button.dart';

/// Labelled select on the shared `CustomDropdown`, same configuration the
/// Add Risk form uses (its private `_LabeledDropdown`). Extracted here so
/// the estimating forms don't each re-declare it; Add Risk can switch to
/// this whenever convenient.
class ProjectDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> options;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;

  const ProjectDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<T>(
      heading: label,
      fontSize: 10,
      value: value,
      hintText: hint,
      items: options,
      itemLabel: (item) => labelOf(item),
      onChanged: onChanged,
    );
  }
}
