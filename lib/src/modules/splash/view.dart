import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/app_color.dart';
import '../../widgets/decorative_circle.dart';
import '../../widgets/logo_badge.dart';
import '../auth/view.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) =>  LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Top-right clipped circle
          DecorativeCircle(
            diameter: size.width * 0.55,
            alignment: Alignment.topRight,
            offsetX: size.width * 0.18,
            offsetY: -size.width * 0.18,
          ),
          // Bottom-left clipped circle
          DecorativeCircle(
            diameter: size.width * 0.5,
            alignment: Alignment.bottomLeft,
            offsetX: -size.width * 0.25,
            offsetY: -size.width * 0.13,
          ),

          // Center content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LogoBadge(size: 100,),
                  const SizedBox(height: 20),
                  Text(
                    'REALTEST CONSTRUCTION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Smart Manage',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your intelligent jobsite companion',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom loading bar + powered-by row
          Positioned(
            left: 0,
            right: 0,
            bottom: 36,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _controller.value,
                          minHeight: 3,
                          backgroundColor: AppColors.fieldBorder,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.primaryOrange,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Powered by SmartManageAI',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
