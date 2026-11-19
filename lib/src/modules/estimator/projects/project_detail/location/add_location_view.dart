import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/project_enums.dart';
import '../widgets/project_dropdown.dart';
import '../widgets/project_form_card.dart';
import 'add_location_logic.dart';

/// "Add Location" — pushed from the Location tab's Add Location button.
class AddLocationView extends StatelessWidget {
  final String projectId;
  const AddLocationView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddLocationLogic>(
      init: AddLocationLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Add Location',
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
                    'Add a new location to the project hierarchy',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 12),
                  ProjectFormCard(
                    children: [
                      CustomTextField(
                        heading: 'Name',
                        hintText: 'e.g., Building A, 2nd Floor, Room 201',
                        controller: logic.nameCtrl,
                      ),
                      projectFieldGap,
                      Obx(() => ProjectDropdown<LocationLevel>(
                            label: 'Level',
                            hint: 'Select level',
                            value: logic.level.value,
                            options: LocationLevel.values,
                            labelOf: (l) => l.label,
                            onChanged: (v) => logic.level.value = v ?? LocationLevel.building,
                          )),
                      projectFieldGap,
                      CustomTextField(
                        heading: 'Description (Optional)',
                        hintText: 'Additional details about this location',
                        controller: logic.descriptionCtrl,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  Obx(() => CustomButton(
                        text: 'Create',
                        onPressed: logic.isCreating.value ? null : logic.createLocation,
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
