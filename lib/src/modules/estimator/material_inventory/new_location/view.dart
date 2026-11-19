import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import '../models/inventory_models.dart';
import '../widgets/inv_buttons_tabs.dart';
import '../widgets/inv_inputs.dart';
import '../widgets/inv_style.dart';
import 'logic.dart';

/// New Location form. Pops with the created `StockLocation`.
class NewLocationView extends StatelessWidget {
  final Set<String> existingCodes;

  const NewLocationView({super.key, required this.existingCodes});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewLocationLogic>(
      init: NewLocationLogic(existingCodes: existingCodes),
      builder: (logic) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppPrimaryBar(
            title: 'New Location',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add a new storage or staging location for equipment tracking.',
                    style: TextStyle(fontSize: 12, color: InvStyle.muted),
                  ),
                  const SizedBox(height: 16),
                  InvField(
                    label: 'Code',
                    hint: '',
                    controller: logic.codeCtrl,
                    autofocus: true,
                    errorText: logic.errors['code'],
                    onChanged: (_) => logic.clearError('code'),
                  ),
                  InvField(
                    label: 'Name',
                    hint: 'e.g., Main Yard',
                    controller: logic.nameCtrl,
                    errorText: logic.errors['name'],
                    onChanged: (_) => logic.clearError('name'),
                  ),
                  InvDropdown<LocationType>(
                    label: 'Type',
                    hint: 'Select type',
                    value: logic.type,
                    options: [
                      for (final t in LocationType.values)
                        InvOption(t, t.label),
                    ],
                    onChanged: logic.setType,
                  ),
                  InvField(
                    label: 'Address',
                    hint: 'Street address, city, state, zip',
                    controller: logic.addressCtrl,
                    keyboardType: TextInputType.streetAddress,
                  ),
                  InvField(
                    label: 'Notes',
                    hint: 'Additional notes or details...',
                    controller: logic.notesCtrl,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 8),
                  InvPrimaryButton(
                    text: 'Create',
                    fullWidth: true,
                    onPressed: logic.create,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
