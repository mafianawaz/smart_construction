import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';

import '../widgets/cfo_org_palette.dart';
import '../widgets/cfo_org_widgets.dart';
import 'logic.dart';

/// CFO → Add an Organization (fourth reference screen).
/// Pops with the created [CfoOrgInvite] on success.
class AddOrganizationView extends StatelessWidget {
  const AddOrganizationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CfoAddOrgLogic>(
      init: CfoAddOrgLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Add Organization',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter the email of the organization's admin.",
                  style: TextStyle(
                      fontSize: 10.5,
                      height: 1.4,
                      color: CfoOrgPalette.muted),
                ),
                const SizedBox(height: 12),
                CfoOrgCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      CfoOrgField(
                        label: 'Admin Email',
                        controller: logic.emailController,
                        hint: 'admin@company.com',
                        errorText: logic.emailError,
                        onChanged: logic.onEmailChanged,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: true,
                      ),
                      const SizedBox(height: 14),
                      CfoOrgField(
                        label: 'Personal Message (Optional)',
                        controller: logic.messageController,
                        hint: 'Add a short note to your invitation...',
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        neutralBorder: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                CfoOrgPrimaryButton(
                  label: 'Send Invite',
                  loading: logic.sending,
                  onPressed: logic.sendInvite,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
