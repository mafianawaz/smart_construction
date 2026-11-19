import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

/// Peach-filled button with orange text — Daily Notes' "+ Add Entry".
/// `ProjectActionButton` only has solid-orange and white-outlined looks.
class SoftActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const SoftActionButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: AppColors.primaryOrange.withAlpha(30),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          child: Container(
            height: 44,
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: onPressed == null
                    ? AppColors.primaryOrange.withAlpha(120)
                    : AppColors.primaryOrange,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
