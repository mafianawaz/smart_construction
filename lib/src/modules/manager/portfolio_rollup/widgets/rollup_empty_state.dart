import 'package:flutter/material.dart';

import 'rollup_palette.dart';

/// Local empty state (stand-in for the shared `AppEmptyState`).
class RollupEmptyState extends StatelessWidget {
  const RollupEmptyState({super.key, this.onClear});

  /// When provided, shows a "Clear filters" action.
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insights_outlined,
              size: 40, color: RollupPalette.muted),
          const SizedBox(height: 12),
          const Text(
            'No projects match these filters',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: RollupPalette.text,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try a different status, PM, date range or minimum health.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: RollupPalette.muted),
          ),
          if (onClear != null) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: onClear,
              child: const Text(
                'Clear filters',
                style: TextStyle(
                  color: RollupPalette.orange,
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
