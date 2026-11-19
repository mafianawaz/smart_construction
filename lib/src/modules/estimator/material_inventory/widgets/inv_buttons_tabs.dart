import 'package:flutter/material.dart';

import '../models/inventory_models.dart';
import 'inv_style.dart';

/// Solid orange button. [fullWidth] for Create buttons, compact for
/// "Post receive" style buttons that sit left-aligned under a form.
class InvPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final IconData? icon;

  const InvPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fullWidth = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: InvStyle.orange,
        foregroundColor: Colors.white,
        disabledBackgroundColor: InvStyle.orange.withOpacity(0.4),
        disabledForegroundColor: Colors.white,
        elevation: 0,
        minimumSize: Size(fullWidth ? double.infinity : 0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            const SizedBox(width: 6),
          ],
          Text(text,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

