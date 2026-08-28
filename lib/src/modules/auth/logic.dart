import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_bottom_navbar.dart';

class LoginLogic extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isSubmitting = false;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    update();
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    return null;
  }

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isSubmitting = true;
    update();

    try {
      // Replace this with your actual login API call.
      await Future.delayed(const Duration(seconds: 1));

      // Navigate after successful login.
      Get.off(()=> CustomBottomNavBarView());

    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting = false;
      update();
    }
  }

  void forgotPassword() {
    // TODO: Navigate to forgot password screen.
    //
    // Get.toNamed(AppRoutes.forgotPassword);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}