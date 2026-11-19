import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

/// Orange-filled or white-outlined button with an optional leading icon —
/// the "New scope item" / "Add Usage" / "Import Takeoff" family in the
/// estimating references. `CustomButton` only takes text + onPressed, so
/// icon and outlined variants live here. Pass `expand: false` for the
/// compact inline version ("+ Add Item").
class ProjectActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool filled;
  final bool expand;
  final double height;

  const ProjectActionButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.filled = true,
    this.expand = true,
    this.height = 44,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final bg = filled
        ? (disabled ? AppColors.primaryOrange.withAlpha(120) : AppColors.primaryOrange)
        : Colors.white;
    final fg = filled ? Colors.white : AppColors.textDark;

    final button = Material(
      color: bg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: expand ? 12 : 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: filled ? null : Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: fg),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: fg),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
