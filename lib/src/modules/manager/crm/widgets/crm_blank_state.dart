import 'package:flutter/material.dart';

import 'crm_palette.dart';

/// Un-carded empty state used by the Tasks / Calls / Quotes tabs: icon (in a
/// grey circle when [circled]), bold title, muted message, optional button.
///
/// Distinct from `CrmEmptyState`, which is a bordered card.
class CrmBlankState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonLabel;
  final VoidCallback? onButton;
  final bool circled;

  const CrmBlankState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonLabel,
    this.onButton,
    this.circled = true,
  });

  @override
  Widget build(BuildContext context) {
    final glyph = Icon(icon, size: circled ? 28 : 38, color: CrmPalette.textMuted);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
      child: Column(
        children: [
          if (circled)
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: CrmPalette.chipFill,
                shape: BoxShape.circle,
              ),
              child: glyph,
            )
          else
            glyph,
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: CrmPalette.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              height: 1.35,
              color: CrmPalette.textMuted,
            ),
          ),
          if (buttonLabel != null && onButton != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onButton,
              style: ElevatedButton.styleFrom(
                backgroundColor: CrmPalette.orange,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonLabel!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
