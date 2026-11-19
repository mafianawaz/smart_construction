import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/cfo_org_models.dart';
import '../widgets/cfo_org_palette.dart';
import '../widgets/cfo_org_widgets.dart';
import 'logic.dart';

/// CFO → Invite Executive (second reference screen).
///
/// Pops with the created [CfoExecutive] on success.
class InviteExecutiveView extends StatelessWidget {
  const InviteExecutiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CfoInviteLogic>(
      init: CfoInviteLogic(),
      builder: (logic) {
        return Scaffold(
          backgroundColor: CfoOrgPalette.page,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CfoOrgHeaderBar(title: 'Invite Executive'),
                  const SizedBox(height: 12),
                  const Text(
                    'Invite a COO, CFO, or other executive to help manage '
                    'your organizations.',
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
                          label: 'Email Address',
                          controller: logic.emailController,
                          hint: 'coo@company.com',
                          errorText: logic.emailError,
                          onChanged: logic.onEmailChanged,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 14),
                        CfoOrgDropdownField<CfoExecRole>(
                          label: 'Role',
                          value: logic.role,
                          items: CfoExecRole.values,
                          labelOf: (r) => r.label,
                          onChanged: logic.selectRole,
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
          ),
        );
      },
    );
  }
}
