import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_color.dart';
import '../models/cost_book_models.dart';
import '../widgets/cost_book_buttons.dart';
import '../widgets/cost_book_field.dart';
import '../widgets/cost_book_header.dart';
import '../widgets/cost_book_palette.dart';
import 'logic.dart';

/// Add Provider / Edit Provider. Pass [initial] to edit; the page pops with
/// the finished `CostBookProviderModel`.
class ProviderFormView extends StatelessWidget {
  final CostBookProviderModel? initial;

  const ProviderFormView({super.key, this.initial});

  @override
  Widget build(BuildContext context) {
    // Local (non-global) controller: disposed with the route, no tag needed.
    return GetBuilder<ProviderFormLogic>(
      init: ProviderFormLogic(initial: initial),
      global: false,
      builder: (logic) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CostBookHeader(
                    title: logic.isEdit ? 'Edit Provider' : 'Add Provider',
                    onBack: Get.back,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: _form(logic),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _form(ProviderFormLogic logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configure a cost-book source. Use API endpoint + key env var for '
          'external providers.',
          style: TextStyle(fontSize: 11, height: 1.4, color: AppColors.textMuted),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CostBookPalette.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => CostBookField(
                  heading: 'Name',
                  hintText: 'e.g. RSMeans 2025',
                  controller: logic.nameController,
                  errorText: logic.nameError.value,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              const SizedBox(height: 12),
              _kindDropdown(logic),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Obx(
                      () => CostBookField(
                        heading: 'API Endpoint',
                        hintText: 'https://...',
                        controller: logic.endpointController,
                        keyboardType: TextInputType.url,
                        errorText: logic.endpointError.value,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CostBookField(
                      heading: 'API Key Env Var',
                      hintText: 'RSMEANS_API_...',
                      controller: logic.keyEnvController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CostBookField(
                heading: 'Default Region',
                hintText: 'e.g. NATIONAL_AVG',
                controller: logic.regionController,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 12),
              CostBookField(
                heading: 'Notes',
                hintText: 'Additional notes or configuration details...',
                controller: logic.notesController,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Obx(
                    () => Switch(
                      value: logic.isActive.value,
                      onChanged: logic.setActive,
                      activeColor: Colors.white,
                      activeTrackColor: AppColors.primaryOrange,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: CostBookPalette.ink,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // The Figma Edit frame still says "Create" — treated as a copy slip.
        CostBookButton(
          text: logic.isEdit ? 'Save Changes' : 'Create',
          onPressed: logic.submit,
        ),
      ],
    );
  }

  Widget _kindDropdown(ProviderFormLogic logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Provider Kind',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: CostBookPalette.ink,
          ),
        ),
        const SizedBox(height: 6),
        Obx(
          () => DropdownButtonFormField<ProviderKind>(
            value: logic.kind.value,
            isDense: true,
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted,
            ),
            style: const TextStyle(fontSize: 12, color: CostBookPalette.ink),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: CostBookPalette.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primaryOrange),
              ),
            ),
            items: [
              for (final k in ProviderKind.values)
                DropdownMenuItem(value: k, child: Text(k.label)),
            ],
            onChanged: logic.setKind,
          ),
        ),
      ],
    );
  }
}
