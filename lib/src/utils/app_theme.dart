import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

class ThemeCollection {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryOrange,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    dividerColor: Colors.grey.shade300,
    shadowColor: Colors.black.withOpacity(0.05),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    fontFamily: 'Inter',
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryOrange,
    scaffoldBackgroundColor: Colors.black,
    cardColor: const Color(0xFF1C1C1E), // iOS dark surface
    dividerColor: const Color(0xFF2C2C2E),
    shadowColor: Colors.black,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    fontFamily: 'Inter',
  );
}
