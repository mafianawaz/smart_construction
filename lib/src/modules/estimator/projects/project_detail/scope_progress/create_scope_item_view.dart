import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../widgets/project_form_card.dart';
import 'create_scope_item_logic.dart';

/// "Create New Scope Items" — pushed from the Scope & Progress tab's
/// "New scope item" button (no tab bar behind it in the reference, so
/// it's its own route).
class CreateScopeItemView extends StatelessWidget {
  final String projectId;
  const CreateScopeItemView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateScopeItemLogic>(
      init: CreateScopeItemLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Create New Scope Items',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
              child: Column(
                children: [
                  ProjectFormCard(
                    children: [
                      CustomTextField(
                        heading: 'SOW(Scope of work)',
                        hintText: "e.g., 4' Sidewalk, Slab on Grade..",
                        controller: logic.nameCtrl,
                      ),
                      projectFieldGap,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              heading: 'Unit',
                              hintText: 'SF, CY, etc.',
                              controller: logic.unitCtrl,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              heading: 'Total Quantity',
                              hintText: '0',
                              controller: logic.quantityCtrl,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      projectFieldGap,
                      CustomTextField(
                        heading: 'Unit Price (\$)(optional)',
                        hintText: '0.00',
                        controller: logic.unitPriceCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                  Obx(() => CustomButton(
                        text: 'Create Scope Item',
                        onPressed: logic.isCreating.value ? null : logic.createScopeItem,
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
