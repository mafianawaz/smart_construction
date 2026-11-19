import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../../widgets/project_format.dart';

/// One row of the Markup Overrides card: bold label with an INHERITED /
/// OVERRIDDEN badge, a percentage input with up/down arrows, a "%" and
/// the muted "Org default: X%". Built on a plain `TextField` because the
/// shared `CustomTextField` has no stepper/suffix slot that is known to
/// exist — flagged in NOTES_ESTIMATING_TABS.md.
class MarkupOverrideField extends StatelessWidget {
  final String label;
  final double orgDefault;
  final bool overridden;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<double> onStep;
  final double stepSize;

  const MarkupOverrideField({
    super.key,
    required this.label,
    required this.orgDefault,
    required this.overridden,
    required this.controller,
    required this.onChanged,
    required this.onStep,
    this.stepSize = 0.5,
  });

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    final badgeColor = overridden ? AppColors.primaryOrange : Colors.grey.shade600;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: badgeColor.withAlpha(90)),
                ),
                child: Text(
                  overridden ? 'OVERRIDDEN' : 'INHERITED',
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: badgeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              SizedBox(
                width: 132,
                height: 38,
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Org: ${projectNumber(orgDefault)}%',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    enabledBorder: _border(Colors.grey.shade300),
                    focusedBorder: _border(AppColors.primaryOrange),
                    suffixIconConstraints: const BoxConstraints(minWidth: 26, minHeight: 36),
                    suffixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => onStep(stepSize),
                          child: Icon(Icons.keyboard_arrow_up,
                              size: 16, color: Colors.grey.shade600),
                        ),
                        InkWell(
                          onTap: () => onStep(-stepSize),
                          child: Icon(Icons.keyboard_arrow_down,
                              size: 16, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text('%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Org default: ${projectNumber(orgDefault)}%',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
