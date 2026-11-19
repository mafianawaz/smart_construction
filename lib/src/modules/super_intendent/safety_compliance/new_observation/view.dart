import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../../../widgets/custom_dropdown_button.dart';
import '../data/safety_mock_data.dart';
import '../models/safety_models.dart';
import '../widgets/safety_common_widgets.dart';
import '../widgets/safety_header.dart';
import '../widgets/safety_palette.dart';
import 'logic.dart';

/// "+ New Observation" form. Pops with the created [SafetyObservation].
/// The reference has no screen for this, so the layout is my own design.
class NewObservationView extends StatelessWidget {
  const NewObservationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewObservationLogic>(
      init: NewObservationLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'New Observation',
            subtitle: 'Record a safe or at-risk behaviour or condition.',
            showBackButton: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SafetyCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDropdown<String>(
                            heading: 'Category',
                            value: logic.category,
                            items: SafetyMockData.observationCategories,
                            onChanged: logic.setCategory,
                            itemLabel: (item) => item,
                          ),
                          const SizedBox(height: 16),
                          const _Label('Type'),
                          Wrap(
                            spacing: 8,
                            children: [
                              for (final t in ObservationType.values)
                                _ChoicePill(
                                  label: t.displayName,
                                  selected: logic.type == t,
                                  onTap: () => logic.setType(t),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const _Label('Severity'),
                          Wrap(
                            spacing: 8,
                            children: [
                              for (final s in ObservationSeverity.values)
                                _ChoicePill(
                                  label: s.displayName,
                                  selected: logic.severity == s,
                                  onTap: () => logic.setSeverity(s),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            heading: 'Description',
                            hintText: 'Where did you observe?',
                            controller: logic.descriptionController,
                            onChange: logic.onDescriptionChanged,
                            maxLines: 4,
                          ),
                          const SizedBox(height: 16),
                          const _Label('Observer'),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: SafetyPalette.surfaceMuted,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              SafetyMockData.currentObserverName,
                              style: TextStyle(
                                fontSize: 13,
                                color: SafetyPalette.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: logic.submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SafetyPalette.orange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('Submit Observation'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _decoration({required String hint, String? error}) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: SafetyPalette.textFaint),
      errorText: error,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: border(SafetyPalette.border),
      focusedBorder: border(SafetyPalette.orange),
      errorBorder: border(SafetyPalette.red),
      focusedErrorBorder: border(SafetyPalette.red),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: SafetyPalette.textDark,
        ),
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? SafetyPalette.orangeSoft : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? SafetyPalette.orange : SafetyPalette.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? SafetyPalette.orange : SafetyPalette.textDark,
          ),
        ),
      ),
    );
  }
}
