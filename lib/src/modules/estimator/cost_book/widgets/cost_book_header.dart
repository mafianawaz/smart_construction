import 'package:flutter/material.dart';

import 'cost_book_palette.dart';

/// Circular back button + centred title. Plain widget, like `HomeAppBar`.
class CostBookHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const CostBookHeader({super.key, required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: onBack,
              customBorder: const CircleBorder(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: CostBookPalette.cardBorder),
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  size: 20,
                  color: CostBookPalette.ink,
                ),
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: CostBookPalette.ink,
            ),
          ),
        ],
      ),
    );
  }
}
