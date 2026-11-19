import 'package:flutter/material.dart';

import 'rollup_palette.dart';

/// "Portfolio Rollup" title, orange Export Summary button, and subtitle.
class RollupHeader extends StatelessWidget {
  const RollupHeader({super.key, required this.onExport});

  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Portfolio Rollup',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: RollupPalette.text,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onExport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: RollupPalette.orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(0, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Export Summary'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Cross-project health, schedule, and financial view for executives',
            style: TextStyle(fontSize: 12, color: RollupPalette.muted),
          ),
        ],
      ),
    );
  }
}
