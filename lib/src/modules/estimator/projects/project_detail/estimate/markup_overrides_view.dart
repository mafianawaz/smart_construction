import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/project_enums.dart';
import '../../widgets/project_badge.dart';
import '../widgets/project_form_card.dart';
import '../widgets/project_format.dart';
import 'markup_overrides_logic.dart';

/// "Markup Overrides" — pushed from the Estimate tab's Markups button.
/// Seven rows (label + INHERITED/OVERRIDDEN badge, a percent field, the
/// org default) in one card, with Save Override pinned below.
class MarkupOverridesView extends StatelessWidget {
  final String projectId;
  const MarkupOverridesView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarkupOverridesLogic>(
      init: MarkupOverridesLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Markup Overrides',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Per-Estimate Markup Override',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(
                          'Override the org-wide estimating markups for this estimate only. '
                          'Inputs are pre-filled with the current override (or left blank to '
                          'show the org default as a placeholder). Each field shows whether '
                          'its value is overridden or inherited from the org default. '
                          'Changes are audit-logged.',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 12),
                        ProjectFormCard(
                          children: [
                            for (final kind in MarkupKind.values) ...[
                              _MarkupRow(logic: logic, kind: kind),
                              if (kind != MarkupKind.values.last) projectFieldGap,
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Obx(() => CustomButton(
                        text: 'Save Override',
                        onPressed: logic.isSaving.value ? null : logic.save,
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MarkupRow extends StatelessWidget {
  final MarkupOverridesLogic logic;
  final MarkupKind kind;
  const _MarkupRow({required this.logic, required this.kind});

  @override
  Widget build(BuildContext context) {
    final orgText = projectPercent(logic.orgDefault(kind));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(kind.label,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ),
            Obx(() {
              final over = logic.overridden[kind]!.value;
              return ProjectBadge(
                label: over ? 'OVERRIDDEN' : 'INHERITED',
                background: over ? const Color(0xFFFFE8D6) : Colors.grey.shade200,
                foreground: over ? const Color(0xFFC2410C) : Colors.grey.shade700,
              );
            }),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 130,
              child: CustomTextField(
                hintText: 'Org: $orgText',
                controller: logic.controllers[kind],
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChange: (v) => logic.onChanged(kind, v!),
              ),
            ),
            const SizedBox(width: 6),
            Text('%', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(width: 10),
            Text('Org default: $orgText',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
      ],
    );
  }
}
