import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import '../../../utils/app_color.dart';
import '../../../widgets/app_empty_filter.dart';
import 'crew_template_form/view.dart';
import 'logic.dart';
import 'models/crew_models.dart';
import 'widgets/crew_buttons.dart';
import 'widgets/crew_palette.dart';
import 'widgets/crew_template_card.dart';

/// Crew Templates list: New Template button + Templates section (empty
/// state, or one card per template).
class CrewTemplatesView extends StatelessWidget {
  const CrewTemplatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CrewTemplatesLogic(),
      builder: (logic){
      return Scaffold(
        appBar: AppPrimaryBar(
          title: 'Crew Templates',
          showBackButton: true,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reusable crew compositions for estimating — workers, '
                    'equipment, and daily set-up cost.',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.4,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 14),
              CustomIconButton(
                text: 'New Template',
                icon: AppIcons.add,
                onPressed: () => _open(logic),
              ),
              const SizedBox(height: 18),
              const Text(
                'Templates',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: CrewPalette.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Open a template to edit its workers and equipment. Daily '
                    'cost is recomputed automatically.',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.4,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),
              Obx(() {
                final items = logic.templates;
                if (items.isEmpty) return const _EmptyTemplates();
                return Column(
                  children: [
                    for (var i = 0; i < items.length; i++) ...[
                      if (i > 0) const SizedBox(height: 10),
                      CrewTemplateCard(
                        template: items[i],
                        onEdit: () => _open(logic, initial: items[i]),
                        onDelete: () => _confirmDelete(logic, items[i]),
                      ),
                    ],
                  ],
                );
              }),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _open(
    CrewTemplatesLogic logic, {
    CrewTemplateModel? initial,
  }) async {
    final result = await Get.to<CrewTemplateModel>(
      () => CrewTemplateFormView(initial: initial),
    );
    if (result != null) logic.saveTemplate(result);
  }

  void _confirmDelete(CrewTemplatesLogic logic, CrewTemplateModel t) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete template?', style: TextStyle(fontSize: 15)),
        content: Text(
          'Remove ${t.name} (${t.code})?',
          style: const TextStyle(fontSize: 12),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              logic.deleteTemplate(t.id);
            },
            child: Text('Delete', style: TextStyle(color: AppColors.redColor)),
          ),
        ],
      ),
    );
  }
}

class _EmptyTemplates extends StatelessWidget {
  const _EmptyTemplates();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CrewPalette.cardBorder),
      ),
      child: AppEmptyState(
        icon: Icons.groups_2_outlined,
        title: 'No Crew templates yet.',
        message: 'Create one via the button for pricing.',
        showButton: false,
      ),
    );
  }
}
