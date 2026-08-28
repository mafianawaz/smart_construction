import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import '../../utils/app_color.dart';
import '../../widgets/app_textfield.dart';
import '../../widgets/logo_badge.dart';
import 'package:get/get.dart';
import 'logic.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginLogic controller = Get.put(LoginLogic());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginLogic>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const Center(
                      child: LogoBadge(
                        size: 100,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your projects, tracks, and team\n''collaboration in one space.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      heading: 'Email Address',
                      controller: controller.emailController,
                      hintText: 'name@company.com',
                      leftIconPath: AppIcons.email,
                      keyboardType: TextInputType.emailAddress,
                      validate: controller.validateEmail,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      heading: 'Password',
                      controller: controller.passwordController,
                      hintText: '••••••••••',
                      leftIconPath: AppIcons.password,
                      obscureText: controller.obscurePassword,
                      onTogglePasswordStatus:
                      controller.togglePasswordVisibility,
                      onSubmit: (_) => controller.login(),
                      validate: controller.validatePassword,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: controller.forgotPassword,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'Login',
                      onPressed: controller.login,
                      isLoading: controller.isSubmitting,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

