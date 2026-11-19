import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import 'cost_book_palette.dart';

/// Full-width solid orange button (Add Provider, Create, Add Region).
/// Local stand-in for the shared `CustomButton`; swap the body for it once
/// its import path is confirmed — every call site only passes text/onPressed.
class CostBookButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const CostBookButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, size: 16), const SizedBox(width: 6)],
            Text(
              text,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small outlined pill button ("+ Add Region").
class CostBookOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CostBookOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryOrange,
        side: BorderSide(color: AppColors.primaryOrange),
        minimumSize: const Size(0, 30),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Round 28px icon action (sync / edit / delete) used on provider and geo
/// cards.
class CostBookIconAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool destructive;
  final bool busy;

  const CostBookIconAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.destructive = false,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = destructive ? CostBookPalette.danger : AppColors.textMuted;
    return InkWell(
      onTap: busy ? null : onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: destructive ? CostBookPalette.dangerBg : CostBookPalette.iconBg,
        ),
        child: busy
            ? Padding(
                padding: const EdgeInsets.all(7),
                child: CircularProgressIndicator(
                  strokeWidth: 1.6,
                  color: AppColors.primaryOrange,
                ),
              )
            : Icon(icon, size: 14, color: color),
      ),
    );
  }
}
