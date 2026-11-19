import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../widgets/project_form_card.dart';
import 'create_sov_logic.dart';

/// "Create Schedule of Values" — pushed from New SOV. Title + Description;
/// the Create SOV button sits right under the card rather than pinned to
/// the bottom, matching the reference.
///
/// The reference's Title placeholder reads "Enter vendor name..." (it looks
/// carried over from the receipt form), so it's reworded to suit a title —
/// flagged in NOTES_PROCUREMENT_FINANCIALS.md.
class CreateSovView extends StatelessWidget {
  final String projectId;
  final String projectNumber;
  const CreateSovView({super.key, required this.projectId, this.projectNumber = ''});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateSovLogic>(
      init: CreateSovLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Create Schedule of Values',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    projectNumber.isEmpty
                        ? 'Create a new SOV pay application for this project'
                        : 'Create a new SOV pay application for project $projectNumber',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 12),
                  ProjectFormCard(
                    children: [
                      CustomTextField(
                        heading: 'Title',
                        hintText: 'Enter SOV title...',
                        controller: logic.titleCtrl,
                      ),
                      projectFieldGap,
                      CustomTextField(
                        heading: 'Description',
                        hintText: 'Notes about sov',
                        controller: logic.descriptionCtrl,
                        maxLines: 4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Obx(() => CustomButton(
                        text: 'Create SOV',
                        onPressed: logic.isCreating.value ? null : logic.create,
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
