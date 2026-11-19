import 'package:flutter/material.dart';

import 'digest_palette.dart';

/// Circular back button + centered title.
class DigestHeader extends StatelessWidget {
  const DigestHeader({super.key, required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: SizedBox(
        height: 44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onBack,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: DigestPalette.border),
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    size: 22,
                    color: DigestPalette.text,
                  ),
                ),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: DigestPalette.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
