import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'src/modules/splash/view.dart';
import 'src/utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeCollection.lightTheme,
      title: 'Smart Construction',
      home: SplashScreen(),
    );
  }
}

