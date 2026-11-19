import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import '../../../../utils/app_color.dart';
import '../logic.dart';


class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, required this.logic});

  final AccountSettingsLogic logic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AvatarPicker(logic: logic),
        const SizedBox(height: 20),
        Text(
          'Profile & Account',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage your personal information and details',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 24),
        CustomTextField(
              heading: 'First Name',
              hintText: 'e.g. John',
              controller: logic.firstNameController,
              isMuted: true,
            ),
        const SizedBox(height: 15),
        CustomTextField(
              heading: 'Last Name',
              hintText: 'e.g. Doe',
              controller: logic.lastNameController,
              isMuted: true,
            ),
        const SizedBox(height: 15),
        CustomTextField(
          heading: 'Email',
          hintText: 'e.g. john@example.com',
          controller: logic.emailController,
          isMuted: true,
        ),
        const SizedBox(height: 15),
        CustomTextField(
          heading: 'Phone',
          hintText: 'e.g. 555-100-0000',
          controller: logic.phoneController,
          isMuted: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          heading: 'Organization',
          hintText: 'e.g. Acme Construction',
          controller: logic.organizationController,
          isMuted: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          heading: 'Role',
          hintText: 'Field Worker',
          controller: logic.roleController,
          isMuted: true,
          readOnly: true,
          isFilled: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          heading: 'Access Level',
          hintText: 'Organization',
          controller: logic.accessLevelController,
          isMuted: true,
          readOnly: true,
          isFilled: true,
        ),
        const SizedBox(height: 24),
        Text(
          'Emergency Contact',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          heading: 'Emergency Contact Name',
          hintText: 'e.g. Jane Doe',
          controller: logic.emergencyContactNameController,
          isMuted: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          heading: 'Emergency Phone',
          hintText: 'e.g. 555-100-0001',
          controller: logic.emergencyPhoneController,
          isMuted: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          heading: 'Emergency Email',
          hintText: 'e.g. jane@example.com',
          controller: logic.emergencyEmailController,
          isMuted: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          heading: 'Emergency Address',
          hintText: 'e.g. 123 Main St',
          controller: logic.emergencyAddressController,
          isMuted: true,
        ),
        const SizedBox(height: 15),
        CustomTextField(
          heading: 'Profile Description',
          hintText: 'Tell us about yourself...',
          controller: logic.profileDescriptionController,
          maxLines: 4,
          isMuted: true,
        ),
        const SizedBox(height: 24),
        CustomButton(
          text: 'Save Changes',
          isLoading: logic.profileSaving,
          onPressed: logic.saveProfile,
        ),
      ],
    );
  }
}


class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({required this.logic});

  final AccountSettingsLogic logic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: logic.pickAvatarImage,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.fieldFill,
            backgroundImage:
                logic.avatarImagePath != null ? AssetImage(logic.avatarImagePath!) : null,
            child: logic.avatarImagePath == null
                ? Icon(Icons.person, size: 36, color: AppColors.textMuted)
                : null,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
              child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
