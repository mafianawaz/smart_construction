import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_icons.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/toggle_field_row.dart';
import '../logic.dart';


class SecurityTab extends StatelessWidget {
  const SecurityTab({super.key, required this.logic});

  final AccountSettingsLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.fieldBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                'Update your password to keep your account secure',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                heading: 'Current Password',
                hintText: 'Enter current password',
                onTogglePasswordStatus: logic.toggleCurrentPasswordVisible,
                controller: logic.currentPasswordController,
                obscureText: logic.currentPasswordVisible,
                isMuted: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                heading: 'New Password',
                hintText: 'Enter new password',
                controller: logic.newPasswordController,
                obscureText: logic.newPasswordVisible,
                onTogglePasswordStatus: logic.toggleNewPasswordVisible,
                isMuted: true,
              ),
              const SizedBox(height: 4),
              Text(
                'Must include uppercase, lowercase, number, and special character',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                heading: 'Confirm New Password',
                hintText: 'Re-enter new password',
                controller: logic.confirmPasswordController,
                obscureText: logic.confirmPasswordVisible,
                onTogglePasswordStatus: logic.toggleConfirmPasswordVisible,
                isMuted: true,
              ),
              if (logic.passwordError != null) ...[
                const SizedBox(height: 12),
                Text(
                  logic.passwordError!,
                  style: const TextStyle(fontSize: 12, color: Color(0xFFDC2626)),
                ),
              ],
              const SizedBox(height: 20),
              CustomIconButton(
                text: 'Change Password',
                icon: AppIcons.password,
                isLoading: logic.passwordSaving,
                onPressed: logic.changePassword,
                color: AppColors.redColor,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        ToggleFieldRow(
          label: 'Face lock / Finger Print',
          subtitle: 'Enable face lock or fingerprint security',
          value: logic.faceLockEnabled,
          onChanged: logic.toggleFaceLock,
        ),
        ToggleFieldRow(
          label: 'Two Factor Authentication',
          subtitle: 'Add an extra layer of security',
          value: logic.twoFactorEnabled,
          onChanged: logic.toggleTwoFactor,
        ),
      ],
    );
  }
}
