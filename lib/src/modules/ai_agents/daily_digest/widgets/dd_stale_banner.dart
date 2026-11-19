import 'package:flutter/material.dart';

import 'dd_palette.dart';

/// Stale-schedule banner with an "Update progress now" CTA.
class DdStaleBanner extends StatelessWidget {
  final String message;
  final VoidCallback onUpdateTap;

  const DdStaleBanner({
    super.key,
    required this.message,
    required this.onUpdateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DdPalette.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DdPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: 15,
            color: DdPalette.textPrimary,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: DdPalette.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: onUpdateTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: DdPalette.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Update progress now',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
