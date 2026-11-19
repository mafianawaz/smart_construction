import 'package:flutter/material.dart';
import '../../../../widgets/app_empty_filter.dart';
import 'rates_section_intro.dart';

/// Bordered empty-state card used by every tab that has no rows yet
/// (info icon + one line, e.g. "No salary categories yet").
class RatesEmptyCard extends StatelessWidget {
  final String message;

  const RatesEmptyCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return RatesCardShell(
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: AppEmptyState(
        icon: Icons.info_outline_rounded,
        title: message,
        message: '',
      ),
    );
  }
}
