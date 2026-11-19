import 'package:flutter/material.dart';

import 'digest_palette.dart';
import 'digest_primitives.dart';

/// "No digest available / yet" panel with a peach document icon.
class DigestEmptyState extends StatelessWidget {
  const DigestEmptyState({
    super.key,
    required this.title,
    required this.message,
    required this.onGenerate,
    required this.isLoading,
    this.boxed = false,
  });

  final String title;
  final String message;
  final VoidCallback onGenerate;
  final bool isLoading;

  /// When true, wraps the content in its own bordered card (page-level empty
  /// state). Inside an organization card it is left unboxed.
  final bool boxed;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: DigestPalette.primaryTint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.description_outlined,
              size: 24,
              color: DigestPalette.muted,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: DigestPalette.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              height: 1.45,
              color: DigestPalette.body,
            ),
          ),
          const SizedBox(height: 16),
          DigestPrimaryButton(
            label: 'Generate Digest',
            onPressed: onGenerate,
            isLoading: isLoading,
          ),
        ],
      ),
    );

    if (!boxed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: content,
      );
    }
    return DigestCard(
      shadow: true,
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 24),
      child: content,
    );
  }
}
