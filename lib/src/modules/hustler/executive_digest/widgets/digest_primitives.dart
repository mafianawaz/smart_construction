import 'package:flutter/material.dart';

import 'digest_palette.dart';

/// White rounded card with a hairline border (and optional soft shadow).
class DigestCard extends StatelessWidget {
  const DigestCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.shadow = false,
  });

  final Widget child;
  final EdgeInsets padding;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: DigestPalette.border),
        boxShadow: shadow
            ? const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(strokeWidth: 2, color: color),
    );
  }
}

/// Solid orange button, e.g. "Generate Digest".
class DigestPrimaryButton extends StatelessWidget {
  const DigestPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon = Icons.auto_awesome,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DigestPalette.primary,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: isLoading ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const _Spinner(color: Colors.white)
              else
                Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                isLoading ? 'Generating…' : label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-width muted bar used for the top "Generate Now" action.
class DigestGenerateBar extends StatelessWidget {
  const DigestGenerateBar({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.hasReports,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  /// Shows a refresh icon (regenerate) instead of the sparkle icon.
  final bool hasReports;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DigestPalette.chipFill,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isLoading ? null : onPressed,
        child: SizedBox(
          height: 46,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const _Spinner(color: DigestPalette.barText)
              else
                Icon(
                  hasReports ? Icons.refresh_rounded : Icons.auto_awesome,
                  size: 16,
                  color: DigestPalette.barText,
                ),
              const SizedBox(width: 8),
              Text(
                isLoading ? 'Generating…' : 'Generate Now',
                style: const TextStyle(
                  color: DigestPalette.barText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Peach, full-width button ("Generate Portfolio Digest").
class DigestTonalButton extends StatelessWidget {
  const DigestTonalButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DigestPalette.primaryTint,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: isLoading ? null : onPressed,
        child: SizedBox(
          height: 44,
          child: Center(
            child: isLoading
                ? const _Spinner(color: DigestPalette.primary)
                : Text(
                    label,
                    style: const TextStyle(
                      color: DigestPalette.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Small outlined button used in each organization card header.
class DigestOutlineButton extends StatelessWidget {
  const DigestOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: DigestPalette.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: isLoading ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: isLoading
              ? const _Spinner(color: DigestPalette.primary)
              : Text(
                  label,
                  style: const TextStyle(
                    color: DigestPalette.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
